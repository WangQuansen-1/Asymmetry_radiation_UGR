function result = run_first_principles_model(varargin)
%RUN_FIRST_PRINCIPLES_MODEL Independent modal-matching acoustic calculation.
% The theory stage does not read MPH files, COMSOL results, or fitted data.

    ip = inputParser;
    ip.addParameter('Resolution','standard');
    ip.addParameter('UseParallel',true,@(x)islogical(x) || isnumeric(x));
    ip.addParameter('OutputDir','');
    ip.addParameter('Frequencies',[],@(x)isnumeric(x) && isvector(x));
    ip.addParameter('CavityModel','bli_galerkin',@(x)ischar(x) || isstring(x));
    ip.addParameter('UseBoundaryLayer',true,@(x)islogical(x) || isnumeric(x));
    ip.addParameter('Numerics',struct(),@isstruct);
    ip.parse(varargin{:});

    cfg = prototype_parameters(ip.Results.Resolution);
    cfg.useParallel = logical(ip.Results.UseParallel);
    cfg.cavityModel = lower(char(ip.Results.CavityModel));
    cfg.useBoundaryLayer = logical(ip.Results.UseBoundaryLayer);
    if ~isempty(ip.Results.OutputDir)
        cfg.outputDir = char(ip.Results.OutputDir);
    end
    if ~isempty(ip.Results.Frequencies)
        cfg.freq = ip.Results.Frequencies(:);
    end
    overrideNames=fieldnames(ip.Results.Numerics);
    for iOverride=1:numel(overrideNames)
        cfg.num.(overrideNames{iOverride})=ip.Results.Numerics.(overrideNames{iOverride});
    end
    if ~isfolder(cfg.outputDir), mkdir(cfg.outputDir); end

    fprintf('\n=== Independent first-principles acoustic model ===\n');
    fprintf('Resolution: %s; frequencies: %.1f--%.1f Hz (%d points)\n', ...
        cfg.resolution,cfg.freq(1),cfg.freq(end),numel(cfg.freq));

    apertures = build_prototype_apertures(cfg);
    bases = cell(1,numel(apertures));
    for ia = 1:numel(apertures)
        bases{ia} = aperture_basis(apertures(ia),cfg.a,cfg.num);
    end
    duct = precompute_duct_modes(cfg.a,bases,cfg.num);
    if strcmp(cfg.cavityModel,'bli_galerkin')
        cavity = precompute_cavity_galerkin(cfg,apertures,bases);
    elseif strcmp(cfg.cavityModel,'modal')
        cavity = precompute_cavity_modes(cfg,apertures,bases);
    else
        error('Unknown CavityModel: %s',cfg.cavityModel);
    end

    fprintf('Side cavities: %d; aperture unknowns: %d; duct modes: %d\n', ...
        numel(apertures),numel(apertures)*size(bases{1}.Phi,2),numel(duct.mu));
    tic;
    T = solve_frequency_sweep(cfg,apertures,bases,duct,cavity);
    elapsed = toc;
    fprintf('Independent sweep completed in %.1f s.\n',elapsed);

    resultFile = fullfile(cfg.outputDir,'first_principles_results.csv');
    writetable(T,resultFile);
    write_parameter_table(cfg,apertures);
    plot_theory_only(T,cfg.outputDir);
    save(fullfile(cfg.outputDir,'first_principles_state.mat'), ...
        'cfg','apertures','duct','elapsed','-v7.3');

    result = struct('data',T,'config',cfg,'apertures',apertures, ...
        'elapsedSeconds',elapsed,'resultFile',resultFile);
end

function apertures = build_prototype_apertures(cfg)
    g = cfg.geom;
    a = cfg.a;
    z1a = g.zi;
    z1b = g.zi+g.z1;
    z2a = g.zi+0.5*g.z1-0.5*g.z2;
    z2b = g.zi+0.5*g.z1+0.5*g.z2;

    base = [ ...
        make_aperture('large_1',0,g.theta1,z1a,z1b,g.r1,a), ...
        make_aperture('small_1',g.theta1+g.deltaTheta, ...
            g.theta1+g.deltaTheta+g.theta2,z2a,z2b,g.r2,a), ...
        make_aperture('large_2',pi,pi+g.theta1,z1a,z1b,g.r1,a), ...
        make_aperture('small_2',pi+g.theta1+g.deltaTheta, ...
            pi+g.theta1+g.deltaTheta+g.theta2,z2a,z2b,g.r2,a)];

    upper = base;
    for i = 1:numel(upper)
        upper(i).name = ['upper_' upper(i).name];
        upper(i).theta1 = upper(i).theta1+g.twist;
        upper(i).theta2 = upper(i).theta2+g.twist;
        upper(i).thetaC = upper(i).thetaC+g.twist;
    end
    lower = base;
    for i = 1:numel(lower)
        lower(i).name = ['lower_' lower(i).name];
        za = lower(i).z1;
        zb = lower(i).z2;
        lower(i).z1 = -zb;
        lower(i).z2 = -za;
        lower(i).zC = 0.5*(lower(i).z1+lower(i).z2);
    end
    apertures = [upper,lower];

    found = [];
    for i = 1:numel(apertures)
        apertures(i).hasSource = point_in_aperture(cfg.source,apertures(i));
        if apertures(i).hasSource, found(end+1)=i; end %#ok<AGROW>
        fprintf('%-20s theta=[%7.3f,%7.3f] deg, z=[%7.3f,%7.3f] mm%s\n', ...
            apertures(i).name,rad2deg(apertures(i).theta1), ...
            rad2deg(apertures(i).theta2),1e3*apertures(i).z1, ...
            1e3*apertures(i).z2,source_marker(apertures(i).hasSource));
    end
    if isempty(found)
        error('The fixed point source was not found on any side-cavity boundary.');
    end
    if numel(found)>1
        error('The fixed point source maps to multiple cavities; geometry is ambiguous.');
    end
