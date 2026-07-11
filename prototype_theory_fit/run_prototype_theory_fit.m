function result = run_prototype_theory_fit(varargin)
%RUN_PROTOTYPE_THEORY_FIT Fit a geometry-aware acoustic reduced-order model.
%
% The program performs four tasks:
%   1. Read the saved frequency-domain solution in 原型.mph through LiveLink.
%   2. Reproduce COMSOL's six cylindrical-duct modal powers and F/B metrics.
%   3. Fit a positive, shared-pole Fano/TCMT reduced-order model until the
%      requested error is reached or adding poles no longer helps.
%   4. Evaluate the bilayer propagation/geometric-phase relation and find a
%      local (twist, layer spacing) balance candidate.
%
% No COMSOL solve is launched and the MPH file is never saved or modified.
%
% Example:
%   result = run_prototype_theory_fit;
%   result = run_prototype_theory_fit('MaxPoles',7,'MultiStarts',20);

% Name-value options:
%   ModelFile       Path to the MPH model.
%   OutputDir       Directory for tables, figures, and MAT files.
%   ComsolRoot      COMSOL Multiphysics installation directory.
%   ComsolPort      Existing local COMSOL server port.
%   MaxPoles        Maximum number of shared resonant poles (default 6).
%   MultiStarts     Nonlinear starts per pole order (default 12).
%   TargetError     Stop when composite relative error is below this value.
%   MinImprovement  Stop after two orders improve less than this fraction.
%   ForceExtract    Ignore cached COMSOL reference data.
%   MakeFigures     Export comparison and residual figures.
%   RunBalanceOptimization  Optional new-geometry exploration (default false).

    rootDir = fileparts(fileparts(mfilename('fullpath')));
    defaultModel = fullfile(rootDir, '原型.mph');
    defaultOutput = fullfile(fileparts(mfilename('fullpath')), 'output');

    ip = inputParser;
    ip.addParameter('ModelFile', defaultModel, @(x)ischar(x) || isstring(x));
    ip.addParameter('OutputDir', defaultOutput, @(x)ischar(x) || isstring(x));
    ip.addParameter('ComsolRoot', 'E:\COMSOL\COMSOL64\Multiphysics', @(x)ischar(x) || isstring(x));
    ip.addParameter('ComsolPort', 2036, @(x)isnumeric(x) && isscalar(x));
    ip.addParameter('MaxPoles', 8, @(x)isnumeric(x) && isscalar(x) && x >= 1);
    ip.addParameter('MultiStarts', 16, @(x)isnumeric(x) && isscalar(x) && x >= 1);
    ip.addParameter('TargetError', 1.5e-4, @(x)isnumeric(x) && isscalar(x) && x > 0);
    ip.addParameter('MinImprovement', 5e-4, @(x)isnumeric(x) && isscalar(x) && x >= 0);
    ip.addParameter('ForceExtract', false, @(x)islogical(x) || isnumeric(x));
    ip.addParameter('MakeFigures', true, @(x)islogical(x) || isnumeric(x));
    ip.addParameter('RunBalanceOptimization',false,@(x)islogical(x) || isnumeric(x));
    ip.parse(varargin{:});
    cfg = ip.Results;
    cfg.ModelFile = char(cfg.ModelFile);
    cfg.OutputDir = char(cfg.OutputDir);
    cfg.ComsolRoot = char(cfg.ComsolRoot);
    cfg.ForceExtract = logical(cfg.ForceExtract);
    cfg.MakeFigures = logical(cfg.MakeFigures);
    cfg.RunBalanceOptimization = logical(cfg.RunBalanceOptimization);
    cfg.RandomSeed = 20260711;
    cfg.PolyDegree = 3;
    cfg.Ridge = 1e-9;
    cfg.Pref = 1e-4;

    if ~isfolder(cfg.OutputDir)
        mkdir(cfg.OutputDir);
    end
    if ~isfile(cfg.ModelFile)
        error('Model file not found: %s', cfg.ModelFile);
    end

    fprintf('\n=== Prototype acoustic theory fit ===\n');
    fprintf('Model:  %s\n', cfg.ModelFile);
    fprintf('Output: %s\n', cfg.OutputDir);

    cacheFile = fullfile(cfg.OutputDir, 'comsol_reference.mat');
    if isfile(cacheFile) && ~cfg.ForceExtract
        S = load(cacheFile, 'reference', 'geometry');
        reference = S.reference;
        geometry = S.geometry;
        fprintf('Loaded cached COMSOL reference: %s\n', cacheFile);
    else
        [reference, geometry] = extract_comsol_reference(cfg);
        save(cacheFile, 'reference', 'geometry', '-v7.3');
        writetable(reference, fullfile(cfg.OutputDir, 'comsol_reference.csv'));
        write_geometry_table(geometry, cfg.OutputDir);
    end

    validate_reference(reference);
    fprintf('Reference frequencies: %.3f to %.3f Hz, N=%d\n', ...
        reference.freq_Hz(1), reference.freq_Hz(end), height(reference));

    [fit, history] = fit_adaptive_shared_poles(reference, cfg);
    theory = evaluate_shared_pole_model(reference.freq_Hz, fit, cfg.Pref);
    errors = build_error_table(reference, theory);

    writetable(theory, fullfile(cfg.OutputDir, 'theory_fit.csv'));
    writetable(errors, fullfile(cfg.OutputDir, 'fit_error.csv'));
    writetable(history, fullfile(cfg.OutputDir, 'fit_history.csv'));
    save(fullfile(cfg.OutputDir, 'reduced_model.mat'), ...
        'fit', 'history', 'geometry', 'cfg', '-v7.3');

    phaseModels = [];
    balance = [];
    sensitivity = [];
    if cfg.RunBalanceOptimization
        phaseModels = fit_bilayer_phase_relations(reference, geometry, cfg);
        balance = optimize_local_balance(theory, geometry, phaseModels, cfg);
        writetable(balance.curves, fullfile(cfg.OutputDir, 'balanced_candidate.csv'));
        writetable(balance.parameters, fullfile(cfg.OutputDir, 'balanced_geometry_parameters.csv'));
        save(fullfile(cfg.OutputDir, 'bilayer_phase_model.mat'), ...
            'phaseModels', 'balance', '-v7.3');
        sensitivity = geometry_sensitivity(geometry, phaseModels, theory, cfg);
        writetable(sensitivity, fullfile(cfg.OutputDir, 'geometry_sensitivity.csv'));
    end

    if cfg.MakeFigures
        make_comparison_figures(reference, theory, errors, cfg.OutputDir);
        if cfg.RunBalanceOptimization
            make_balance_figure(theory, balance, cfg.OutputDir);
        end
    end

    result = struct();
    result.reference = reference;
    result.geometry = geometry;
    result.fit = fit;
    result.theory = theory;
    result.errors = errors;
    result.history = history;
    result.phaseModels = phaseModels;
    result.balance = balance;
    result.sensitivity = sensitivity;

    fprintf('\n=== Final fit ===\n');
    fprintf('Shared poles: %d\n', fit.NumPoles);
    fprintf('Composite relative error: %.6g\n', fit.Score);
    fprintf('Six-channel aggregate relative RMSE: %.6g\n', ...
        errors.RelativeRMSE(strcmp(errors.Quantity,'AllSixChannels')));
    fprintf('Max |Forward_theory-Forward_COMSOL|: %.6g\n', ...
        max(abs(theory.Forward-reference.Forward)));
    fprintf('Max |Backward_theory-Backward_COMSOL|: %.6g\n', ...
        max(abs(theory.Backward-reference.Backward)));
    if cfg.RunBalanceOptimization
        fprintf('Balanced candidate: twist=%.6f deg, spacing=%.6f mm\n', ...
            balance.Twist_deg, 1e3*balance.LayerSpacing_m);
        fprintf('Balanced RMS(F-B)=%.6g, RMS(log(F1/B1))=%.6g\n', ...
            balance.RmsFractionMismatch, balance.RmsLogPowerRatio);
    end
