function result = find_single_sector_resonances(cfg,varargin)
%FIND_SINGLE_SECTOR_RESONANCES Find complex resonances of one sector cavity.
%   RESULT = FIND_SINGLE_SECTOR_RESONANCES(CFG) searches a user-specified
%   rectangle in the complex-frequency plane.  At every trial frequency it
%   calls
%
%       [A,state] = operatorAtFrequency(f,cfg)
%
%   where f is in Hz.  The search uses an equilibrated smallest singular
%   value; it never evaluates an unscaled determinant and never reads a
%   COMSOL frequency as a fit target or an initial pole.
%
%   Name-value options (CFG.search.<lowerCamelName> supplies the defaults):
%       RealRangeHz           [1200 1900]
%       ImagRangeHz           [0 250]
%       GridSize              [91 51]     [number real, number imaginary]
%       MaxCandidates         200
%       ResidualTolerance     1e-6
%       DuplicateToleranceHz  1e-4
%       MinimaRelativeSlack   1e-10
%       FminMaxIterations     350
%       FminMaxEvaluations    1200
%       UseFsolve             true
%       PhysicalFilter        []          function handle (f,state,v,A)
%       InitialSeedsHz        []          independent analytic seed list
%       Verbose               true
%
%   RESULT.rootsHz contains the unique accepted physical roots.
%   RESULT.residual is ||A*v||_2/(||A||_F*||v||_2), and
%   RESULT.nullVectors is a cell array containing the corresponding right
%   null vectors in the unscaled operator coordinates.  Coarse-grid and
%   rejected-candidate diagnostics are retained in RESULT for convergence
%   and completeness checks.

    narginchk(1,inf);
    if ~isstruct(cfg)
        error('find_single_sector_resonances:InvalidConfig', ...
            'cfg must be a structure accepted by build_single_sector_operator.');
    end

    defaults = search_defaults(cfg);
    ip = inputParser;
    ip.FunctionName = mfilename;
    ip.addParameter('RealRangeHz',defaults.realRangeHz,@is_two_finite_reals);
    ip.addParameter('ImagRangeHz',defaults.imagRangeHz,@is_two_finite_reals);
    ip.addParameter('GridSize',defaults.gridSize,@is_grid_size);
    ip.addParameter('MaxCandidates',defaults.maxCandidates,@is_positive_integer);
    ip.addParameter('ResidualTolerance',defaults.residualTolerance,@is_positive_scalar);
    ip.addParameter('DuplicateToleranceHz',defaults.duplicateToleranceHz,@is_nonnegative_scalar);
    ip.addParameter('MinimaRelativeSlack',defaults.minimaRelativeSlack,@is_nonnegative_scalar);
    ip.addParameter('FminMaxIterations',defaults.fminMaxIterations,@is_positive_integer);
    ip.addParameter('FminMaxEvaluations',defaults.fminMaxEvaluations,@is_positive_integer);
    ip.addParameter('UseFsolve',defaults.useFsolve,@is_logical_scalar);
    ip.addParameter('PhysicalFilter',defaults.physicalFilter, ...
        @(x)isempty(x) || isa(x,'function_handle'));
    ip.addParameter('InitialSeedsHz',[],@(x)isnumeric(x)&&isvector(x));
    ip.addParameter('Verbose',defaults.verbose,@is_logical_scalar);
    ip.parse(varargin{:});
    opt = ip.Results;

    opt.RealRangeHz = sort(double(opt.RealRangeHz(:).'));
    opt.ImagRangeHz = sort(double(opt.ImagRangeHz(:).'));
    opt.GridSize = round(double(opt.GridSize(:).'));
    opt.MaxCandidates = round(double(opt.MaxCandidates));
    opt.FminMaxIterations = round(double(opt.FminMaxIterations));
    opt.FminMaxEvaluations = round(double(opt.FminMaxEvaluations));
    opt.UseFsolve = logical(opt.UseFsolve);
    opt.Verbose = logical(opt.Verbose);

    fr = linspace(opt.RealRangeHz(1),opt.RealRangeHz(2),opt.GridSize(1));
    fi = linspace(opt.ImagRangeHz(1),opt.ImagRangeHz(2),opt.GridSize(2));
    metric = inf(numel(fi),numel(fr));
    failed = false(size(metric));

    if opt.Verbose
        fprintf('Complex-frequency coarse scan: Re %.6g--%.6g Hz, ', ...
            opt.RealRangeHz(1),opt.RealRangeHz(2));
        fprintf('Im %.6g--%.6g Hz, grid %d x %d.\n', ...
            opt.ImagRangeHz(1),opt.ImagRangeHz(2),numel(fr),numel(fi));
    end

    for jj = 1:numel(fi)
        for ii = 1:numel(fr)
            f = complex(fr(ii),fi(jj));
            [metric(jj,ii),ok] = singular_metric_at(f,cfg);
            failed(jj,ii) = ~ok;
        end
        if opt.Verbose && (jj == 1 || jj == numel(fi) || mod(jj,max(1,ceil(numel(fi)/10))) == 0)
            fprintf('  coarse row %d/%d completed\n',jj,numel(fi));
        end
    end

    seedIndex = select_seed_indices(metric,opt.MaxCandidates,opt.MinimaRelativeSlack);
    [seedImagIndex,seedRealIndex] = ind2sub(size(metric),seedIndex);
    frColumn = fr(:);
    fiColumn = fi(:);
    seedHz = complex(frColumn(seedRealIndex(:)),fiColumn(seedImagIndex(:)));
    seedHz = seedHz(:);
    if ~isempty(opt.InitialSeedsHz)
        extra=opt.InitialSeedsHz(:);
        inside=real(extra)>=opt.RealRangeHz(1)&real(extra)<=opt.RealRangeHz(2)& ...
            imag(extra)>=opt.ImagRangeHz(1)&imag(extra)<=opt.ImagRangeHz(2);
        seedHz=[seedHz;extra(inside)];
        seedHz=unique(round(real(seedHz),8)+1i*round(imag(seedHz),8),'stable');
    end

    if opt.Verbose
        fprintf('Refining %d independent coarse candidates.\n',numel(seedHz));
    end

    candidates = repmat(empty_candidate(),numel(seedHz),1);
    for kk = 1:numel(seedHz)
        candidates(kk) = refine_candidate(seedHz(kk),cfg,opt);
        if opt.Verbose && (kk == 1 || kk == numel(seedHz) || mod(kk,max(1,ceil(numel(seedHz)/10))) == 0)
            fprintf('  refined candidate %d/%d\n',kk,numel(seedHz));
        end
    end

    acceptedMask = [candidates.accepted].';
    accepted = candidates(acceptedMask);
    accepted = unique_candidates(accepted,opt.DuplicateToleranceHz);
    if ~isempty(accepted)
        key = [[accepted.frequencyHz].' real([accepted.frequencyHz].') imag([accepted.frequencyHz].')];
        [~,order] = sortrows(key(:,2:3),[1 2]);
        accepted = accepted(order);
    end

    nRoot = numel(accepted);
    rootsHz = complex(zeros(nRoot,1));
    residual = zeros(nRoot,1);
    scaledSigmaMin = zeros(nRoot,1);
    qualityFactor = zeros(nRoot,1);
    nullVectors = cell(nRoot,1);
    states = cell(nRoot,1);
    for kk = 1:nRoot
        rootsHz(kk) = accepted(kk).frequencyHz;
        residual(kk) = accepted(kk).residual;
        scaledSigmaMin(kk) = accepted(kk).scaledSigmaMin;
        if abs(imag(rootsHz(kk))) > eps(max(1,abs(rootsHz(kk))))
            qualityFactor(kk) = real(rootsHz(kk))/(2*abs(imag(rootsHz(kk))));
        else
            qualityFactor(kk) = Inf;
        end
        nullVectors{kk} = accepted(kk).nullVector;
        states{kk} = accepted(kk).state;
    end

    rootTable = table((1:nRoot).',rootsHz,real(rootsHz),imag(rootsHz), ...
        residual,scaledSigmaMin,qualityFactor, ...
        'VariableNames',{'Index','FrequencyHz','RealHz','ImagHz', ...
        'Residual','ScaledSigmaMin','Q'});

    result = struct();
    result.rootsHz = rootsHz;
    result.residual = residual;
    result.scaledSigmaMin = scaledSigmaMin;
    result.nullVectors = nullVectors;
    result.state = states;
    result.rootTable = rootTable;
    result.candidates = candidates;
    result.seedHz = seedHz;
    result.coarse = struct('realHz',fr,'imagHz',fi,'scaledSigmaMin',metric, ...
        'operatorFailed',failed);
    result.options = opt;
    result.method = ['Equilibrated minimum-singular-value rectangle scan; ' ...
        'bounded fminsearch; optional projected fsolve; no determinant and no fitted poles.'];

    if opt.Verbose
        fprintf('Accepted %d unique physical roots; rejected %d refined candidates.\n', ...
            nRoot,numel(candidates)-sum(acceptedMask));
    end
end

function candidate = refine_candidate(seed,cfg,opt)
    candidate = empty_candidate();
    candidate.seedHz = seed;
    span = [diff(opt.RealRangeHz),diff(opt.ImagRangeHz)];
    span(span == 0) = 1;
    objective = @(x) bounded_log_metric(x,cfg,opt,span);
    fminOpt = optimset('Display','off','TolX',1e-9,'TolFun',1e-12, ...
        'MaxIter',opt.FminMaxIterations,'MaxFunEvals',opt.FminMaxEvaluations);
    x0 = [real(seed),imag(seed)];
    try
        [x,~,exitflag] = fminsearch(objective,x0,fminOpt);
    catch ME
        candidate.message = ['fminsearch failed: ' ME.message];
        return;
    end
    candidate.fminExitFlag = exitflag;
    x = clamp_to_rectangle(x,opt);

    if opt.UseFsolve && exist('fsolve','file') == 2
        [x,candidate.fsolveExitFlag] = projected_fsolve(x,cfg,opt);
        x = clamp_to_rectangle(x,opt);
    end

    f = complex(x(1),x(2));
    try
        [A,state] = operatorAtFrequency(f,cfg);
        [As,colScale,ok] = equilibrated_operator(A);
        if ~ok
            candidate.message = 'The final operator is empty, nonsquare, or nonfinite.';
            return;
        end
        [~,S,V] = svd(As,'econ');
        sval = diag(S);
        y = V(:,end);
        v = colScale(:).*y;
        v = normalize_mode_phase(v);
        residual = norm(A*v,2)/max(norm(A,'fro')*norm(v,2),realmin('double'));
        sigmaMetric = sval(end)/max(sval(1),realmin('double'));
    catch ME
        candidate.message = ['final operator evaluation failed: ' ME.message];
        return;
    end

    candidate.frequencyHz = f;
    candidate.residual = residual;
    candidate.scaledSigmaMin = sigmaMetric;
    candidate.nullVector = v;
    candidate.state = state;
    candidate.inRectangle = point_in_rectangle(x,opt);
    candidate.isPhysical = candidate.inRectangle && ...
        state_is_physical(f,state,v,A,cfg,opt.PhysicalFilter);
    candidate.accepted = candidate.isPhysical && isfinite(residual) && ...
        isfinite(sigmaMetric) && ...
        max(residual,sigmaMetric) <= opt.ResidualTolerance;
    if candidate.accepted
        candidate.message = 'accepted';
    elseif ~candidate.inRectangle
        candidate.message = 'outside the requested rectangle';
    elseif ~candidate.isPhysical
        candidate.message = 'rejected by the physical-state filter';
    else
        candidate.message = sprintf(['residual/scaled singular value ' ...
            '[%.3g %.3g] exceeds tolerance %.3g'], ...
            residual,sigmaMetric,opt.ResidualTolerance);
    end
end

function value = bounded_log_metric(x,cfg,opt,span)
    xc = clamp_to_rectangle(x,opt);
    distance = (x-xc)./span;
    outsidePenalty = 50*sum(distance.^2);
    [sigmaMetric,ok] = singular_metric_at(complex(xc(1),xc(2)),cfg);
    if ~ok
        value = 20+outsidePenalty;
    else
        value = log10(max(sigmaMetric,realmin('double')))+outsidePenalty;
    end
end

function [x,exitflag] = projected_fsolve(x,cfg,opt)
    exitflag = NaN;
    solveOpt = optimset('Display','off','TolX',1e-10,'TolFun',1e-12, ...
        'MaxIter',80,'MaxFunEvals',400);
    for iteration = 1:4
        f = complex(x(1),x(2));
        try
            A = operatorAtFrequency(f,cfg);
            [As,~,ok] = equilibrated_operator(A);
            if ~ok, return; end
            [U,~,V] = svd(As,'econ');
            u = U(:,end);
            v = V(:,end);
            projected = @(xx) projected_residual(xx,u,v,cfg,opt);
            [xNew,~,flag] = fsolve(projected,x,solveOpt);
            exitflag = flag;
        catch
            return;
        end
        if ~point_in_rectangle(xNew,opt)
            return;
        end
        if norm(xNew-x,2) <= 1e-9*max(1,norm(x,2))
            x = xNew;
            return;
        end
        x = xNew;
    end
end

function value = projected_residual(x,u,v,cfg,opt)
    if ~point_in_rectangle(x,opt)
        xc = clamp_to_rectangle(x,opt);
    else
        xc = x;
    end
    try
        A = operatorAtFrequency(complex(xc(1),xc(2)),cfg);
        [As,~,ok] = equilibrated_operator(A);
        if ~ok || size(As,1) ~= numel(u) || size(As,2) ~= numel(v)
            value = [1e3;1e3];
            return;
        end
        scalar = u'*As*v;
        value = [real(scalar);imag(scalar)];
        if any(x ~= xc)
            scale = max(1,norm(value,2));
            value = value+scale*(x(:)-xc(:));
        end
    catch
        value = [1e3;1e3];
    end
end

function [metric,ok] = singular_metric_at(f,cfg)
    metric = Inf;
    try
        A = operatorAtFrequency(f,cfg);
        [As,~,ok] = equilibrated_operator(A);
        if ~ok, return; end
        s = svd(As,'econ');
        if isempty(s) || ~all(isfinite(s)), ok = false; return; end
        metric = s(end)/max(s(1),realmin('double'));
        ok = isfinite(metric);
    catch
        ok = false;
    end
end

function [As,colScale,ok] = equilibrated_operator(A)
    ok = isnumeric(A) && ismatrix(A) && ~isempty(A) && size(A,1) == size(A,2);
    if ~ok
        As = [];
        colScale = [];
        return;
    end
    A = full(A);
    ok = all(isfinite(real(A(:)))) && all(isfinite(imag(A(:))));
    if ~ok
        As = [];
        colScale = [];
        return;
    end
    As = A;
    colScale = ones(size(A,2),1);
    for pass = 1:2
        cn = sqrt(sum(abs(As).^2,1));
        floorC = sqrt(eps('double'))*max([cn,1]);
        dc = 1./max(cn,floorC);
        As = As.*dc;
        colScale = colScale.*dc(:);

        rn = sqrt(sum(abs(As).^2,2));
        floorR = sqrt(eps('double'))*max([rn;1]);
        dr = 1./max(rn,floorR);
        As = dr.*As;
    end
    ok = all(isfinite(real(As(:)))) && all(isfinite(imag(As(:))));
end

function seedIndex = select_seed_indices(metric,maxCandidates,slack)
    [nImag,nReal] = size(metric);
    local = false(size(metric));
    for jj = 1:nImag
        jr = max(1,jj-1):min(nImag,jj+1);
        for ii = 1:nReal
            ir = max(1,ii-1):min(nReal,ii+1);
            value = metric(jj,ii);
            block = metric(jr,ir);
            finiteBlock = block(isfinite(block));
            if isfinite(value) && ~isempty(finiteBlock) && ...
                    value <= min(finiteBlock)*(1+slack)+realmin('double')
                local(jj,ii) = true;
            end
        end
    end

    localIndex = find(local);
    [~,order] = sort(metric(localIndex),'ascend');
    localIndex = localIndex(order);
    seedIndex = nonmaximum_indices(localIndex,metric,maxCandidates);

    % Add globally low points if a broad or undersampled valley contains no
    % strict 3-by-3 minimum.  Spatial nonmaximum suppression prevents a
    % single sharp pole from consuming the candidate budget.
    finiteIndex = find(isfinite(metric));
    [~,order] = sort(metric(finiteIndex),'ascend');
    finiteIndex = finiteIndex(order);
    seedIndex = nonmaximum_indices([seedIndex(:);finiteIndex(:)],metric,maxCandidates);
end

function selected = nonmaximum_indices(indices,metric,maxCount)
    selected = zeros(0,1);
    [~,nReal] = size(metric);
    seen = false(size(metric));
    for kk = 1:numel(indices)
        idx = indices(kk);
        if seen(idx), continue; end
        [jj,ii] = ind2sub(size(metric),idx);
        if isempty(selected)
            farEnough = true;
        else
            [js,is] = ind2sub(size(metric),selected);
            farEnough = all((js-jj).^2+(is-ii).^2 > 2.25);
        end
        if farEnough
            selected(end+1,1) = idx; %#ok<AGROW>
            if numel(selected) >= maxCount, break; end
        end
        jr = max(1,jj-1):min(size(metric,1),jj+1);
        ir = max(1,ii-1):min(nReal,ii+1);
        seen(jr,ir) = true;
    end
end

function accepted = unique_candidates(accepted,tolHz)
    if isempty(accepted), return; end
    [~,order] = sort([accepted.residual],'ascend');
    accepted = accepted(order);
    keep = true(size(accepted));
    for ii = 1:numel(accepted)
        if ~keep(ii), continue; end
        fi = accepted(ii).frequencyHz;
        for jj = ii+1:numel(accepted)
            if ~keep(jj), continue; end
            fj = accepted(jj).frequencyHz;
            relativeTol = 10*eps(max([1,abs(fi),abs(fj)]));
            if abs(fi-fj) <= max(tolHz,relativeTol)
                keep(jj) = false;
            end
        end
    end
    accepted = accepted(keep);
end

function tf = state_is_physical(f,state,v,A,cfg,filter)
    tf = true;
    if isstruct(state)
        if isfield(state,'valid') && isscalar(state.valid)
            tf = tf && logical(state.valid);
        end
        if isfield(state,'isPhysical') && isscalar(state.isPhysical)
            tf = tf && logical(state.isPhysical);
        end
        if isfield(state,'isBranchPoint') && isscalar(state.isBranchPoint)
            tf = tf && ~logical(state.isBranchPoint);
        end
    end
    if tf && ~isempty(filter)
        try
            tf = logical(filter(f,state,v,A));
            tf = isscalar(tf) && tf;
        catch ME
            warning('find_single_sector_resonances:PhysicalFilterFailed', ...
                'PhysicalFilter failed at %.9g%+.9gi Hz: %s',real(f),imag(f),ME.message);
            tf = false;
        end
    elseif tf && isfield(cfg,'search') && isstruct(cfg.search) && ...
            isfield(cfg.search,'physicalFilter') && isa(cfg.search.physicalFilter,'function_handle')
        try
            tf = logical(cfg.search.physicalFilter(f,state,v,A));
            tf = isscalar(tf) && tf;
        catch
            tf = false;
        end
    end
end

function v = normalize_mode_phase(v)
    nv = norm(v,2);
    if ~(isfinite(nv) && nv > 0), return; end
    v = v/nv;
    [~,pivot] = max(abs(v));
    if abs(v(pivot)) > 0
        v = v*exp(-1i*angle(v(pivot)));
    end
end

function x = clamp_to_rectangle(x,opt)
    x = double(x(:).');
    x(1) = min(max(x(1),opt.RealRangeHz(1)),opt.RealRangeHz(2));
    x(2) = min(max(x(2),opt.ImagRangeHz(1)),opt.ImagRangeHz(2));
end

function tf = point_in_rectangle(x,opt)
    tf = numel(x) == 2 && all(isfinite(x)) && ...
        x(1) >= opt.RealRangeHz(1) && x(1) <= opt.RealRangeHz(2) && ...
        x(2) >= opt.ImagRangeHz(1) && x(2) <= opt.ImagRangeHz(2);
end

function candidate = empty_candidate()
    candidate = struct('seedHz',complex(NaN,NaN),'frequencyHz',complex(NaN,NaN), ...
        'residual',Inf,'scaledSigmaMin',Inf,'nullVector',[], ...
        'state',[],'inRectangle',false,'isPhysical',false,'accepted',false, ...
        'fminExitFlag',NaN,'fsolveExitFlag',NaN,'message','not evaluated');
end

function [A,state] = operatorAtFrequency(frequencyHz,cfg)
% Convert the root search's Hz convention to the operator's rad/s input.
    if isfield(cfg,'operatorBuilder') && isa(cfg.operatorBuilder,'function_handle')
        builder = cfg.operatorBuilder;
    else
        builder = @build_single_sector_operator;
    end
    [A,Ycav,Gduct,pre] = builder(2*pi*frequencyHz,cfg);
    state = pre;
    state.Ycav = Ycav;
    state.Gduct = Gduct;
    state.valid = all(isfinite(A),'all');
    state.isPhysical = state.valid;
    state.isBranchPoint = min(abs(pre.duct.kz))*cfg.a < 1e-7;
end

function d = search_defaults(cfg)
    d.realRangeHz = nested_value(cfg,{'search','realRangeHz'},[1200 1900]);
    d.imagRangeHz = nested_value(cfg,{'search','imagRangeHz'},[0 250]);
    d.gridSize = nested_value(cfg,{'search','gridSize'},[91 51]);
    d.maxCandidates = nested_value(cfg,{'search','maxCandidates'},200);
    d.residualTolerance = nested_value(cfg,{'search','residualTolerance'},1e-6);
    d.duplicateToleranceHz = nested_value(cfg,{'search','duplicateToleranceHz'},1e-4);
    d.minimaRelativeSlack = nested_value(cfg,{'search','minimaRelativeSlack'},1e-10);
    d.fminMaxIterations = nested_value(cfg,{'search','fminMaxIterations'},350);
    d.fminMaxEvaluations = nested_value(cfg,{'search','fminMaxEvaluations'},1200);
    d.useFsolve = nested_value(cfg,{'search','useFsolve'},true);
    d.physicalFilter = nested_value(cfg,{'search','physicalFilter'},[]);
    d.verbose = nested_value(cfg,{'search','verbose'},true);
end

function value = nested_value(s,path,fallback)
    value = fallback;
    current = s;
    for kk = 1:numel(path)
        if ~isstruct(current) || ~isfield(current,path{kk})
            return;
        end
        current = current.(path{kk});
    end
    if ~isempty(current), value = current; end
end

function tf = is_two_finite_reals(x)
    tf = isnumeric(x) && isreal(x) && numel(x) == 2 && all(isfinite(x)) && x(1) ~= x(2);
end

function tf = is_grid_size(x)
    tf = isnumeric(x) && isreal(x) && numel(x) == 2 && all(isfinite(x)) && ...
        all(x >= 3) && all(abs(x-round(x)) < eps(max(abs(x),1)));
end

function tf = is_positive_integer(x)
    tf = isnumeric(x) && isreal(x) && isscalar(x) && isfinite(x) && ...
        x >= 1 && abs(x-round(x)) < eps(max(abs(x),1));
end

function tf = is_positive_scalar(x)
    tf = isnumeric(x) && isreal(x) && isscalar(x) && isfinite(x) && x > 0;
end

function tf = is_nonnegative_scalar(x)
    tf = isnumeric(x) && isreal(x) && isscalar(x) && isfinite(x) && x >= 0;
end

function tf = is_logical_scalar(x)
    tf = (islogical(x) || isnumeric(x)) && isscalar(x) && isfinite(x);
end
