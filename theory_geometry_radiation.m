%% theory_geometry_radiation
% Geometry-driven semi-analytical radiation model.
%
% This script does NOT use TCMT and does NOT call COMSOL. It computes the
% six output modal powers from geometry parameters by using:
%
%   1) circular duct modal Green functions,
%   2) aperture basis expansion,
%   3) annular-sector cavity admittance,
%   4) point-source excitation,
%   5) modal power projection in the positive/negative z directions.
%
% Main equation on all apertures:
%
%   (I - Gduct*Ycav) p_ap = p_src
%   q_ap = Ycav*p_ap
%
% Output channels have the same meaning as Output.txt:
%
%   Ez1, Ez0, Ez_1, Ef1, Ef0, Ef_1
%
% Run:
%   theory_geometry_radiation

clear; close all; clc;

cfg = default_config();
if isfile(cfg.outputTxt)
    C = read_output_txt(cfg.outputTxt);
    cfg.freq = C.freq_Hz;
else
    C = [];
end

fprintf('\n=== Geometry-driven radiation theory ===\n');
fprintf('Frequency range: %.3f to %.3f Hz, N=%d\n', cfg.freq(1), cfg.freq(end), numel(cfg.freq));
fprintf('Duct modes: m=-%d..%d, radial roots=%d\n', cfg.opt.ductM, cfg.opt.ductM, cfg.opt.ductRadialRoots);

if cfg.scanSourceTheta && ~isempty(C)
    [T, cfg] = scan_source_theta(cfg, C);
else
    apertures = build_geometry(cfg);
    bases = cell(1, numel(apertures));
    for ia = 1:numel(apertures)
        bases{ia} = aperture_basis(apertures(ia), cfg.a, cfg.opt);
    end
    fprintf('Apertures: %d, basis/aperture: %d\n', numel(apertures), size(bases{1}.Phi,2));
    duct = precompute_duct_modes(cfg.a, bases, cfg.source, cfg.opt);
    cav = precompute_cavity_modes(cfg.a, apertures, bases, cfg.opt);
    T = solve_frequency_sweep(cfg, apertures, bases, duct, cav);
    if cfg.calibrateGlobalPower && ~isempty(C)
        T = calibrate_global_power(T, C);
    end
end

outCsv = fullfile(cfg.outDir, 'theory_geometry_results.csv');
writetable(T, outCsv);
fprintf('wrote: %s\n', outCsv);

plot_geometry_results(T, C, cfg.outDir);
if ~isempty(C)
    write_error_table(T, C, cfg.outDir);
end

function cfg = default_config()
    scriptDir = fileparts(mfilename('fullpath'));
    cfg.outputTxt = fullfile(scriptDir, 'Output.txt');
    cfg.outDir = fullfile(scriptDir, 'theory_output');
    if ~exist(cfg.outDir, 'dir')
        mkdir(cfg.outDir);
    end

    cfg.c0 = 343;
    cfg.rho0 = 1.21;
    cfg.D = 100e-3;
    cfg.a = cfg.D/2;
    cfg.freq = (2552.5:1:2652.5).';
    cfg.sourcePower = 1e-4;

    % Point source position. Adjust these to match the COMSOL point source.
    % main.m creates wp5 at z=-0.08 and uses one point on r=D/2 as mps2.
    cfg.source.r = cfg.a;
    cfg.source.theta = 0;
    cfg.source.z = -0.08;

    % Monopole volume velocity. Absolute power depends on this calibration;
    % modal fractions and spectral trends depend mainly on geometry.
    cfg.source.Q = 1.5e-6;
    cfg.calibrateGlobalPower = true;
    cfg.useParallel = true;
    cfg.parallelWorkers = 8;
    cfg.scanSourceTheta = false;
    cfg.sourceThetaCandidates = [0, 0.5*pi, pi, 1.5*pi];
    cfg.sourceZCandidates = [-0.08, 0.08];

    cfg.zRight = 0.25;
    cfg.zLeft = -0.25;

    % Numerical truncation. Increase for convergence checks.
    cfg.opt.quadTheta = 10;
    cfg.opt.quadZ = 6;
    cfg.opt.apertureAngularMax = 3;
    cfg.opt.apertureAxialMax = 2;
    cfg.opt.cavityAngularMax = 6;
    cfg.opt.cavityAxialMax = 4;
    cfg.opt.ductM = 10;
    cfg.opt.ductRadialRoots = 8;

    % Small losses regularize resonant denominators and represent wall loss.
    cfg.opt.ductLoss = 5e-4;
    cfg.opt.cavityLoss = 5e-4;
    cfg.opt.matrixReg = 1e-9;

    % Geometry variables are written in normalized form like main.m. Change
    % these to study geometry-radiation relationships.
    cfg.geom.fDesign = 3000;
    cfg.geom.deltaTheta = deg2rad(10);
    cfg.geom.xyTheta = deg2rad(10);
    cfg.geom.useSecondLayer = true;
    cfg.geom.includeMirrorKeptOriginal = true;
    cfg.geom.zi = 0.05;

    cfg.geom.th1_n = 0.28951;
    cfg.geom.th2_n = 0.27948;
    cfg.geom.r1_n = 0.52627;
    cfg.geom.r2_n = 0.41162;
    cfg.geom.z1_n = 0.86975;
    cfg.geom.z2_n = 0.68992;

    cfg.geom.dis_c2_xmin = -(cfg.c0/cfg.geom.fDesign)/2.5;
    cfg.geom.dis_c2_xmax =  (cfg.c0/cfg.geom.fDesign)/2;
    cfg.geom.dis1_n = 0.36359;
    cfg.geom.dis2_n = 0.81160;
    cfg.geom.dis3_n = 0.35459;
    cfg.geom.dis4_n = 0.42007;