end

function [T, g] = extract_comsol_reference(cfg)
    mli = fullfile(cfg.ComsolRoot, 'mli');
    if exist('mphstart', 'file') ~= 2
        if ~isfolder(mli)
            error('COMSOL LiveLink directory not found: %s', mli);
        end
        addpath(mli);
    end

    connected = false;
    try
        mphstart(cfg.ComsolPort);
        connected = true;
    catch firstError
        try
            mphstart('localhost', cfg.ComsolPort);
            connected = true;
        catch
            error(['Cannot connect to COMSOL server on port %d. Start it with ' ...
                '"comsol mphserver -port %d". Original error: %s'], ...
                cfg.ComsolPort, cfg.ComsolPort, firstError.message);
        end
    end
    if ~connected
        error('COMSOL connection failed.');
    end

    import com.comsol.model.util.*
    tag = sprintf('PrototypeTheoryReadOnly_%d', round(1e6*rem(now,1)));
    model = mphload(cfg.ModelFile, tag);
    cleaner = onCleanup(@() safe_remove_model(tag)); %#ok<NASGU>

    info = mphsolinfo(model);
    f = info.solvals(:);
    [Ez1, Ez0, Ez_1, Ef1, Ef0, Ef_1] = mphglobal(model, ...
        {'Ez1','Ez0','Ez_1','Ef1','Ef0','Ef_1'});

    T = table(f, real(Ez1(:)), real(Ez0(:)), real(Ez_1(:)), ...
        real(Ef1(:)), real(Ef0(:)), real(Ef_1(:)), ...
        'VariableNames', {'freq_Hz','Ez1','Ez0','Ez_1','Ef1','Ef0','Ef_1'});
    T.Forward = T.Ez1 ./ max(T.Ez1 + T.Ez0 + T.Ez_1, eps);
    T.Backward = T.Ef1 ./ max(T.Ef1 + T.Ef0 + T.Ef_1, eps);
    T.F1 = T.Ez1/cfg.Pref;
    T.B1 = T.Ef1/cfg.Pref;

    names = {'D','L','pml','f0','c0','lbd','R0','r1','th1','r2','th2', ...
        'z1','z2','zi','delta_th','xy_theta','rho0','dis_c2_x5'};
    vals = zeros(size(names));
    for i = 1:numel(names)
        v = mphglobal(model, names{i}, 'solnum', 1);
        vals(i) = real(v(1));
    end
    g = cell2struct(num2cell(vals), names, 2);
    g.theta1_rad = g.th1;
    g.theta2_rad = g.th2;
    g.deltaTheta_rad = g.delta_th;
    g.twist_rad = deg2rad(g.xy_theta);
    g.zCenter_m = g.zi + 0.5*g.z1 + g.dis_c2_x5;
    g.layerSpacing_m = 2*g.zCenter_m;
    g.Pref_W = cfg.Pref;

    source = mphgetcoords(model, 'geom1', 'point', 7);
    g.source_xyz_m = source(:).';
    probeIds = [13 67 109 53 20 76 116 62];
    probes = zeros(numel(probeIds),3);
    for i = 1:numel(probeIds)
        c = mphgetcoords(model, 'geom1', 'point', probeIds(i));
        probes(i,:) = c(:).';
    end
    g.probe_xyz_m = probes;

    fprintf('Extracted saved COMSOL solution without solving the model.\n');