end

function s = source_marker(tf)
    if tf, s='  <source>'; else, s=''; end
end

function ap = make_aperture(name,t1,t2,z1,z2,depth,a)
    ap.name = name;
    ap.theta1 = t1;
    ap.theta2 = t2;
    ap.thetaC = 0.5*(t1+t2);
    ap.deltaTheta = t2-t1;
    ap.z1 = z1;
    ap.z2 = z2;
    ap.zC = 0.5*(z1+z2);
    ap.b = a+depth;
    ap.hasSource = false;
end

function tf = point_in_aperture(src,ap)
    tolTheta = 2e-5;
    tolZ = 2e-6;
    tolR = 2e-6;
    theta = src.theta;
    while theta < ap.theta1-tolTheta, theta=theta+2*pi; end
    while theta > ap.theta2+2*pi+tolTheta, theta=theta-2*pi; end
    tf = theta >= ap.theta1-tolTheta && theta <= ap.theta2+tolTheta && ...
        src.z >= ap.z1-tolZ && src.z <= ap.z2+tolZ && ...
        src.r >= cfg_dummy_inner(ap)-tolR && src.r <= ap.b+tolR;
end

function a = cfg_dummy_inner(ap)
    % All apertures start at r=50 mm. Kept local to avoid hidden globals.
    a = 0.05 + 0*ap.b;
end

function T = solve_frequency_sweep(cfg,apertures,bases,duct,cavity)
    nf = numel(cfg.freq);
    out = zeros(nf,6);
    useParallel = prepare_parallel_pool(cfg);
    if useParallel
        parfor jf = 1:nf
            out(jf,:) = solve_one_output(jf,cfg,apertures,bases,duct,cavity);
        end
    else
        for jf = 1:nf
            out(jf,:) = solve_one_output(jf,cfg,apertures,bases,duct,cavity);
            if jf==1 || mod(jf,5)==0 || jf==nf
                fprintf('  %.1f Hz completed (%d/%d)\n',cfg.freq(jf),jf,nf);
            end
        end
    end
    T = array2table([cfg.freq,out], 'VariableNames', ...
        {'freq_Hz','Ez1','Ez0','Ez_1','Ef1','Ef0','Ef_1'});
    T.Forward = T.Ez1./max(T.Ez1+T.Ez0+T.Ez_1,eps);
    T.Backward = T.Ef1./max(T.Ef1+T.Ef0+T.Ef_1,eps);
    T.F1 = T.Ez1/cfg.sourcePower;
    T.B1 = T.Ef1/cfg.sourcePower;
end

function row = solve_one_output(jf,cfg,apertures,bases,duct,cavity)
    f = cfg.freq(jf);
    omega = 2*pi*f;
    k0 = omega/cfg.c0;
    if cfg.useBoundaryLayer
        kDuct=thermoviscous_wavenumber(k0,omega,cfg,cfg.a);
    else
        kDuct=k0;
    end
    qCoef = solve_aperture_flows(kDuct,k0,omega,cfg,apertures,bases,duct,cavity);
    lower = probe_powers(kDuct,omega,cfg,bases,qCoef,duct,cfg.zLower);
    upper = probe_powers(kDuct,omega,cfg,bases,qCoef,duct,cfg.zUpper);

    % Exact model definitions: Ez1 uses exp(-i*alpha_model) at z=-0.25;
    % Ef1 uses exp(+i*alpha_model) at z=+0.25.
    row = [lower.Pplus,lower.Pzero,lower.Pminus, ...
        upper.Pminus,upper.Pzero,upper.Pplus];
end