end

function C = read_output_txt(fileName)
    M = readmatrix(fileName, 'FileType','text', 'CommentStyle','%');
    M = M(all(isfinite(M),2), :);
    C = array2table(M(:,1:7), 'VariableNames', ...
        {'freq_Hz','Ez1','Ez0','Ez_1','Ef1','Ef0','Ef_1'});
end

function apertures = build_geometry(cfg)
    g = cfg.geom;
    lbd = cfg.c0 / g.fDesign;
    thMin = deg2rad(10);
    thMax = deg2rad(180);
    rMin = lbd/16;
    rMax = lbd/4;
    zMin = lbd/16;
    zMax = lbd/4;

    th1 = thMin + (thMax-thMin)*g.th1_n;
    th2 = thMin + (thMax-thMin)*g.th2_n;
    d1 = rMin + (rMax-rMin)*g.r1_n;
    d2 = rMin + (rMax-rMin)*g.r2_n;
    L1 = zMin + (zMax-zMin)*g.z1_n;
    L2 = zMin + (zMax-zMin)*g.z2_n;

    dis = @(n) g.dis_c2_xmin + (g.dis_c2_xmax-g.dis_c2_xmin)*n;
    dis1 = dis(g.dis1_n); % mov2, ext2
    dis2 = dis(g.dis2_n); % mov3, ext1
    dis3 = dis(g.dis3_n); % mov4, ext4
    dis4 = dis(g.dis4_n); % mov5, ext3

    % Unrotated objects before rot3, following main.m exactly:
    % ext1: wp1 z=zi, distance z1, then mov3 dis_c2_x2
    % ext2: wp2 z=zi+z1/2-z2/2, distance z2, then mov2 dis_c2_x1
    % ext3: wp3 z=zi, distance z1, rot=180, then mov5 dis_c2_x4
    % ext4: wp4 z=zi+z1/2-z2/2, distance z2, rot=180, then mov4 dis_c2_x3
    unrot = [];
    unrot = [unrot, make_aperture_from_edges('A1', 0, th1, ...
        g.zi + dis2, g.zi + L1 + dis2, d1, cfg.a)];
    unrot = [unrot, make_aperture_from_edges('A2', th1 + g.deltaTheta, th1 + g.deltaTheta + th2, ...
        g.zi + 0.5*L1 - 0.5*L2 + dis1, g.zi + 0.5*L1 + 0.5*L2 + dis1, d2, cfg.a)];
    unrot = [unrot, make_aperture_from_edges('A3', pi, pi + th1, ...
        g.zi + dis4, g.zi + L1 + dis4, d1, cfg.a)];
    unrot = [unrot, make_aperture_from_edges('A4', pi + th1 + g.deltaTheta, pi + th1 + g.deltaTheta + th2, ...
        g.zi + 0.5*L1 - 0.5*L2 + dis3, g.zi + 0.5*L1 + 0.5*L2 + dis3, d2, cfg.a)];

    % main.m final union is {'mir1' 'rot3'}:
    %   rot3 rotates the original moved objects by xy_theta,
    %   mir1 mirrors the unrotated moved objects and keeps the originals.
    rotLayer = unrot;
    for i = 1:numel(rotLayer)
        rotLayer(i).name = ['R' rotLayer(i).name];
        rotLayer(i).theta1 = rotLayer(i).theta1 + g.xyTheta;
        rotLayer(i).theta2 = rotLayer(i).theta2 + g.xyTheta;
        rotLayer(i).thetaC = rotLayer(i).thetaC + g.xyTheta;
    end

    apertures = rotLayer;
    if g.useSecondLayer
        if isfield(g, 'includeMirrorKeptOriginal') && g.includeMirrorKeptOriginal
            keptLayer = unrot;
            for i = 1:numel(keptLayer)
                keptLayer(i).name = ['K' keptLayer(i).name];
            end
            apertures = [apertures, keptLayer];
        end
        mirrorLayer = unrot;
        for i = 1:numel(mirrorLayer)
            mirrorLayer(i).name = ['M' mirrorLayer(i).name];
            oldZ1 = mirrorLayer(i).z1;
            oldZ2 = mirrorLayer(i).z2;
            mirrorLayer(i).z1 = -oldZ2;
            mirrorLayer(i).z2 = -oldZ1;
        end
        apertures = [apertures, mirrorLayer];
    end

    for i = 1:numel(apertures)
        fprintf('%s theta=[%.2f %.2f] deg, z=[%.2f %.2f] mm, depth=%.2f mm\n', ...
            apertures(i).name, rad2deg(apertures(i).theta1), rad2deg(apertures(i).theta2), ...
            1e3*apertures(i).z1, 1e3*apertures(i).z2, 1e3*(apertures(i).b-cfg.a));
    end