end

function safe_remove_model(tag)
    try
        import com.comsol.model.util.*
        ModelUtil.remove(tag);
    catch
    end
end

function validate_reference(T)
    required = {'freq_Hz','Ez1','Ez0','Ez_1','Ef1','Ef0','Ef_1', ...
        'Forward','Backward','F1','B1'};
    if ~all(ismember(required, T.Properties.VariableNames))
        error('Reference table is missing required modal quantities.');
    end
    A = T{:,required(2:end)};
    if any(~isfinite(A),'all') || any(A(:,1:6) <= 0,'all')
        error('COMSOL reference contains nonfinite or nonpositive modal power.');
    end
end

function [best, H] = fit_adaptive_shared_poles(T, cfg)
    rng(cfg.RandomSeed, 'twister');
    names = {'Ez1','Ez0','Ez_1','Ef1','Ef0','Ef_1'};
    f = T.freq_Hz(:);
    Y = T{:,names};
    Z = log(max(Y, realmin));

    rows = zeros(cfg.MaxPoles, 6);
    best.Score = inf;
    bestOrder = [];
    lowImprovementCount = 0;
    previous = inf;

    for nPoles = 1:cfg.MaxPoles
        orderBest = fit_one_order(f, Y, Z, nPoles, cfg);
        improvement = (previous-orderBest.Score)/max(previous, eps);
        if ~isfinite(previous)
            improvement = NaN;
        end
        rows(nPoles,:) = [nPoles, orderBest.Score, orderBest.ChannelRelRMSE, ...
            orderBest.DerivedRelRMSE, improvement, orderBest.NumBasis];
        fprintf('  poles=%d, score=%.6g, channel=%.6g, derived=%.6g', ...
            nPoles, orderBest.Score, orderBest.ChannelRelRMSE, orderBest.DerivedRelRMSE);
        if isfinite(improvement)
            fprintf(', improvement=%.3f%%\n', 100*improvement);
        else
            fprintf('\n');
        end

        if orderBest.Score < best.Score
            best = orderBest;
            bestOrder = nPoles;
        end

        if orderBest.Score <= cfg.TargetError
            fprintf('Target error reached.\n');
            rows = rows(1:nPoles,:);
            break;
        end
        if isfinite(improvement) && improvement < cfg.MinImprovement
            lowImprovementCount = lowImprovementCount + 1;
        else
            lowImprovementCount = 0;
        end
        if lowImprovementCount >= 2
            fprintf('Stopped: two consecutive pole orders gave negligible improvement.\n');
            rows = rows(1:nPoles,:);
            break;
        end
        previous = orderBest.Score;
    end

    best.NumPoles = bestOrder;
    best.ChannelNames = names;
    best.ReferenceFrequency_Hz = mean(f);
    best.FrequencyScale_Hz = 0.5*(max(f)-min(f));
    H = array2table(rows, 'VariableNames', {'NumPoles','CompositeError', ...
        'ChannelRelativeRMSE','DerivedRelativeRMSE','FractionalImprovement','NumBasis'});
end

function best = fit_one_order(f, Y, Z, nPoles, cfg)
    fLo = min(f)-0.35*range(f);
    fHi = max(f)+0.35*range(f);
    gLo = 0.08;
    gHi = 80;
    best.Score = inf;

    centerSeeds = seed_centers(f, Z, nPoles);
    for start = 1:cfg.MultiStarts
        if start == 1
            centers = centerSeeds;
            gammas = repmat(max(range(f)/(3*nPoles), 1), 1, nPoles);
        elseif start == 2
            centers = linspace(min(f)+range(f)/(nPoles+1), ...
                max(f)-range(f)/(nPoles+1), nPoles);
            gammas = repmat(max(range(f)/(6*nPoles), 0.5), 1, nPoles);
        else
            centers = sort(fLo + (fHi-fLo)*rand(1,nPoles));
            gammas = exp(log(gLo)+(log(gHi)-log(gLo))*rand(1,nPoles));
        end
        p0 = encode_bounded(centers, gammas, fLo, fHi, gLo, gHi);
        obj = @(p) variable_projection_score(p, f, Y, Z, nPoles, ...
            fLo, fHi, gLo, gHi, cfg);
        opts = optimset('Display','off', 'MaxIter',1000, 'MaxFunEvals',8000, ...
            'TolX',1e-9, 'TolFun',1e-11);
        [p, score] = fminsearch(obj, p0, opts);
        if score < best.Score
            [score2, details] = variable_projection_score(p, f, Y, Z, nPoles, ...
                fLo, fHi, gLo, gHi, cfg);
            best = details;
            best.Score = score2;
        end
    end
end