function qCoef = solve_aperture_flows(kDuct,k0,omega,cfg,apertures,bases,duct,cavity)
    if strcmp(cfg.cavityModel,'bli_galerkin')
        qCoef=solve_aperture_flows_galerkin(kDuct,k0,omega,cfg, ...
            apertures,bases,duct,cavity);
        return;
    end
    nA = numel(apertures);
    nb = size(bases{1}.Phi,2);
    N = nA*nb;
    G = zeros(N,N);
    Y = zeros(N,N);
    qSource = zeros(N,1);
    Q = free_space_monopole_flow(omega,cfg);

    for io = 1:nA
        rows = (io-1)*nb+(1:nb);
        [Y(rows,rows),qSource(rows)] = cavity_operator(k0,omega,cfg, ...
            apertures(io),cavity{io},Q);
        for is = 1:nA
            cols = (is-1)*nb+(1:nb);
            G(rows,cols) = duct_green_between(kDuct,omega,cfg, ...
                bases{io},bases{is},duct,io,is);
        end
    end
    A = eye(N)-Y*G+cfg.matrixRegularization*eye(N);
    qCoef = A\qSource;
end

function qCoef = solve_aperture_flows_galerkin(kDuct,k0,omega,cfg, ...
        apertures,bases,duct,cavity)
    nA=numel(apertures); nb=size(bases{1}.Phi,2); N=nA*nb;
    G=zeros(N); Z=zeros(N); pSource=zeros(N,1);
    Q=free_space_monopole_flow(omega,cfg);
    cachedZ=cell(1,2);
    for io=1:nA
        rows=(io-1)*nb+(1:nb);
        typeIndex=1+contains(apertures(io).name,'small');
        if isempty(cachedZ{typeIndex}) || apertures(io).hasSource
            [Zlocal,pLocal]=cavity_impedance(k0,omega,cfg,cavity{io},Q);
            if isempty(cachedZ{typeIndex}), cachedZ{typeIndex}=Zlocal; end
            pSource(rows)=pLocal;
        end
        Z(rows,rows)=cachedZ{typeIndex};
        for is=1:nA
            cols=(is-1)*nb+(1:nb);
            G(rows,cols)=duct_green_between(kDuct,omega,cfg, ...
                bases{io},bases{is},duct,io,is);
        end
    end
    A=G-Z;
    A=A+cfg.matrixRegularization*max(norm(A,1),1)*eye(N);
    qCoef=A\pSource;
end

function Q = free_space_monopole_flow(omega,cfg)
    % COMSOL's Power definition corresponds to S=sqrt(8*pi*rho*c*P_rms)
    % and S=i*rho*omega*Q for a flow-defined 3D monopole.
    S = sqrt(8*pi*cfg.rho0*cfg.c0*cfg.sourcePower)*exp(1i*cfg.source.phase);
    Q = S/(1i*cfg.rho0*omega);
end