end

function ap = make_aperture(name, thetaC, deltaTheta, zC, Lz, depth, a)
    ap.name = name;
    ap.thetaC = thetaC;
    ap.deltaTheta = deltaTheta;
    ap.theta1 = thetaC - 0.5*deltaTheta;
    ap.theta2 = thetaC + 0.5*deltaTheta;
    ap.z1 = zC - 0.5*Lz;
    ap.z2 = zC + 0.5*Lz;
    ap.b = a + depth;
end

function ap = make_aperture_from_edges(name, theta1, theta2, z1, z2, depth, a)
    ap.name = name;
    ap.theta1 = theta1;
    ap.theta2 = theta2;
    ap.thetaC = 0.5*(theta1 + theta2);
    ap.deltaTheta = theta2 - theta1;
    ap.z1 = z1;
    ap.z2 = z2;
    ap.b = a + depth;
end

function T = solve_frequency_sweep(cfg, apertures, bases, duct, cav)
    nf = numel(cfg.freq);
    Ez1 = zeros(nf,1); Ez0 = Ez1; Ez_1 = Ez1;
    Ef1 = Ez1; Ef0 = Ez1; Ef_1 = Ez1;

    useParallel = prepare_parallel_pool(cfg);
    if useParallel
        parfor jf = 1:nf
            [Ez1(jf), Ez0(jf), Ez_1(jf), Ef1(jf), Ef0(jf), Ef_1(jf)] = ...
                solve_frequency_outputs(jf, cfg, apertures, bases, duct, cav);
        end
    else
        for jf = 1:nf
            [Ez1(jf), Ez0(jf), Ez_1(jf), Ef1(jf), Ef0(jf), Ef_1(jf)] = ...
                solve_frequency_outputs(jf, cfg, apertures, bases, duct, cav);
            if mod(jf, 20) == 1 || jf == nf
                fprintf('frequency %.3f Hz done\n', cfg.freq(jf));
            end
        end
    end

    T = table();
    T.freq_Hz = cfg.freq;
    T.Ez1 = Ez1 / cfg.sourcePower;
    T.Ez0 = Ez0 / cfg.sourcePower;
    T.Ez_1 = Ez_1 / cfg.sourcePower;
    T.Ef1 = Ef1 / cfg.sourcePower;
    T.Ef0 = Ef0 / cfg.sourcePower;
    T.Ef_1 = Ef_1 / cfg.sourcePower;
    T.Forward = T.Ez1 ./ max(T.Ez1+T.Ez0+T.Ez_1, eps);
    T.Backward = T.Ef1 ./ max(T.Ef1+T.Ef0+T.Ef_1, eps);
    T.Rt = T.Ez1+T.Ez0+T.Ez_1+T.Ef1+T.Ef0+T.Ef_1;
    T.Alpha = 1 - T.Rt;
end

function [Ez1, Ez0, Ez_1, Ef1, Ef0, Ef_1] = solve_frequency_outputs(jf, cfg, apertures, bases, duct, cav)
        f = cfg.freq(jf);
        omega = 2*pi*f;
        k = omega/cfg.c0 * (1 + 1i*cfg.opt.ductLoss);

        qCoef = solve_one_frequency(k, omega, cfg, apertures, bases, duct, cav);
        PR = probe_modal_powers(k, omega, cfg, bases, qCoef, duct, cfg.zRight, +1);
        PL = probe_modal_powers(k, omega, cfg, bases, qCoef, duct, cfg.zLeft, -1);

        Ez1 = PR.mPlus;
        Ez0 = PR.mZero;
        Ez_1 = PR.mMinus;
        Ef1 = PL.mPlus;
        Ef0 = PL.mZero;
        Ef_1 = PL.mMinus;