function centers = seed_centers(f, Z, nPoles)
    y = mean((Z-mean(Z,1))./max(std(Z,0,1),eps),2);
    curvature = abs([0; diff(y,2); 0]);
    [~, order] = sort(curvature, 'descend');
    centers = [];
    minGap = max(range(f)/(3*nPoles), median(diff(f)));
    for k = 1:numel(order)
        candidate = f(order(k));
        if isempty(centers) || all(abs(candidate-centers) >= minGap)
            centers(end+1) = candidate; %#ok<AGROW>
        end
        if numel(centers) == nPoles
            break;
        end
    end
    if numel(centers) < nPoles
        extra = linspace(min(f), max(f), nPoles+2);
        centers = [centers, extra(2:end-1)];
        centers = centers(1:nPoles);
    end
    centers = sort(centers);
end

function p = encode_bounded(c, g, cLo, cHi, gLo, gHi)
    uc = min(max((c-cLo)/(cHi-cLo),1e-8),1-1e-8);
    ug = min(max((g-gLo)/(gHi-gLo),1e-8),1-1e-8);
    p = [log(uc./(1-uc)), log(ug./(1-ug))];
end

function [c, g] = decode_bounded(p, n, cLo, cHi, gLo, gHi)
    sc = stable_logistic(p(1:n));
    sg = stable_logistic(p(n+1:2*n));
    c = sort(cLo+(cHi-cLo)*sc);
    g = gLo+(gHi-gLo)*sg;
end

function y = stable_logistic(x)
    x = min(max(x,-40),40);
    y = 1./(1+exp(-x));
end