function [Z,pS] = cavity_impedance(k0,omega,cfg,cav,Q)
    [bThermal,bViscous] = bli_coefficients(omega,cfg);
    Bwall = bThermal*cav.Swall-bViscous*cav.Ktwall;
    A = cav.K-k0^2*cav.M-1i*omega*cfg.rho0*Bwall;
    A = A+1e-12*max(norm(A,1),1)*eye(size(A));
    response = A\[cav.C',cav.sourceShape];
    nb = size(cav.C,1);
    Z = -1i*omega*cfg.rho0*cav.C*response(:,1:nb);
    pS = 1i*omega*cfg.rho0*Q*cav.C*response(:,end);
end

function [Y,qS] = cavity_operator(k0,omega,cfg,ap,modes,Q)
    nb = numel(modes(1).c);
    Y = zeros(nb,nb);
    qS = zeros(nb,1);
    rh = cavity_hydraulic_radius(ap,cfg.a);
    if cfg.useBoundaryLayer
        kCavity = thermoviscous_wavenumber(k0,omega,cfg,rh);
    else
        kCavity = k0;
    end
    for im = 1:numel(modes)
        [yst,sourceTransfer] = annular_sector_twoport(kCavity,omega, ...
            cfg.rho0,cfg.a,ap.b,modes(im).nu,modes(im).kz);
        c = modes(im).c;
        Y = Y+yst*(c*c');
        if ap.hasSource
            modalOuterFlow = Q*conj(modes(im).sourceValueOuter);
            qS = qS+sourceTransfer*modalOuterFlow*c;
        end
    end
end

function [bThermal,bViscous] = bli_coefficients(omega,cfg)
    if isfield(cfg,'useBoundaryLayer') && ~cfg.useBoundaryLayer
        bThermal=0; bViscous=0; return;
    end
    deltaV = sqrt(2*cfg.dynamicViscosity/(cfg.rho0*omega));
    deltaT = sqrt(2*cfg.thermalConductivity/(cfg.rho0*cfg.Cp*omega));
    alphaP = cfg.thermalExpansion;
    bThermal = 1i*omega*(alphaP*cfg.temperature/(cfg.rho0*cfg.Cp))* ...
        deltaT*alphaP/(1+1i);
    bViscous = deltaV/((1+1i)*1i*omega*cfg.rho0);
end

function rh = cavity_hydraulic_radius(ap,a)
    b = ap.b;
    dt = ap.deltaTheta;
    L = ap.z2-ap.z1;
    V = 0.5*(b^2-a^2)*dt*L;
    wall = b*dt*L+2*(b-a)*L+(b^2-a^2)*dt;
    rh = max(2*V/max(wall,eps),1e-4);
end

function k = thermoviscous_wavenumber(k0,omega,cfg,rh)
    deltaV = sqrt(2*cfg.dynamicViscosity/(cfg.rho0*omega));
    deltaT = sqrt(2*cfg.thermalConductivity/(cfg.rho0*cfg.Cp*omega));
    correction = 0.5*(deltaV+(cfg.gammaAir-1)*deltaT)/rh;
    k = k0*(1+(1-1i)*correction);
end

function [Y,Hs] = annular_sector_twoport(k,omega,rho,a,b,nu,kz)
    kr = sqrt_outgoing(k^2-kz^2);
    % Integrate the radial wave equation from the rigid outer wall to the
    % aperture.  Direct Bessel determinants lose many digits when nu or kz
    % is large because two exponentially large terms nearly cancel.  This
    % initial-value form enforces F(b)=1, F'(b)=0 exactly and remains stable
    % for the evanescent modes required by modal matching.
    persistent radialOptions
    if isempty(radialOptions)
        radialOptions=odeset('RelTol',2e-9,'AbsTol',1e-11);
    end
    radialODE=@(r,u)[u(2); -(u(2)/r)-(kr^2-nu^2/r^2)*u(1)];
    [~,state]=ode113(radialODE,[b,a],[1;0],radialOptions);
    Fa=state(end,1);
    Fpa=state(end,2);
    fpOverF=Fpa/Fa;
    radialTransfer=(b/a)/Fa;
    Y=-fpOverF/(1i*omega*rho);
    Hs=radialTransfer;
    if ~isfinite(real(Y)) || ~isfinite(imag(Y)), Y=0; end
    if ~isfinite(real(Hs)) || ~isfinite(imag(Hs)), Hs=0; end
end

function P = probe_powers(k,omega,cfg,bases,qCoef,duct,zObs)
    actualTheta = cfg.probeActualTheta;
    modelTheta = cfg.probeModelTheta;
    ps = zeros(size(actualTheta));
    nb = size(bases{1}.Phi,2);
    for ia = 1:numel(bases)
        rows = (ia-1)*nb+(1:nb);
        qNodes = bases{ia}.Phi*qCoef(rows);
        for im = 1:numel(duct.mu)
            beta = safe_beta(k,duct.mu(im),cfg.a);
            phiObs = duct_radial_shape(abs(duct.m(im)),duct.mu(im),cfg.a,cfg.a).* ...
                exp(1i*duct.m(im)*actualTheta)/sqrt(duct.norm2(im));
            phiSrc = duct.phiBasis{ia}(:,im);
            phase = exp(-1i*beta*abs(zObs-bases{ia}.z));
            projection = sum(bases{ia}.w.*conj(phiSrc).*qNodes.*phase);
            ps = ps+1i*omega*cfg.rho0*phiObs*projection/(2i*beta);
        end
    end
    cPlus = mean(ps.*exp(-1i*modelTheta));
    cZero = mean(ps);
    cMinus = mean(ps.*exp(1i*modelTheta));
    P.Pplus = modal_power_from_wall(omega,cfg,cfg.a,1,cPlus);
    P.Pzero = modal_power_from_wall(omega,cfg,cfg.a,0,cZero);
    P.Pminus = modal_power_from_wall(omega,cfg,cfg.a,-1,cMinus);
end

function P = modal_power_from_wall(omega,cfg,a,m,cWall)
    k=omega/cfg.outputC0;
    rho=cfg.outputRho0;
    if m==0
        beta = safe_beta(k,0,a);
        P = real(abs(cWall)^2*beta*pi*a^2/(2*rho*omega));
    else
        mu = neumann_root(1,1);
        beta = safe_beta(k,mu,a);
        Jwall = besselj(1,mu);
        normFactor = pi*a^2*(1-(1/mu)^2)*Jwall^2;
        P = real(abs(cWall/Jwall)^2*beta*normFactor/(2*rho*omega));
    end
    P = max(P,0);
end

function G = duct_green_between(k0,omega,cfg,basisO,basisS,duct,obsIndex,srcIndex)
    kernel=zeros(numel(basisO.theta),numel(basisS.theta));
    phiOAll = duct.phiBasis{obsIndex};
    phiSAll = duct.phiBasis{srcIndex};
    for im = 1:numel(duct.mu)
        beta = safe_beta(k0,duct.mu(im),duct.a);
        phiO = phiOAll(:,im);
        phiS = phiSAll(:,im);
        Gz = exp(-1i*beta*abs(basisO.z-basisS.z.'))/(2i*beta);
        kernel=kernel+(phiO*conj(phiS).').*Gz;
    end
    if obsIndex==srcIndex && numel(basisO.w)==numel(basisS.w)
        kernel=regularize_self_green(kernel,basisO,duct.a,k0);
    end
    pressure=1i*omega*cfg.rho0*kernel*(basisS.w.*basisS.Phi);
    G=basisO.Phi'*(basisO.w.*pressure);
end

function kernel=regularize_self_green(kernel,basis,a,k)
    % A wall flux sees the local Neumann half-space singularity 1/(2*pi*R).
    % Stable local self-action approximation: the complete same-aperture
    % block uses the Neumann half-space Helmholtz kernel. A future exact
    % implementation should replace this with Duffy-integrated singular
    % circular-waveguide Green elements.
    n=numel(basis.w);
    for j=1:n
        dtheta=basis.theta-basis.theta(j);
        dz=basis.z-basis.z(j);
        distance=sqrt((2*a*sin(0.5*dtheta)).^2+dz.^2);
        off=find(distance>0);
        kernel(j,off)=exp(-1i*k*distance(off))./(2*pi*distance(off));
        localAverage=1/sqrt(pi*basis.w(j))-1i*k/(2*pi);
        kernel(j,j)=localAverage;
    end
end

function beta = duct_beta(k0,omega,cfg,m,mu,norm2,a) %#ok<DEFNU>
    [bThermal,bViscous]=bli_coefficients(omega,cfg);
    Jwall=duct_radial_shape(abs(m),mu,a,a);
    surfaceToVolume=2*pi*a*abs(Jwall)^2/norm2;
    beta0sq=k0^2-(mu/a)^2;
    numerator=beta0sq+1i*omega*cfg.rho0*surfaceToVolume* ...
        (bThermal-bViscous*(m/a)^2);
    denominator=1+1i*omega*cfg.rho0*surfaceToVolume*bViscous;
    beta=sqrt_outgoing(numerator/denominator);
    if abs(beta)<1e-10, beta=beta+1e-10i; end
end


function beta = safe_beta(k,mu,a)
    beta=sqrt_outgoing(k^2-(mu/a)^2);
    if abs(beta)<1e-10, beta=beta+1e-10i; end
end

function duct = precompute_duct_modes(a,bases,num)
    mVals=[]; muVals=[]; normVals=[];
    phiBasis=cell(size(bases));
    for m=-num.ductM:num.ductM
        roots=duct_roots_for_m(abs(m),num.ductRadialRoots);
        for ir=1:numel(roots)
            mu=roots(ir);
            norm2=duct_mode_norm2(abs(m),mu,a);
            mVals(end+1,1)=m; %#ok<AGROW>
            muVals(end+1,1)=mu; %#ok<AGROW>
            normVals(end+1,1)=norm2; %#ok<AGROW>
            for ia=1:numel(bases)
                phiBasis{ia}(:,end+1)=duct_radial_shape(abs(m),mu,a,a).* ...
                    exp(1i*m*bases{ia}.theta)/sqrt(norm2); %#ok<AGROW>
            end
        end
    end
    duct=struct('a',a,'m',mVals,'mu',muVals,'norm2',normVals,'phiBasis',{phiBasis});
end

function cav = precompute_cavity_modes(cfg,apertures,bases)
    % Reference-inspired aperture projection used by aperture_basis_v1_rij.
    cav=cell(1,numel(apertures));
    for ia=1:numel(apertures)
        ap=apertures(ia); basis=bases{ia}; rows=[];
        for s=0:cfg.num.cavityAngularMax
            for t=0:cfg.num.cavityAxialMax
                chi=cavity_surface_mode(ap,basis.theta,basis.z,cfg.a,s,t);
                c=basis.Phi'*(basis.w.*chi);
                sourceValue=0;
                if ap.hasSource
                    sourceValue=cavity_mode_value(ap,cfg.source.theta, ...
                        cfg.source.z,ap.b,s,t);
                end
                rows=[rows,struct('c',c,'nu',s*pi/ap.deltaTheta, ...
                    'kz',t*pi/(ap.z2-ap.z1),'s',s,'t',t, ...
                    'sourceValueOuter',sourceValue)]; %#ok<AGROW>
            end
        end
        cav{ia}=rows;
    end
end

function cav = precompute_cavity_galerkin(cfg,apertures,bases) %#ok<DEFNU>
    % Retained experimental full-cavity BLI Galerkin branch. It is not used
    % by the validated modal-projection main path until its port convention
    % has passed an independent energy-conservation test.
    cav=cell(1,numel(apertures));
    for ia=1:numel(apertures)
        ap=apertures(ia); basis=bases{ia};
        nr=cfg.num.cavityRadialMax;
        ns=cfg.num.cavityAngularMax;
        nt=cfg.num.cavityAxialMax;
        qr=cfg.num.cavityQuadRadial;
        qth=max(cfg.num.quadTheta,2*ns+3);
        qz=max(cfg.num.quadZ,2*nt+3);
        [r,wr]=gauss_legendre(qr,cfg.a,ap.b);
        [theta,wth]=gauss_legendre(qth,ap.theta1,ap.theta2);
        [z,wz]=gauss_legendre(qz,ap.z1,ap.z2);

        [R,TH,Z]=ndgrid(r,theta,z);
        [WR,WTH,WZ]=ndgrid(wr,wth,wz);
        wv=R(:).*WR(:).*WTH(:).*WZ(:);
        [P,Pr,Pth,Pz]=cavity_tensor_basis(ap,cfg.a,R(:),TH(:),Z(:),nr,ns,nt);
        M=P'*(wv.*P);
        K=Pr'*(wv.*Pr)+Pth'*((wv./R(:).^2).*Pth)+Pz'*(wv.*Pz);

        N=size(P,2); Swall=zeros(N); Ktwall=zeros(N);
        % Rigid/BLI outer radial wall r=b.
        [TH,Z]=ndgrid(theta,z); [WTH,WZ]=ndgrid(wth,wz);
        rr=ap.b*ones(numel(TH),1); ww=ap.b*WTH(:).*WZ(:);
        [Pw,~,Pthw,Pzw]=cavity_tensor_basis(ap,cfg.a,rr,TH(:),Z(:),nr,ns,nt);
        Swall=Swall+Pw'*(ww.*Pw);
        Ktwall=Ktwall+Pthw'*((ww/ap.b^2).*Pthw)+Pzw'*(ww.*Pzw);

        % Two angular side walls. Their tangential coordinates are r and z.
        [R,Z]=ndgrid(r,z); [WR,WZ]=ndgrid(wr,wz); ww=WR(:).*WZ(:);
        for thetaWall=[ap.theta1,ap.theta2]
            th=thetaWall*ones(numel(R),1);
            [Pw,Prw,~,Pzw]=cavity_tensor_basis(ap,cfg.a,R(:),th,Z(:),nr,ns,nt);
            Swall=Swall+Pw'*(ww.*Pw);
            Ktwall=Ktwall+Prw'*(ww.*Prw)+Pzw'*(ww.*Pzw);
        end

        % Two axial end walls. Their tangential coordinates are r and theta.
        [R,TH]=ndgrid(r,theta); [WR,WTH]=ndgrid(wr,wth);
        ww=R(:).*WR(:).*WTH(:);
        for zWall=[ap.z1,ap.z2]
            zz=zWall*ones(numel(R),1);
            [Pw,Prw,Pthw,~]=cavity_tensor_basis(ap,cfg.a,R(:),TH(:),zz,nr,ns,nt);
            Swall=Swall+Pw'*(ww.*Pw);
            Ktwall=Ktwall+Prw'*(ww.*Prw)+Pthw'*((ww./R(:).^2).*Pthw);
        end

        Pap=cavity_tensor_basis(ap,cfg.a,cfg.a*ones(size(basis.theta)), ...
            basis.theta,basis.z,nr,ns,nt);
        C=basis.Phi'*(basis.w.*Pap);
        sourceShape=zeros(N,1);
        if ap.hasSource
            sourceShape=conj(cavity_tensor_basis(ap,cfg.a,cfg.source.r, ...
                cfg.source.theta,cfg.source.z,nr,ns,nt)).';
        end
        % Mass-orthonormalize the tensor basis. This removes the severe
        % conditioning growth of raw radial/azimuthal/axial cosines and
        % makes radial-order convergence meaningful.
        M=0.5*(M+M'); K=0.5*(K+K');
        Swall=0.5*(Swall+Swall'); Ktwall=0.5*(Ktwall+Ktwall');
        Rchol=chol(M+1e-14*max(norm(M,1),1)*eye(N));
        K=Rchol'\(K/Rchol);
        Swall=Rchol'\(Swall/Rchol);
        Ktwall=Rchol'\(Ktwall/Rchol);
        C=C/Rchol;
        sourceShape=Rchol'\sourceShape;
        M=eye(N);
        cav{ia}=struct('M',M,'K',K,'Swall',Swall,'Ktwall',Ktwall, ...
            'C',C,'sourceShape',sourceShape,'basisCount',N);
    end
end

function [P,Pr,Ptheta,Pz] = cavity_tensor_basis(ap,a,r,theta,z,nrMax,nsMax,ntMax)
    r=r(:); theta=theta(:); z=z(:);
    dr=ap.b-a; dth=ap.deltaTheta; dz=ap.z2-ap.z1;
    N=(nrMax+1)*(nsMax+1)*(ntMax+1);
    P=zeros(numel(r),N); Pr=P; Ptheta=P; Pz=P;
    % Legendre bases do not impose artificial zero normal derivatives;
    % every port/wall condition is applied naturally by the weak form.
    [Rall,dRall]=legendre_basis_1d(2*(r-a)/dr-1,nrMax,2/dr);
    [Sall,dSall]=legendre_basis_1d(2*(theta-ap.theta1)/dth-1,nsMax,2/dth);
    [Tall,dTall]=legendre_basis_1d(2*(z-ap.z1)/dz-1,ntMax,2/dz);
    col=0;
    for ir=0:nrMax
        R=Rall(:,ir+1); dR=dRall(:,ir+1);
        for is=0:nsMax
            S=Sall(:,is+1); dS=dSall(:,is+1);
            for it=0:ntMax
                col=col+1;
                T=Tall(:,it+1); dT=dTall(:,it+1);
                P(:,col)=R.*S.*T;
                Pr(:,col)=dR.*S.*T;
                Ptheta(:,col)=R.*dS.*T;
                Pz(:,col)=R.*S.*dT;
            end
        end
    end
end

function [V,dV] = legendre_basis_1d(x,nMax,physicalScale)
    x=x(:); V=zeros(numel(x),nMax+1); dV=zeros(size(V));
    V(:,1)=1;
    if nMax>=1
        V(:,2)=x; dV(:,2)=1;
    end
    for n=2:nMax
        V(:,n+1)=((2*n-1)*x.*V(:,n)-(n-1)*V(:,n-1))/n;
        dV(:,n+1)=((2*n-1)*(V(:,n)+x.*dV(:,n))- ...
            (n-1)*dV(:,n-1))/n;
    end
    dV=physicalScale*dV;
end

function chi = cavity_surface_mode(ap,theta,z,radius,s,t)
    Ns=sqrt((2-double(s==0))/ap.deltaTheta);
    Nt=sqrt((2-double(t==0))/(ap.z2-ap.z1));
    chi=Ns*Nt/sqrt(radius).*cos(s*pi*(theta-ap.theta1)/ap.deltaTheta).* ...
        cos(t*pi*(z-ap.z1)/(ap.z2-ap.z1));
end

function val = cavity_mode_value(ap,theta,z,radius,s,t)
    while theta<ap.theta1, theta=theta+2*pi; end
    while theta>ap.theta2+2*pi, theta=theta-2*pi; end
    val=cavity_surface_mode(ap,theta,z,radius,s,t);
end

function basis = aperture_basis(ap,a,num)
    [theta,wth]=gauss_legendre(num.quadTheta,ap.theta1,ap.theta2);
    [z,wz]=gauss_legendre(num.quadZ,ap.z1,ap.z2);
    [TH,ZZ]=ndgrid(theta,z); [WTH,WZ]=ndgrid(wth,wz);
    theta=TH(:); z=ZZ(:); w=a*WTH(:).*WZ(:);
    xi=(theta-ap.theta1)/ap.deltaTheta;
    eta=(z-ap.z1)/(ap.z2-ap.z1);
    raw=[];
    for nt=0:num.apertureAngularMax
        for nz=0:num.apertureAxialMax
            raw(:,end+1)=cos(nt*pi*xi).*cos(nz*pi*eta); %#ok<AGROW>
        end
    end
    Phi=zeros(size(raw));
    for j=1:size(raw,2)
        col=raw(:,j);
        for pass=1:2
            for q=1:j-1
                col=col-Phi(:,q)*sum(w.*conj(Phi(:,q)).*col);
            end
        end
        Phi(:,j)=col/max(sqrt(real(sum(w.*abs(col).^2))),eps);
    end
    basis=struct('theta',theta,'z',z,'w',w,'Phi',Phi);
end

function useParallel = prepare_parallel_pool(cfg)
    useParallel=cfg.useParallel && exist('parpool','file')==2;
    if ~useParallel, return; end
    pool=gcp('nocreate');
    if isempty(pool)
        try
            parpool('local',cfg.parallelWorkers);
        catch ME
            warning('FirstPrinciples:ParallelUnavailable','%s', ...
                ['Parallel pool unavailable: ' ME.message '. Using serial.']);
            useParallel=false;
        end
    end
end

function roots = duct_roots_for_m(m,nRoots)
    if m==0
        roots=0;
        if nRoots>1, roots=[roots,arrayfun(@(n)neumann_root(0,n),1:nRoots-1)]; end
    else
        roots=arrayfun(@(n)neumann_root(m,n),1:nRoots);
    end
end

function x = neumann_root(m,n)
    persistent cache
    key=sprintf('m%d_n%d',m,n);
    if isstruct(cache) && isfield(cache,key), x=cache.(key); return; end
    if m==0, fun=@(q)-besselj(1,q); else, fun=@(q)besseljp(m,q); end
    hi=max(20,m+(n+1.5)*pi+5); found=[];
    while numel(found)<n
        grid=linspace(1e-7,hi,max(5000,ceil(300*hi)));
        values=fun(grid);
        idx=find(values(1:end-1).*values(2:end)<0);
        found=arrayfun(@(j)fzero(fun,[grid(j),grid(j+1)]),idx);
        found=unique(round(found(found>1e-8),10));
        hi=hi+20;
    end
    x=found(n);
    if ~isstruct(cache),cache=struct();end
    cache.(key)=x;
end

function radial = duct_radial_shape(m,mu,r,a)
    if abs(mu)<1e-14, radial=ones(size(r)); else, radial=besselj(m,mu*r/a); end
end

function norm2 = duct_mode_norm2(m,mu,a)
    if abs(mu)<1e-14
        norm2=pi*a^2;
    else
        norm2=2*pi*integral(@(r)besselj(m,mu*r/a).^2.*r,0,a, ...
            'RelTol',1e-9,'AbsTol',1e-12);
    end
end

function y = sqrt_outgoing(x)
    y=sqrt(complex(x));
    if imag(y)>0 || (abs(imag(y))<1e-14 && real(y)<0), y=-y; end
end

function y = besseljp(nu,x)
    y=0.5*(besselj(nu-1,x)-besselj(nu+1,x));
end

function y = besselyp(nu,x)
    y=0.5*(bessely(nu-1,x)-bessely(nu+1,x));
end

function [x,w] = gauss_legendre(n,a,b)
    beta=0.5./sqrt(1-(2*(1:n-1)).^(-2));
    J=diag(beta,1)+diag(beta,-1);
    [V,D]=eig(J); x0=diag(D); [x0,idx]=sort(x0); V=V(:,idx);
    w0=2*(V(1,:).^2).'; x=(b-a)/2*x0+(a+b)/2; w=(b-a)/2*w0;
end

function write_parameter_table(cfg,apertures)
    names={'material_c','material_rho','output_c0','output_rho0','temperature', ...
        'dynamicViscosity','thermalConductivity','Cp','D','L','r1', ...
        'theta1_rad','z1','r2','theta2_rad','z2','deltaTheta_rad', ...
        'twist_rad','source_x','source_y','source_z','sourcePower'};
    values=[cfg.c0,cfg.rho0,cfg.outputC0,cfg.outputRho0,cfg.temperature, ...
        cfg.dynamicViscosity,cfg.thermalConductivity,cfg.Cp,cfg.D,cfg.L, ...
        cfg.geom.r1,cfg.geom.theta1, ...
        cfg.geom.z1,cfg.geom.r2,cfg.geom.theta2,cfg.geom.z2, ...
        cfg.geom.deltaTheta,cfg.geom.twist,cfg.source.xyz,cfg.sourcePower].';
    writetable(table(string(names(:)),values,'VariableNames',{'Parameter','SI_Value'}), ...
        fullfile(cfg.outputDir,'fixed_structure_parameters.csv'));
    A=table(string({apertures.name}).',[apertures.theta1].',[apertures.theta2].', ...
        [apertures.z1].',[apertures.z2].',[apertures.b].',[apertures.hasSource].', ...
        'VariableNames',{'Name','theta1_rad','theta2_rad','z1_m','z2_m','outerRadius_m','HasSource'});
    writetable(A,fullfile(cfg.outputDir,'aperture_geometry.csv'));
end

function plot_theory_only(T,outDir)
    fig=figure('Color','w','Position',[80 80 1050 460]);
    tiledlayout(1,2,'Padding','compact','TileSpacing','compact');
    nexttile; hold on; grid on; box on;
    plot(T.freq_Hz,T.Forward,'k-','LineWidth',1.8,'DisplayName','Forward');
    plot(T.freq_Hz,T.Backward,'b-','LineWidth',1.8,'DisplayName','Backward');
    xlabel('Frequency (Hz)'); ylabel('Target-mode fraction'); legend('Location','best');
    nexttile; hold on; grid on; box on;
    plot(T.freq_Hz,T.F1,'k-','LineWidth',1.8,'DisplayName','F1');
    plot(T.freq_Hz,T.B1,'b-','LineWidth',1.8,'DisplayName','B1');
    xlabel('Frequency (Hz)'); ylabel('Power enhancement'); legend('Location','best');
    exportgraphics(fig,fullfile(outDir,'first_principles_theory.png'),'Resolution',220);
    close(fig);
end