end

function useParallel = prepare_parallel_pool(cfg)
    useParallel = isfield(cfg, 'useParallel') && cfg.useParallel && exist('parpool','file') == 2;
    if ~useParallel
        return;
    end
    pool = gcp('nocreate');
    if isempty(pool)
        try
            parpool('local', cfg.parallelWorkers);
        catch ME
            warning('Could not start parallel pool: %s. Running serial.', ME.message);
            useParallel = false;
            return;
        end
    end
    fprintf('parallel frequency sweep enabled.\n');
end

function T = calibrate_global_power(T, C)
    names = {'Ez1','Ez0','Ez_1','Ef1','Ef0','Ef_1'};
    x = [];
    y = [];
    for i = 1:numel(names)
        x = [x; T.(names{i})]; %#ok<AGROW>
        y = [y; C.(names{i})]; %#ok<AGROW>
    end
    gain = max(0, real((x'*y) / max(x'*x, eps)));
    fprintf('global source-power calibration gain = %.6g\n', gain);
    for i = 1:numel(names)
        T.(names{i}) = gain * T.(names{i});
    end
    T.Forward = T.Ez1 ./ max(T.Ez1+T.Ez0+T.Ez_1, eps);
    T.Backward = T.Ef1 ./ max(T.Ef1+T.Ef0+T.Ef_1, eps);
    T.Rt = T.Ez1+T.Ez0+T.Ez_1+T.Ef1+T.Ef0+T.Ef_1;
    T.Alpha = 1 - T.Rt;
end

function [bestT, bestCfg] = scan_source_theta(cfg, C)
    fprintf('scanning COMSOL point-source theta candidates...\n');
    apertures = build_geometry(cfg);
    bases = cell(1, numel(apertures));
    for ia = 1:numel(apertures)
        bases{ia} = aperture_basis(apertures(ia), cfg.a, cfg.opt);
    end
    cav = precompute_cavity_modes(cfg.a, apertures, bases, cfg.opt);

    bestScore = inf;
    bestT = [];
    bestCfg = cfg;
    for iz = 1:numel(cfg.sourceZCandidates)
        for it = 1:numel(cfg.sourceThetaCandidates)
            cfgTry = cfg;
            cfgTry.source.z = cfg.sourceZCandidates(iz);
            cfgTry.source.theta = cfg.sourceThetaCandidates(it);
            duct = precompute_duct_modes(cfgTry.a, bases, cfgTry.source, cfgTry.opt);
            fprintf('\nsource candidate: z=%.3f m, theta=%.1f deg\n', ...
                cfgTry.source.z, rad2deg(cfgTry.source.theta));
            Ttry = solve_frequency_sweep(cfgTry, apertures, bases, duct, cav);
            if cfgTry.calibrateGlobalPower
                Ttry = calibrate_global_power(Ttry, C);
            end
            score = six_channel_score(Ttry, C);
            fprintf('candidate score = %.6g\n', score);
            if score < bestScore
                bestScore = score;
                bestT = Ttry;
                bestCfg = cfgTry;
            end
        end
    end
    fprintf('\nselected source z = %.3f m, theta = %.1f deg, score = %.6g\n', ...
        bestCfg.source.z, rad2deg(bestCfg.source.theta), bestScore);
end

function score = six_channel_score(T, C)
    names = {'Ez1','Ez0','Ez_1','Ef1','Ef0','Ef_1'};
    score = 0;
    for i = 1:numel(names)
        e = T.(names{i}) - C.(names{i});
        scale = max(sqrt(mean(C.(names{i}).^2)), eps);
        score = score + mean((e/scale).^2);
    end
    score = sqrt(score/numel(names));
end

function qCoef = solve_one_frequency(k, omega, cfg, apertures, bases, duct, cav)
    nA = numel(bases);
    nb = size(bases{1}.Phi,2);
    G = zeros(nA*nb);
    Y = zeros(nA*nb);
    rhs = zeros(nA*nb,1);

    for io = 1:nA
        rows = (io-1)*nb + (1:nb);
        Y(rows,rows) = cavity_admittance_projected(k, omega, cfg, apertures(io), cav{io});
        psrc = point_source_on_aperture(k, omega, cfg, bases{io}, duct, io);
        rhs(rows) = bases{io}.Phi' * (bases{io}.w .* psrc);
        for is = 1:nA
            cols = (is-1)*nb + (1:nb);
            G(rows,cols) = duct_green_between(k, omega, cfg.rho0, bases{io}, bases{is}, duct, io, is);
        end
    end

    A = eye(size(G)) - G*Y + cfg.opt.matrixReg*eye(size(G));
    pCoef = A \ rhs;
    qCoef = Y * pCoef;