function [score, D] = variable_projection_score(p, f, Y, Z, nPoles, ...
        fLo, fHi, gLo, gHi, cfg)
    [centers, gammas] = decode_bounded(p, nPoles, fLo, fHi, gLo, gHi);
    B = shared_fano_basis(f, centers, gammas, cfg.PolyDegree);
    lambda = cfg.Ridge*trace(B'*B)/size(B,2);
    coeff = (B'*B+lambda*eye(size(B,2)))\(B'*Z);
    Zhat = B*coeff;
    Yhat = exp(min(max(Zhat,log(realmin)),log(realmax)/4));
    [score, channelError, derivedError] = composite_error(Y, Yhat, cfg.Pref);

    if nargout > 1
        D = struct();
        D.Centers_Hz = centers;
        D.Gammas_Hz = gammas;
        D.Coefficients = coeff;
        D.PolyDegree = cfg.PolyDegree;
        D.NumBasis = size(B,2);
        D.ChannelRelRMSE = channelError;
        D.DerivedRelRMSE = derivedError;
        D.Score = score;
    end
end

function B = shared_fano_basis(f, centers, gammas, degree)
    fc = mean(f);
    fs = max(0.5*range(f), eps);
    x = (f-fc)/fs;
    B = ones(numel(f),1);
    for d = 1:degree
        B(:,end+1) = x.^d; %#ok<AGROW>
    end
    for j = 1:numel(centers)
        dx = f-centers(j);
        den = dx.^2+gammas(j)^2;
        L = gammas(j)^2./den;
        A = gammas(j)*dx./den;
        B = [B, L, A, x.*L, x.*A]; %#ok<AGROW>
    end
end

function [score, channelErr, derivedErr] = composite_error(Y, Yhat, pref)
    scale = max(sqrt(mean(Y.^2,1)), eps);
    channelErr = sqrt(mean(((Yhat-Y)./scale).^2,'all'));
    [F,B,F1,B1] = derived_metrics(Y,pref);
    [Fh,Bh,F1h,B1h] = derived_metrics(Yhat,pref);
    d1 = Fh-F;
    d2 = Bh-B;
    d3 = (F1h-F1)/max(sqrt(mean(F1.^2)),eps);
    d4 = (B1h-B1)/max(sqrt(mean(B1.^2)),eps);
    derivedErr = sqrt(mean([d1;d2;d3;d4].^2));
    score = sqrt(0.70*channelErr^2+0.30*derivedErr^2);
end

function [F,B,F1,B1] = derived_metrics(Y,pref)
    F = Y(:,1)./max(sum(Y(:,1:3),2),eps);
    B = Y(:,4)./max(sum(Y(:,4:6),2),eps);
    F1 = Y(:,1)/pref;
    B1 = Y(:,4)/pref;
end

function T = evaluate_shared_pole_model(f, fit, pref)
    Bmat = shared_fano_basis(f(:), fit.Centers_Hz, fit.Gammas_Hz, fit.PolyDegree);
    Y = exp(Bmat*fit.Coefficients);
    T = array2table([f(:),Y], 'VariableNames', ...
        [{'freq_Hz'}, fit.ChannelNames]);
    [T.Forward,T.Backward,T.F1,T.B1] = derived_metrics(Y,pref);
end

function E = build_error_table(C, T)
    quantities = {'Ez1','Ez0','Ez_1','Ef1','Ef0','Ef_1', ...
        'Forward','Backward','F1','B1'};
    n = numel(quantities)+1;
    rows = zeros(n,5);
    labels = strings(n,1);
    for i = 1:numel(quantities)
        q = quantities{i};
        target = C.(q);
        pred = T.(q);
        e = pred-target;
        rmse = sqrt(mean(e.^2));
        rel = rmse/max(sqrt(mean(target.^2)),eps);
        corrVal = safe_correlation(target,pred);
        rows(i,:) = [rmse,rel,corrVal,max(abs(e)),mean(abs(e))];
        labels(i) = q;
    end
    six = {'Ez1','Ez0','Ez_1','Ef1','Ef0','Ef_1'};
    target = C{:,six};
    pred = T{:,six};
    scale = max(sqrt(mean(target.^2,1)),eps);
    rel = sqrt(mean(((pred-target)./scale).^2,'all'));
    rows(end,:) = [sqrt(mean((pred-target).^2,'all')),rel,NaN, ...
        max(abs(pred-target),[],'all'),mean(abs(pred-target),'all')];
    labels(end) = 'AllSixChannels';
    E = array2table(rows, 'VariableNames', ...
        {'RMSE','RelativeRMSE','Correlation','MaxAbsError','MeanAbsError'});
    E.Quantity = labels;
    E = movevars(E,'Quantity','Before',1);
end

function r = safe_correlation(a,b)
    a = a-mean(a); b = b-mean(b);
    r = real((a'*b)/max(sqrt((a'*a)*(b'*b)),eps));
end

function models = fit_bilayer_phase_relations(T, g, ~)
    f = T.freq_Hz(:);
    fScale = max(0.5*(max(f)-min(f)),eps);
    x = (f-mean(f))/fScale;
    specs = struct( ...
        'Left',{'Ez1','Ez0','Ez_1'}, ...
        'Right',{'Ef1','Ef0','Ef_1'}, ...
        'DeltaM',{2,0,-2}, ...
        'ModeAbs',{1,0,1});
    models = repmat(struct(),1,numel(specs));
    for j = 1:numel(specs)
        target = log(max(T.(specs(j).Left),eps)./max(T.(specs(j).Right),eps));
        kz = modal_kz(f,g,specs(j).ModeAbs);
        best.err = inf;
        for s = 1:28
            if s == 1
                p0 = zeros(1,6);
            else
                p0 = [0.8*randn,pi*(2*rand-1),randn(1,4)];
            end
            obj = @(p) phase_ratio_error(p,x,kz,g.layerSpacing_m, ...
                g.twist_rad,specs(j).DeltaM,target);
            opts = optimset('Display','off','MaxIter',1400,'MaxFunEvals',12000, ...
                'TolX',1e-10,'TolFun',1e-12);
            [p,e] = fminsearch(obj,p0,opts);
            if e < best.err
                best.err = e;
                best.p = p;
            end
        end
        models(j).LeftChannel = specs(j).Left;
        models(j).RightChannel = specs(j).Right;
        models(j).DeltaM = specs(j).DeltaM;
        models(j).ModeAbs = specs(j).ModeAbs;
        models(j).Parameters = best.p;
        models(j).RMSE_LogRatio = sqrt(best.err);
        models(j).ReferenceSpacing_m = g.layerSpacing_m;
        models(j).ReferenceTwist_rad = g.twist_rad;
        models(j).ReferenceFrequency_Hz = mean(f);
        models(j).FrequencyScale_Hz = fScale;
    end
end

function err = phase_ratio_error(p,x,kz,d,theta,deltaM,target)
    pred = phase_log_ratio(p,x,kz,d,theta,deltaM,zeros(size(x)),zeros(size(x)));
    err = mean((pred-target).^2);
    if any(~isfinite(pred))
        err = realmax/100;
    end
end

function [logRatio, AF2, AB2] = phase_log_ratio(p,x,kz,d,theta,deltaM,etaShift,psiShift)
    logEta = p(1)+p(5)*x+etaShift;
    eta = exp(min(max(logEta,-8),8));
    psi = p(2)+p(3)*x+p(4)*x.^2+p(6)*x.^3+psiShift;
    AF = 1+eta.*exp(1i*(psi+kz*d+deltaM*theta));
    AB = 1+eta.*exp(1i*(psi-kz*d+deltaM*theta));
    AF2 = abs(AF).^2+1e-12;
    AB2 = abs(AB).^2+1e-12;
    logRatio = log(AF2./AB2);
end

function kz = modal_kz(f,g,mAbs)
    k0 = 2*pi*f/g.c0;
    if mAbs == 0
        kc = 0;
    else
        kc = 1.8412/g.R0;
    end
    kz = real(sqrt(complex(k0.^2-kc^2,0)));
end

function balance = optimize_local_balance(T,g,models,cfg)
    uRef = geometry_to_unit(g);
    unitObj = @(u) full_balance_objective_unit(u,T,g,models,cfg,uRef);
    lb = 0.001*ones(1,numel(uRef));
    ub = 0.999*ones(1,numel(uRef));
    if exist('particleswarm','file') == 2 && exist('fmincon','file') == 2
        psOpts = optimoptions('particleswarm','Display','off', ...
            'SwarmSize',160,'MaxIterations',260,'FunctionTolerance',1e-11, ...
            'InitialSwarmMatrix',uRef);
        [uGlobal,eGlobal] = particleswarm(unitObj,numel(uRef),lb,ub,psOpts);
        fcOpts = optimoptions('fmincon','Display','off','Algorithm','sqp', ...
            'MaxIterations',1500,'MaxFunctionEvaluations',20000, ...
            'OptimalityTolerance',1e-11,'StepTolerance',1e-12);
        [u,e] = fmincon(unitObj,uGlobal,[],[],[],[],lb,ub,[],fcOpts);
        if eGlobal < e
            u = uGlobal;
            e = eGlobal;
        end
        best.err = e;
    else
        best.err = inf;
        for s = 1:96
            if s == 1
                u0 = uRef;
            elseif s <= 16
                u0 = min(max(uRef+0.18*randn(size(uRef)),0.01),0.99);
            else
                u0 = 0.01+0.98*rand(size(uRef));
            end
            p0 = log(u0./(1-u0));
            obj = @(p) full_balance_objective_unit(stable_logistic(p),T,g,models,cfg,uRef);
            opts = optimset('Display','off','MaxIter',1800,'MaxFunEvals',16000, ...
                'TolX',1e-9,'TolFun',1e-11);
            [p,e] = fminsearch(obj,p0,opts);
            if e < best.err
                best.err = e;
                u = stable_logistic(p);
            end
        end
    end
    candidate = unit_to_geometry(u,g);
    [curves,metrics] = full_balance_curves(T,g,candidate,models,cfg);
    balance = metrics;
    balance.Twist_rad = candidate.twist_rad;
    balance.Twist_deg = rad2deg(candidate.twist_rad);
    balance.LayerSpacing_m = candidate.layerSpacing_m;
    balance.Objective = best.err;
    balance.curves = curves;
    balance.geometry = candidate;
    balance.parameters = geometry_comparison_table(g,candidate);
end

function err = full_balance_objective_unit(u,T,g,models,cfg,uRef)
    candidate = unit_to_geometry(u,g);
    [~,M] = full_balance_curves(T,g,candidate,models,cfg);
    regularization = sqrt(mean((u-uRef).^2));
    % The two sector families are repeated after pi. Their combined angular
    % span, including the fixed gap, must not exceed a half turn.
    overlap = max(0,(candidate.theta1_rad+candidate.deltaTheta_rad+ ...
        candidate.theta2_rad-pi)/pi);
    referencePurity = mean(0.5*(T.Forward+T.Backward));
    referencePower = mean(sqrt(T.F1.*T.B1));
    purityLoss = max(0,0.90*referencePurity-M.MeanPurity);
    powerLoss = max(0,log(max(0.75*referencePower,eps)/max(M.MeanTargetPower,eps)));
    err = M.RmsLogPowerRatio^2 + 12*M.RmsFractionMismatch^2 + ...
        0.08*M.MaxAbsLogPowerRatio^2 + ...
        0.8*M.MaxAbsFractionMismatch^2 + 5*purityLoss^2 + ...
        0.8*powerLoss^2 + 2e-5*regularization^2 + 1e4*overlap^2;
end

function [C,M] = full_balance_curves(T,gRef,gNew,models,~)
    f = T.freq_Hz(:);
    descRef = geometry_descriptor(gRef,f);
    descNew = geometry_descriptor(gNew,f);
    C = T;
    for j = 1:numel(models)
        model = models(j);
        x = (f-model.ReferenceFrequency_Hz)/model.FrequencyScale_Hz;
        kz = modal_kz(f,gRef,model.ModeAbs);
        [~,AFref,ABref] = phase_log_ratio(model.Parameters,x,kz, ...
            gRef.layerSpacing_m,gRef.twist_rad,model.DeltaM, ...
            zeros(size(x)),zeros(size(x)));
        ratioC = descNew.Coupling(:,j)./descRef.Coupling(:,j);
        amp = min(max(abs(ratioC),0.08),12);
        etaShift = 0.75*log(amp);
        psiShift = unwrap(angle(ratioC));
        [~,AFnew,ABnew] = phase_log_ratio(model.Parameters,x,kz, ...
            gNew.layerSpacing_m,gNew.twist_rad,model.DeltaM,etaShift,psiShift);
        commonScale = amp.^2;
        C.(model.LeftChannel) = max(T.(model.LeftChannel).*commonScale.*AFnew./AFref,realmin);
        C.(model.RightChannel) = max(T.(model.RightChannel).*commonScale.*ABnew./ABref,realmin);
    end
    C.Forward = C.Ez1./max(C.Ez1+C.Ez0+C.Ez_1,eps);
    C.Backward = C.Ef1./max(C.Ef1+C.Ef0+C.Ef_1,eps);
    pref = 1e-4;
    C.F1 = C.Ez1/pref;
    C.B1 = C.Ef1/pref;
    M.RmsLogPowerRatio = sqrt(mean(log(C.F1./C.B1).^2));
    M.RmsFractionMismatch = sqrt(mean((C.Forward-C.Backward).^2));
    M.MaxAbsLogPowerRatio = max(abs(log(C.F1./C.B1)));
    M.MaxAbsFractionMismatch = max(abs(C.Forward-C.Backward));
    M.MeanPurity = mean(0.5*(C.Forward+C.Backward));
    M.MeanTargetPower = mean(sqrt(C.F1.*C.B1));
    oldTarget = sqrt(max(T.F1.*T.B1,eps));
    newTarget = sqrt(max(C.F1.*C.B1,eps));
    M.RmsLogTotalTargetChange = sqrt(mean(log(newTarget./oldTarget).^2));
end

function u = geometry_to_unit(g)
    rMin = g.lbd/16; rMax = g.lbd/4;
    zMin = g.lbd/16; zMax = g.lbd/4;
    thMin = deg2rad(10); thMax = pi;
    dMin = 0.60*g.layerSpacing_m; dMax = 1.40*g.layerSpacing_m;
    u = [(g.r1-rMin)/(rMax-rMin), (g.r2-rMin)/(rMax-rMin), ...
        (g.theta1_rad-thMin)/(thMax-thMin), ...
        (g.theta2_rad-thMin)/(thMax-thMin), ...
        (g.z1-zMin)/(zMax-zMin), (g.z2-zMin)/(zMax-zMin), ...
        (g.twist_rad+pi/2)/pi, (g.layerSpacing_m-dMin)/(dMax-dMin)];
    u = min(max(u,0.001),0.999);
end

function q = unit_to_geometry(u,g)
    rMin = g.lbd/16; rMax = g.lbd/4;
    zMin = g.lbd/16; zMax = g.lbd/4;
    thMin = deg2rad(10); thMax = pi;
    dMin = 0.60*g.layerSpacing_m; dMax = 1.40*g.layerSpacing_m;
    q = g;
    q.r1 = rMin+(rMax-rMin)*u(1);
    q.r2 = rMin+(rMax-rMin)*u(2);
    q.theta1_rad = thMin+(thMax-thMin)*u(3);
    q.theta2_rad = thMin+(thMax-thMin)*u(4);
    q.z1 = zMin+(zMax-zMin)*u(5);
    q.z2 = zMin+(zMax-zMin)*u(6);
    q.twist_rad = -pi/2+pi*u(7);
    q.layerSpacing_m = dMin+(dMax-dMin)*u(8);
end

function P = geometry_comparison_table(a,b)
    P = table( ...
        ["COMSOL_reference";"Theory_balanced_candidate"], ...
        [a.r1;b.r1],[a.r2;b.r2], ...
        [rad2deg(a.theta1_rad);rad2deg(b.theta1_rad)], ...
        [rad2deg(a.theta2_rad);rad2deg(b.theta2_rad)], ...
        [a.z1;b.z1],[a.z2;b.z2], ...
        [rad2deg(a.twist_rad);rad2deg(b.twist_rad)], ...
        [a.layerSpacing_m;b.layerSpacing_m], ...
        'VariableNames',{'Case','r1_m','r2_m','theta1_deg','theta2_deg', ...
        'z1_m','z2_m','twist_deg','layer_spacing_m'});
end

function S = geometry_sensitivity(g,models,T,cfg)
    names = {'r1','r2','theta1_rad','theta2_rad','z1','z2', ...
        'twist_rad','layerSpacing_m'};
    [~,base] = full_balance_curves(T,g,g,models,cfg);
    rows = zeros(numel(names),6);
    refDesc = geometry_descriptor(g,T.freq_Hz);
    for i = 1:numel(names)
        gp = g;
        name = names{i};
        v = gp.(name);
        if contains(name,'theta') || strcmp(name,'twist_rad')
            dv = deg2rad(1);
        else
            dv = 0.01*max(abs(v),1e-6);
        end
        gp.(name) = v+dv;
        [~,M] = full_balance_curves(T,g,gp,models,cfg);
        dLog = (M.RmsLogPowerRatio-base.RmsLogPowerRatio)/dv;
        dFrac = (M.RmsFractionMismatch-base.RmsFractionMismatch)/dv;
        d = geometry_descriptor(gp,T.freq_Hz);
        powerRatio = mean(abs(d.Coupling(:,1)./refDesc.Coupling(:,1)).^2);
        rows(i,:) = [v,dv,dLog,dFrac,powerRatio, ...
            sqrt(dLog^2+9*dFrac^2)];
    end
    S = array2table(rows,'VariableNames',{'ReferenceValue','Perturbation', ...
        'Derivative_RMSLogF1B1','Derivative_RMSForwardBackward', ...
        'MeanTargetCouplingPowerRatio','CombinedSensitivity'});
    S.Parameter = string(names(:));
    S = movevars(S,'Parameter','Before',1);
end

function D = geometry_descriptor(g,f)
    R = g.R0;
    rho = g.rho0;
    c = g.c0;
    omega = 2*pi*f(:);
    r = [g.r1,g.r2];
    th = [g.theta1_rad,g.theta2_rad];
    z = [g.z1,g.z2];
    phi = [0.5*th(1),th(1)+g.deltaTheta_rad+0.5*th(2)];
    qList = [2,0,-2];
    coupling = zeros(numel(f),numel(qList));
    for j = 1:2
        V = 0.5*((R+r(j))^2-R^2)*th(j)*z(j);
        S = R*th(j)*z(j);
        leff = r(j)+0.60*sqrt(S/pi);
        mass = rho*leff/S;
        compliance = V/(rho*c^2);
        resistance = 0.035*rho*c/S;
        Y = 1./(resistance+1i*(omega*mass-1./(omega*compliance)));
        for iq = 1:numel(qList)
            q = qList(iq);
            if q == 0
                integral = th(j);
            else
                integral = 2*sin(0.5*q*th(j))/q;
            end
            pairFactor = 1+exp(1i*q*pi);
            angular = integral*exp(1i*q*phi(j))*pairFactor;
            coupling(:,iq) = coupling(:,iq)+S*angular.*Y;
        end
    end
    D.DeltaM = qList;
    D.Coupling = coupling;
end

function write_geometry_table(g,outDir)
    names = {'D','R0','L','pml','r1','theta1_rad','r2','theta2_rad', ...
        'z1','z2','zi','deltaTheta_rad','twist_rad','layerSpacing_m','rho0','c0'};
    values = zeros(numel(names),1);
    for i = 1:numel(names)
        values(i) = g.(names{i});
    end
    G = table(string(names(:)),values,'VariableNames',{'Parameter','SI_Value'});
    writetable(G,fullfile(outDir,'geometry_parameters.csv'));
    writematrix(g.source_xyz_m,fullfile(outDir,'source_coordinate_m.csv'));
    writematrix(g.probe_xyz_m,fullfile(outDir,'probe_coordinates_m.csv'));
end

function make_comparison_figures(C,T,E,outDir)
    names = {'Ez1','Ez0','Ez_1','Ef1','Ef0','Ef_1'};
    labels = {'lower target m=+1','lower m=0','lower m=-1', ...
        'upper target m=-1','upper m=0','upper m=+1'};
    fig = figure('Color','w','Position',[40 40 1350 760]);
    tiledlayout(2,3,'Padding','compact','TileSpacing','compact');
    for i = 1:6
        nexttile; hold on; box on; grid on;
        plot(C.freq_Hz,C.(names{i}),'ko','MarkerSize',3.5,'DisplayName','COMSOL');
        plot(T.freq_Hz,T.(names{i}),'r-','LineWidth',1.8,'DisplayName','Theory fit');
        title(labels{i}); xlabel('Frequency (Hz)'); ylabel('Power (W)');
        if i == 1, legend('Location','best'); end
    end
    exportgraphics(fig,fullfile(outDir,'six_channel_fit.png'),'Resolution',240);
    close(fig);

    fig = figure('Color','w','Position',[60 60 1180 760]);
    tiledlayout(2,2,'Padding','compact','TileSpacing','compact');
    nexttile; hold on; box on; grid on;
    plot(C.freq_Hz,C.Forward,'ko','MarkerSize',3.5,'DisplayName','Forward COMSOL');
    plot(C.freq_Hz,C.Backward,'bs','MarkerSize',3.5,'DisplayName','Backward COMSOL');
    plot(T.freq_Hz,T.Forward,'k-','LineWidth',1.8,'DisplayName','Forward theory');
    plot(T.freq_Hz,T.Backward,'b-','LineWidth',1.8,'DisplayName','Backward theory');
    ylabel('Target-mode fraction'); xlabel('Frequency (Hz)'); legend('Location','best');
    nexttile; hold on; box on; grid on;
    plot(C.freq_Hz,C.F1,'ko','MarkerSize',3.5,'DisplayName','F1 COMSOL');
    plot(C.freq_Hz,C.B1,'bs','MarkerSize',3.5,'DisplayName','B1 COMSOL');
    plot(T.freq_Hz,T.F1,'k-','LineWidth',1.8,'DisplayName','F1 theory');
    plot(T.freq_Hz,T.B1,'b-','LineWidth',1.8,'DisplayName','B1 theory');
    ylabel('Power enhancement'); xlabel('Frequency (Hz)'); legend('Location','best');
    nexttile; hold on; box on; grid on;
    plot(T.freq_Hz,T.Forward-C.Forward,'k-','LineWidth',1.5,'DisplayName','Forward residual');
    plot(T.freq_Hz,T.Backward-C.Backward,'b-','LineWidth',1.5,'DisplayName','Backward residual');
    yline(0,'Color',[0.5 0.5 0.5],'HandleVisibility','off'); xlabel('Frequency (Hz)'); ylabel('Residual'); legend('Location','best');
    nexttile; axis off;
    txt = compose('%s: rel. RMSE %.4g',E.Quantity,E.RelativeRMSE);
    text(0,1,strjoin(cellstr(txt),newline),'VerticalAlignment','top', ...
        'FontName','Consolas','FontSize',10,'Interpreter','none');
    exportgraphics(fig,fullfile(outDir,'forward_backward_fit.png'),'Resolution',240);
    close(fig);
end

function make_balance_figure(T,B,outDir)
    C = B.curves;
    fig = figure('Color','w','Position',[80 80 1100 470]);
    tiledlayout(1,2,'Padding','compact','TileSpacing','compact');
    nexttile; hold on; box on; grid on;
    plot(T.freq_Hz,T.Forward,'Color',[0.65 0.65 0.65],'LineWidth',1.2,'DisplayName','Forward reference theory');
    plot(T.freq_Hz,T.Backward,'--','Color',[0.65 0.65 0.65],'LineWidth',1.2,'DisplayName','Backward reference theory');
    plot(C.freq_Hz,C.Forward,'r-','LineWidth',2,'DisplayName','Forward balanced');
    plot(C.freq_Hz,C.Backward,'b--','LineWidth',2,'DisplayName','Backward balanced');
    xlabel('Frequency (Hz)'); ylabel('Target-mode fraction'); legend('Location','best');
    nexttile; hold on; box on; grid on;
    plot(T.freq_Hz,T.F1,'Color',[0.65 0.65 0.65],'LineWidth',1.2,'DisplayName','F1 reference theory');
    plot(T.freq_Hz,T.B1,'--','Color',[0.65 0.65 0.65],'LineWidth',1.2,'DisplayName','B1 reference theory');
    plot(C.freq_Hz,C.F1,'r-','LineWidth',2,'DisplayName','F1 balanced');
    plot(C.freq_Hz,C.B1,'b--','LineWidth',2,'DisplayName','B1 balanced');
    xlabel('Frequency (Hz)'); ylabel('Power enhancement'); legend('Location','best');
    sgtitle(sprintf('Local theory balance: twist %.3f deg, spacing %.3f mm', ...
        B.Twist_deg,1e3*B.LayerSpacing_m));
    exportgraphics(fig,fullfile(outDir,'balanced_candidate.png'),'Resolution',240);
    close(fig);
end