end

function P = probe_modal_powers(k, omega, cfg, bases, qCoef, duct, zObs, side)
    alpha = [0; 0.5*pi; pi; 1.5*pi];
    ps = zeros(size(alpha));
    nb = size(bases{1}.Phi,2);

    for ia = 1:numel(bases)
        rows = (ia-1)*nb + (1:nb);
        qNodes = bases{ia}.Phi * qCoef(rows);
        for im = 1:numel(duct.mu)
            m = duct.m(im);
            mu = duct.mu(im);
            beta = sqrt_outgoing(k^2 - (mu/cfg.a)^2);
            phiObs = duct_radial_shape(abs(m), mu, cfg.a, cfg.a) .* ...
                exp(1i*m*alpha) / sqrt(duct.norm2(im));
            phiSrc = duct.phiBasis{ia}(:,im);
            src0 = bases{ia}.w .* conj(phiSrc) .* qNodes;
            Gz = exp(1i*beta*abs(zObs - bases{ia}.z.')) ./ (2i*beta);
            ps = ps + 1i*omega*cfg.rho0 * phiObs .* (Gz * src0);
        end
    end

    cPlus = mean(ps .* exp(-1i*alpha));
    cZero = mean(ps);
    cMinus = mean(ps .* exp(1i*alpha));

    if side > 0
        P.mPlus = modal_power_from_wall_coeff(k, omega, cfg.rho0, cfg.a, +1, cPlus);
        P.mZero = modal_power_from_wall_coeff(k, omega, cfg.rho0, cfg.a, 0, cZero);
        P.mMinus = modal_power_from_wall_coeff(k, omega, cfg.rho0, cfg.a, -1, cMinus);
    else
        % main.m defines Ef1 from af1 = mean(p*exp(+i*alpha)) and Ef_1
        % from af_1 = mean(p*exp(-i*alpha)).
        P.mPlus = modal_power_from_wall_coeff(k, omega, cfg.rho0, cfg.a, +1, cMinus);
        P.mZero = modal_power_from_wall_coeff(k, omega, cfg.rho0, cfg.a, 0, cZero);
        P.mMinus = modal_power_from_wall_coeff(k, omega, cfg.rho0, cfg.a, -1, cPlus);
    end
end

function P = modal_power_from_wall_coeff(k, omega, rho0, a, m, cWall)
    if m == 0
        beta = sqrt_outgoing(k^2);
        P = real(abs(cWall)^2 * beta * pi*a^2 / (2*rho0*omega));
    else
        mu = output_mu(1);
        beta = sqrt_outgoing(k^2 - (mu/a)^2);
        Jwall = besselj(1, mu);
        normFactor = pi*a^2*(1-(1/mu)^2)*(Jwall^2);
        P = real(abs(cWall/Jwall)^2 * beta * normFactor / (2*rho0*omega));
    end
    P = max(P, 0);
end

function p = point_source_on_aperture(k, omega, cfg, basis, duct, basisIndex)
    p = zeros(numel(basis.theta),1);
    for im = 1:numel(duct.mu)
        beta = sqrt_outgoing(k^2 - (duct.mu(im)/cfg.a)^2);
        phiA = duct.phiBasis{basisIndex}(:,im);
        phiS = duct.phiSource(im);
        Gz = exp(1i*beta*abs(basis.z-cfg.source.z)) ./ (2i*beta);
        p = p + 1i*omega*cfg.rho0*cfg.source.Q * phiA .* conj(phiS) .* Gz;
    end
end

function amp = outgoing_amplitudes(k, omega, cfg, bases, qCoef, side)
    target = [-1 0 1];
    vals = zeros(size(target));
    nb = size(bases{1}.Phi,2);
    zObs = cfg.zRight;
    if side < 0
        zObs = cfg.zLeft;
    end

    for it = 1:numel(target)
        m = target(it);
        mu = output_mu(m);
        beta = sqrt_outgoing(k^2 - (mu/cfg.a)^2);
        % Output.txt is based on COMSOL acpr.p_s, i.e. scattered pressure.
        % Therefore the direct point-source background is used only to drive
        % the apertures and is not included in the outgoing modal amplitudes.
        aMode = 0;

        for ia = 1:numel(bases)
            rows = (ia-1)*nb + (1:nb);
            qNodes = bases{ia}.Phi * qCoef(rows);
            phiA = output_mode_on_aperture(m, mu, bases{ia}, cfg.a);
            if side > 0
                phase = exp(1i*beta*(zObs-bases{ia}.z));
            else
                phase = exp(1i*beta*(bases{ia}.z-zObs));
            end
            srcProj = sum(bases{ia}.w .* conj(phiA) .* qNodes .* phase);
            aMode = aMode + 1i*omega*cfg.rho0*srcProj/(2i*beta);
        end
        vals(it) = aMode;
    end

    amp.mMinus = vals(1);
    amp.mZero = vals(2);
    amp.mPlus = vals(3);
end

function P = modal_powers(k, omega, rho0, a, amp)
    beta0 = sqrt_outgoing(k^2);
    beta1 = sqrt_outgoing(k^2 - (output_mu(1)/a)^2);
    P.mZero = max(real(beta0)*abs(amp.mZero)^2/(2*rho0*omega), 0);
    P.mPlus = max(real(beta1)*abs(amp.mPlus)^2/(2*rho0*omega), 0);
    P.mMinus = max(real(beta1)*abs(amp.mMinus)^2/(2*rho0*omega), 0);
end

function duct = precompute_duct_modes(a, bases, source, opt)
    mVals = [];
    muVals = [];
    normVals = [];
    phiSource = [];
    phiBasis = cell(size(bases));

    for m = -opt.ductM:opt.ductM
        roots = duct_roots_for_m(abs(m), opt.ductRadialRoots);
        for ir = 1:numel(roots)
            mu = roots(ir);
            norm2 = duct_mode_norm2(abs(m), mu, a);
            mVals(end+1,1) = m; %#ok<AGROW>
            muVals(end+1,1) = mu; %#ok<AGROW>
            normVals(end+1,1) = norm2; %#ok<AGROW>
            phiSource(end+1,1) = duct_radial_shape(abs(m), mu, source.r, a) .* ...
                exp(1i*m*source.theta) / sqrt(norm2); %#ok<AGROW>
            for ia = 1:numel(bases)
                phiBasis{ia}(:,end+1) = duct_radial_shape(abs(m), mu, a, a) .* ...
                    exp(1i*m*bases{ia}.theta) / sqrt(norm2); %#ok<AGROW>
            end
        end
    end

    duct.a = a;
    duct.m = mVals;
    duct.mu = muVals;
    duct.norm2 = normVals;
    duct.phiSource = phiSource;
    duct.phiBasis = phiBasis;
end

function cav = precompute_cavity_modes(a, apertures, bases, opt)
    cav = cell(1,numel(bases));
    for ia = 1:numel(bases)
        ap = apertures(ia);
        basis = bases{ia};
        rows = [];
        for s = 0:opt.cavityAngularMax
            for t = 0:opt.cavityAxialMax
                chi = cavity_surface_mode(ap, basis.theta, basis.z, a, s, t);
                c = basis.Phi' * (basis.w .* chi);
                rows = [rows, struct('c', c, 'nu', s*pi/ap.deltaTheta, ...
                    'kz', t*pi/(ap.z2-ap.z1))]; %#ok<AGROW>
            end
        end
        cav{ia} = rows;
    end
end

function basis = aperture_basis(ap, a, opt)
    [theta, wth] = gauss_legendre(opt.quadTheta, ap.theta1, ap.theta2);
    [z, wz] = gauss_legendre(opt.quadZ, ap.z1, ap.z2);
    [TH, ZZ] = ndgrid(theta, z);
    [WTH, WZ] = ndgrid(wth, wz);
    theta = TH(:);
    z = ZZ(:);
    w = a * WTH(:) .* WZ(:);

    xi = (theta-ap.theta1)/ap.deltaTheta;
    eta = (z-ap.z1)/(ap.z2-ap.z1);
    raw = [];
    for nt = 0:opt.apertureAngularMax
        for nz = 0:opt.apertureAxialMax
            raw(:,end+1) = cos(nt*pi*xi).*cos(nz*pi*eta); %#ok<AGROW>
        end
    end

    Phi = zeros(size(raw));
    for j = 1:size(raw,2)
        col = raw(:,j);
        for pass = 1:2
            for q = 1:j-1
                col = col - Phi(:,q)*sum(w.*conj(Phi(:,q)).*col);
            end
        end
        Phi(:,j) = col / max(sqrt(real(sum(w.*abs(col).^2))), eps);
    end

    basis.theta = theta;
    basis.z = z;
    basis.w = w;
    basis.Phi = Phi;
end

function G = duct_green_between(k, omega, rho0, basisO, basisS, duct, obsIndex, srcIndex)
    nbO = size(basisO.Phi,2);
    nbS = size(basisS.Phi,2);
    G = zeros(nbO,nbS);
    phiOAll = duct.phiBasis{obsIndex};
    phiSAll = duct.phiBasis{srcIndex};

    for im = 1:numel(duct.mu)
        beta = sqrt_outgoing(k^2 - (duct.mu(im)/duct.a)^2);
        phiO = phiOAll(:,im);
        phiS = phiSAll(:,im);
        Gz = exp(1i*beta*abs(basisO.z-basisS.z.')) ./ (2i*beta);
        src = (basisS.w .* conj(phiS)) .* basisS.Phi;
        P = 1i*omega*rho0 * (phiO .* (Gz*src));
        G = G + basisO.Phi' * (basisO.w .* P);
    end
end

function Y = cavity_admittance_projected(k, omega, cfg, ap, modes)
    nb = numel(modes(1).c);
    Y = zeros(nb,nb);
    kLoss = k * (1 + 1i*cfg.opt.cavityLoss);
    for im = 1:numel(modes)
        yst = annular_sector_admittance(kLoss, omega, cfg.rho0, cfg.a, ap.b, modes(im).nu, modes(im).kz);
        c = modes(im).c;
        Y = Y + yst*(c*c');
    end
end

function chi = cavity_surface_mode(ap, theta, z, a, s, t)
    dth = ap.deltaTheta;
    L = ap.z2-ap.z1;
    Ns = sqrt((2-double(s==0))/dth);
    Nt = sqrt((2-double(t==0))/L);
    chi = Ns*Nt/sqrt(a) .* cos(s*pi*(theta-ap.theta1)/dth) .* cos(t*pi*(z-ap.z1)/L);
end

function Y = annular_sector_admittance(k, omega, rho0, a, b, nu, kz)
    if abs(nu) > 8
        ratio = (a/b)^(2*nu);
        X = a/nu * (1+ratio) / max(1-ratio, eps);
        Y = 1/(1i*omega*rho0*X);
        return;
    end

    kr2 = k^2-kz^2;
    kr = sqrt_outgoing(kr2);
    if abs(kr) < 1e-12
        if abs(nu) < 1e-12
            fpOverF = 1/(a*log(a/b));
        else
            fpOverF = nu*(a^(nu-1)-b^(2*nu)*a^(-nu-1))/(a^nu+b^(2*nu)*a^(-nu));
        end
    else
        za = kr*a;
        zb = kr*b;
        Jpb = besseljp(nu, zb);
        Ypb = besselyp(nu, zb);
        F = Ypb*besselj(nu, za) - Jpb*bessely(nu, za);
        Fp = kr*(Ypb*besseljp(nu, za) - Jpb*besselyp(nu, za));
        fpOverF = Fp/F;
    end
    Y = -fpOverF/(1i*omega*rho0);
    if ~isfinite(real(Y)) || ~isfinite(imag(Y))
        Y = 0;
    end
end

function mu = output_mu(m)
    if m == 0
        mu = 0;
    else
        mu = neumann_root(1,1);
    end
end

function phi = output_mode_on_aperture(m, mu, basis, a)
    norm2 = duct_mode_norm2(abs(m), mu, a);
    phi = duct_radial_shape(abs(m), mu, a, a) .* exp(1i*m*basis.theta) / sqrt(norm2);
end

function phi = output_mode_at_source(m, mu, source, a)
    norm2 = duct_mode_norm2(abs(m), mu, a);
    phi = duct_radial_shape(abs(m), mu, source.r, a) .* exp(1i*m*source.theta) / sqrt(norm2);
end

function radial = duct_radial_shape(mAbs, mu, r, a)
    if abs(mu) < 1e-14
        radial = ones(size(r));
    else
        radial = besselj(mAbs, mu*r/a);
    end
end

function norm2 = duct_mode_norm2(mAbs, mu, a)
    if abs(mu) < 1e-14
        norm2 = pi*a^2;
    else
        fun = @(r) besselj(mAbs,mu*r/a).^2 .* r;
        norm2 = 2*pi*integral(fun,0,a,'RelTol',1e-9,'AbsTol',1e-12);
    end
end

function roots = duct_roots_for_m(m, nRoots)
    if m == 0
        roots = 0;
        if nRoots > 1
            roots = [roots, arrayfun(@(n) neumann_root(0,n), 1:nRoots-1)];
        end
    else
        roots = arrayfun(@(n) neumann_root(m,n), 1:nRoots);
    end
end

function x = neumann_root(m, n)
    persistent cache
    key = sprintf('m%d_n%d',m,n);
    if isstruct(cache) && isfield(cache,key)
        x = cache.(key);
        return;
    end
    if m == 0
        f = @(x) -besselj(1,x);
    else
        f = @(x) 0.5*(besselj(m-1,x)-besselj(m+1,x));
    end
    hi = max(20,m+(n+1.5)*pi+5);
    roots = [];
    for it = 1:20
        grid = linspace(1e-6,hi,max(4000,ceil(300*hi)));
        vals = f(grid);
        idx = find(isfinite(vals(1:end-1)) & isfinite(vals(2:end)) & vals(1:end-1).*vals(2:end)<0);
        roots = nan(numel(idx),1);
        for ii = 1:numel(idx)
            try
                roots(ii) = fzero(f,[grid(idx(ii)),grid(idx(ii)+1)]);
            catch
                roots(ii) = NaN;
            end
        end
        roots = unique(round(roots(isfinite(roots)),10));
        roots = roots(roots > 1e-8);
        if numel(roots) >= n
            break;
        end
        hi = hi+20;
    end
    x = roots(n);
    if ~isstruct(cache), cache = struct(); end
    cache.(key) = x;
end

function y = sqrt_outgoing(x)
    y = sqrt(complex(x));
    if imag(y) < 0
        y = -y;
    end
end

function y = besseljp(nu,x)
    y = 0.5*(besselj(nu-1,x)-besselj(nu+1,x));
end

function y = besselyp(nu,x)
    y = 0.5*(bessely(nu-1,x)-bessely(nu+1,x));
end

function [x,w] = gauss_legendre(n,a,b)
    beta = 0.5 ./ sqrt(1-(2*(1:n-1)).^(-2));
    T = diag(beta,1)+diag(beta,-1);
    [V,D] = eig(T);
    x0 = diag(D);
    [x0,idx] = sort(x0);
    V = V(:,idx);
    w0 = 2*(V(1,:).^2).';
    x = (b-a)/2*x0+(a+b)/2;
    w = (b-a)/2*w0;
end

function plot_geometry_results(T, C, outDir)
    names = {'Ez1','Ez0','Ez_1','Ef1','Ef0','Ef_1'};
    labels = {'+z m=+1','+z m=0','+z m=-1','-z m=+1','-z m=0','-z m=-1'};
    fig = figure('Color','w','Position',[60 60 1280 760]);
    tiledlayout(2,3,'Padding','compact','TileSpacing','compact');
    for i = 1:numel(names)
        nexttile; hold on; grid on; box on;
        if ~isempty(C)
            plot(C.freq_Hz, C.(names{i}), 'ko', 'MarkerSize', 3.2, 'DisplayName','Output.txt');
        end
        plot(T.freq_Hz, T.(names{i}), 'r-', 'LineWidth', 1.8, 'DisplayName','Geometry theory');
        xlabel('Frequency (Hz)');
        ylabel(names{i}, 'Interpreter','none');
        title(labels{i});
        if i == 1
            legend('Location','best');
        end
    end
    exportgraphics(fig, fullfile(outDir,'theory_geometry_vs_output_six_channels.png'), 'Resolution',240);

    fig2 = figure('Color','w','Position',[90 90 980 460]);
    hold on; grid on; box on;
    plot(T.freq_Hz, T.Forward, 'LineWidth',2, 'DisplayName','Forward');
    plot(T.freq_Hz, T.Backward, 'LineWidth',2, 'DisplayName','Backward');
    xlabel('Frequency (Hz)');
    ylabel('Mode fraction');
    legend('Location','best');
    exportgraphics(fig2, fullfile(outDir,'theory_geometry_forward_backward.png'), 'Resolution',240);
end

function write_error_table(T, C, outDir)
    names = {'Ez1','Ez0','Ez_1','Ef1','Ef0','Ef_1'};
    rows = zeros(numel(names),4);
    for i = 1:numel(names)
        e = T.(names{i}) - C.(names{i});
        rmse = sqrt(mean(e.^2));
        rel = rmse / max(sqrt(mean(C.(names{i}).^2)), eps);
        tt = T.(names{i}) - mean(T.(names{i}));
        cc = C.(names{i}) - mean(C.(names{i}));
        corrVal = real((tt'*cc)/max(sqrt((tt'*tt)*(cc'*cc)),eps));
        rows(i,:) = [rmse, rel, corrVal, max(abs(e))];
    end
    E = array2table(rows, 'VariableNames', {'RMSE','RelativeRMSE','Correlation','MaxAbsError'});
    E.Channel = string(names(:));
    E = movevars(E,'Channel','Before',1);
    writetable(E, fullfile(outDir,'theory_geometry_error.csv'));
    fprintf('\nGeometry-theory error summary:\n');
    disp(E);
end
