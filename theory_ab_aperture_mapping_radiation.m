%% theory_ab_aperture_mapping_radiation
% Radiation model using aperture-basis mapping.
%
% This follows the numerical philosophy of aperture_basis_v1_rij.m, but the
% physical problem is changed from reflection by an incident duct wave to
% radiation from a point source inside cavity A.
%
% Unknowns live on the apertures.  Each aperture pressure/velocity is
% expanded by theta-z basis functions.  The cavity admittance contains both
% angular and axial cavity modes, and the radial dependence is included by
% annular-sector radial functions.  The resulting aperture velocity is then
% mapped to duct modes m=0,+1,-1 to compute +z/-z radiation.

clear; clc; close all;

%% Constants and geometry
c0 = 343;
rho0 = 1.21;
a = 50e-3;                  % main duct radius R0 [m]
sourcePower = 1e-4;

geo.rA = 0.01842774646;
geo.rB = 0.01596993708;
geo.betaA = deg2rad(59.217);
geo.betaB = deg2rad(57.512);
geo.LA = 0.02193599333;
geo.LB = 0.02579109896;
geo.zA1 = 0.04360763048 + geo.LA/2;
geo.zB1 = 0.08778030667 + geo.LB/2;
geo.twist = deg2rad(10);
geo.xyTheta = deg2rad(10);
geo.deltaABRotation = deg2rad(10);
geo.phiA1 = geo.xyTheta + geo.betaA/2;
geo.deltaPhiAB = geo.betaA/2 + geo.deltaABRotation + geo.betaB/2;

% Point source inside cavity A1_1.
src.apertureIndex = 1;
src.r = a + 0.55*geo.rA;
src.theta = geo.phiA1;
src.z = geo.zA1;
src.strength = sqrt(sourcePower);

%% Frequency
dataFile = fullfile(fileparts(mfilename('fullpath')), 'Output.txt');
if exist(dataFile, 'file')
    raw = readmatrix(dataFile);
    freq = raw(:, 1);
else
    raw = [];
    freq = linspace(2550, 2660, 301).';
end

%% Numerical options
opt.quadTheta = 18;
opt.quadZ = 10;
opt.apertureAngularMax = 5;
opt.apertureAxialMax = 3;
opt.cavityAngularMax = 14;
opt.cavityAxialMax = 7;
opt.cavityRadialMax = 10;
opt.cavityLossTan = 0.0008;
opt.cavityEigenScale = 0.56;
opt.sourceProjectionScale = 1.0;
opt.apertureAdmittanceScale = 35;
opt.ductM = 10;
opt.ductRadialRoots = 14;
opt.useParallel = true;
opt.parallelWorkers = 8;

%% Build apertures and bases
[apertures, bVals] = build_ab_apertures(geo, a);
nAps = numel(apertures);
bases = cell(1, nAps);
for ia = 1:nAps
    bases{ia} = aperture_basis_theta_z(apertures(ia), a, opt);
end

obsPlus = four_wall_probe(a, +0.25);
obsMinus = four_wall_probe(a, -0.25);
ductDataPlus = precompute_duct_modes(a, bases, obsPlus, opt);
ductDataMinus = precompute_duct_modes(a, bases, obsMinus, opt);
cavData = precompute_cavity_modes(a, bVals, apertures, bases, src, opt);

fprintf('\n=== AB aperture-mapping radiation model ===\n');
fprintf('apertures=%d, basis/aperture=%d\n', nAps, size(bases{1}.Phi, 2));
fprintf('aperture basis theta n=0..%d, z n=0..%d\n', opt.apertureAngularMax, opt.apertureAxialMax);
fprintf('cavity basis angular s=0..%d, axial t=0..%d, radial p=0..%d\n', ...
    opt.cavityAngularMax, opt.cavityAxialMax, opt.cavityRadialMax);

useParallel = prepare_parallel_pool(opt);
modalPower = zeros(numel(freq), 6);
if useParallel
    parfor jf = 1:numel(freq)
        modalPower(jf, :) = solve_one_frequency(freq(jf), c0, rho0, a, bVals, ...
            bases, cavData, ductDataPlus, ductDataMinus, obsPlus, obsMinus);
    end
else
    for jf = 1:numel(freq)
        modalPower(jf, :) = solve_one_frequency(freq(jf), c0, rho0, a, bVals, ...
            bases, cavData, ductDataPlus, ductDataMinus, obsPlus, obsMinus);
    end
end

%% Save and plot
outDir = fullfile(fileparts(mfilename('fullpath')), 'theory_output');
if ~exist(outDir, 'dir'), mkdir(outDir); end

T = array2table([freq, modalPower], 'VariableNames', ...
    {'freq_Hz','Ez1','Ez0','EzMinus1','Ef1','Ef0','EfMinus1'});
writetable(T, fullfile(outDir, 'theory_ab_aperture_mapping_power.csv'));

plot_modal_power(freq, modalPower, raw, outDir);

fprintf('wrote: %s\n', fullfile(outDir, 'theory_ab_aperture_mapping_power.csv'));
fprintf('wrote: %s\n', fullfile(outDir, 'theory_ab_aperture_mapping_vs_output.png'));

%% Main solve
function powers = solve_one_frequency(f, c0, rho0, a, bVals, bases, cavData, ductPlus, ductMinus, obsPlus, obsMinus)
    omega = 2*pi*f;
    k = omega/c0;
    nAps = numel(bases);
    nb = size(bases{1}.Phi, 2);

    G = zeros(nAps*nb);
    Y = zeros(nAps*nb);
    qSrc = zeros(nAps*nb, 1);

    for io = 1:nAps
        rows = (io-1)*nb + (1:nb);
        Y(rows, rows) = cavity_admittance_projected(k, omega, rho0, a, bVals(io), cavData{io});
        qSrc(rows) = cavity_source_projected(k, omega, rho0, a, bVals(io), cavData{io});
        for is = 1:nAps
            cols = (is-1)*nb + (1:nb);
            G(rows, cols) = duct_green_matrix_between(k, omega, rho0, ...
                bases{io}, bases{is}, ductPlus, io, is);
        end
    end

    % Radiation condition for internal source:
    %   p = G q,  q = Y p + q_src
    %   (I - GY)p = G q_src
    pCoef = (eye(size(G)) - G*Y) \ (G*qSrc);
    qCoef = Y*pCoef + qSrc;

    pPlus = zeros(numel(obsPlus.r), 1);
    pMinus = zeros(numel(obsMinus.r), 1);
    for ia = 1:nAps
        rows = (ia-1)*nb + (1:nb);
        pPlus = pPlus + duct_pressure_from_q(k, omega, rho0, bases{ia}, qCoef(rows), obsPlus, ductPlus, ia);
        pMinus = pMinus + duct_pressure_from_q(k, omega, rho0, bases{ia}, qCoef(rows), obsMinus, ductMinus, ia);
    end

    powers = modal_power_from_four_probes(pPlus, pMinus, k, omega, rho0, a);
end

%% Geometry
function [aps, bVals] = build_ab_apertures(geo, a)
    Atheta = [geo.phiA1, geo.phiA1 + pi];
    Btheta = [geo.phiA1 + geo.deltaPhiAB, geo.phiA1 + geo.deltaPhiAB + pi];
    aps = struct('theta1', {}, 'theta2', {}, 'thetaC', {}, 'deltaTheta', {}, 'z1', {}, 'z2', {}, 'name', {});
    bVals = [];
    for k = 1:2
        aps(end+1) = make_ap(sprintf('A1_%d', k), Atheta(k), geo.betaA, geo.zA1, geo.LA); %#ok<AGROW>
        bVals(end+1) = a + geo.rA; %#ok<AGROW>
        aps(end+1) = make_ap(sprintf('B1_%d', k), Btheta(k), geo.betaB, geo.zB1, geo.LB); %#ok<AGROW>
        bVals(end+1) = a + geo.rB; %#ok<AGROW>
    end
    for k = 1:2
        aps(end+1) = make_ap(sprintf('A2_%d', k), Atheta(k)+geo.twist, geo.betaA, -geo.zA1, geo.LA); %#ok<AGROW>
        bVals(end+1) = a + geo.rA; %#ok<AGROW>
        aps(end+1) = make_ap(sprintf('B2_%d', k), Btheta(k)+geo.twist, geo.betaB, -geo.zB1, geo.LB); %#ok<AGROW>
        bVals(end+1) = a + geo.rB; %#ok<AGROW>
    end
end

function ap = make_ap(name, thetaC, beta, zC, Lz)
    ap.name = name;
    ap.thetaC = mod(thetaC, 2*pi);
    ap.deltaTheta = beta;
    ap.theta1 = thetaC - beta/2;
    ap.theta2 = thetaC + beta/2;
    ap.z1 = zC - Lz/2;
    ap.z2 = zC + Lz/2;
end

%% Basis and operators
function basis = aperture_basis_theta_z(geom, a, opt)
    [theta, wth] = gauss_legendre(opt.quadTheta, geom.theta1, geom.theta2);
    [z, wz] = gauss_legendre(opt.quadZ, geom.z1, geom.z2);
    [TH, ZZ] = ndgrid(theta, z);
    [WTH, WZ] = ndgrid(wth, wz);
    theta = TH(:);
    z = ZZ(:);
    w = a * WTH(:) .* WZ(:);
    xi = (theta - geom.theta1) / geom.deltaTheta;
    eta = (z - geom.z1) / (geom.z2 - geom.z1);
    raw = [];
    for nt = 0:opt.apertureAngularMax
        for nz = 0:opt.apertureAxialMax
            raw(:, end+1) = cos(nt*pi*xi).*cos(nz*pi*eta); %#ok<AGROW>
        end
    end
    Phi = zeros(size(raw));
    for j = 1:size(raw, 2)
        col = raw(:, j);
        for pass = 1:2
            for q = 1:j-1
                col = col - Phi(:, q)*sum(w.*conj(Phi(:, q)).*col);
            end
        end
        Phi(:, j) = col / max(sqrt(real(sum(w.*abs(col).^2))), eps);
    end
    basis.theta = theta;
    basis.z = z;
    basis.w = w;
    basis.Phi = Phi;
end

function cavData = precompute_cavity_modes(a, bVals, aps, bases, src, opt)
    cavData = cell(1, numel(aps));
    for ia = 1:numel(aps)
        ap = aps(ia);
        basis = bases{ia};
        modes = [];
        for s = 0:opt.cavityAngularMax
            for t = 0:opt.cavityAxialMax
                chi = cavity_surface_mode(ap, basis.theta, basis.z, a, s, t);
                c = basis.Phi' * (basis.w .* chi);
                for p = 0:opt.cavityRadialMax
                    srcAmp = 0;
                    srcX = NaN;
                    if ia == src.apertureIndex
                        [srcAmp, srcX] = cavity_point_mode_at_source(ap, src, a, bVals(ia), s, t);
                    end
                    modes = [modes, struct('c', c, 's', s, 't', t, 'p', p, ...
                        'nu', s*pi/ap.deltaTheta, 'kz', t*pi/(ap.z2-ap.z1), ...
                        'srcAmp', srcAmp*opt.sourceProjectionScale, ...
                        'srcX', srcX, 'lossTan', opt.cavityLossTan, ...
                        'eigenScale', opt.cavityEigenScale, ...
                        'admittanceScale', opt.apertureAdmittanceScale)]; %#ok<AGROW>
                end
            end
        end
        cavData{ia} = modes;
    end
end

function chi = cavity_surface_mode(ap, theta, z, a, s, t)
    dth = ap.deltaTheta;
    L = ap.z2 - ap.z1;
    Ns = sqrt((2 - double(s==0)) / dth);
    Nt = sqrt((2 - double(t==0)) / L);
    chi = Ns*Nt/sqrt(a).*cos(s*pi*(theta-ap.theta1)/dth).*cos(t*pi*(z-ap.z1)/L);
end

function [val, x] = cavity_point_mode_at_source(ap, src, a, b, s, t)
    val = 0;
    x = NaN;
    if src.theta < ap.theta1 || src.theta > ap.theta2 || src.z < ap.z1 || src.z > ap.z2
        return;
    end
    dth = ap.deltaTheta;
    L = ap.z2 - ap.z1;
    x = min(max((src.r-a)/(b-a), 0), 1);
    Ns = sqrt((2 - double(s==0)) / dth);
    Nt = sqrt((2 - double(t==0)) / L);
    val = src.strength * Ns * Nt/sqrt(a) * ...
        cos(s*pi*(src.theta-ap.theta1)/dth) * cos(t*pi*(src.z-ap.z1)/L);
end

function Y = cavity_admittance_projected(k, omega, rho0, a, b, modes)
    nb = numel(modes(1).c);
    Y = zeros(nb);
    for im = 1:numel(modes)
        yst = annular_sector_modal_admittance(k, omega, rho0, a, b, modes(im));
        c = modes(im).c;
        Y = Y + yst * (c*c');
    end
end

function q = cavity_source_projected(k, omega, rho0, a, b, modes)
    nb = numel(modes(1).c);
    q = zeros(nb, 1);
    for im = 1:numel(modes)
        if modes(im).srcAmp == 0
            continue;
        end
        qstp = annular_sector_point_source_flux(k, omega, rho0, a, b, modes(im));
        q = q + qstp * modes(im).srcAmp * modes(im).c;
    end
end

function q = annular_sector_point_source_flux(k, omega, rho0, a, b, mode)
    % Source Green term for q = Y*p + q_src.
    % For each angular/axial channel, use a radial expansion satisfying:
    %   p_src(a)=0 at the aperture plane,
    %   dp_src/dr(b)=0 at the outer hard wall.
    % The aperture source is the normal velocity at r=a:
    %   q_src = -(1/(i*omega*rho0))*dp_src/dr |_{r=a}.
    d = b - a;
    alpha = (mode.p + 0.5)*pi/max(d, 1e-9);
    rMid = 0.5*(a + b);
    radialSrc = sqrt(2/max(d, 1e-9))*sin(alpha*d*mode.srcX);
    radialDerivAtA = sqrt(2/max(d, 1e-9))*alpha;
    lambda2 = mode.eigenScale^2*((mode.nu/max(rMid, 1e-9))^2 + mode.kz^2 + alpha^2);
    denom = (k^2 - lambda2) + 1i*mode.lossTan*k^2;
    q = mode.admittanceScale * -radialDerivAtA*radialSrc/(1i*omega*rho0*denom);
end

function Y = annular_sector_modal_admittance(k, omega, rho0, a, b, mode)
    d = b - a;
    rMid = 0.5*(a + b);
    kr = (mode.p + 0.5)*pi/max(d, 1e-9);
    lambda2 = mode.eigenScale^2*((mode.nu/max(rMid, 1e-9))^2 + mode.kz^2 + kr^2);
    denom = (k^2 - lambda2) + 1i*mode.lossTan*k^2;
    radialSurface = sqrt(2)*cos((mode.p + 0.5)*pi*0);
    Y = mode.admittanceScale * 1i*omega/(rho0*c0_local()) * ...
        (radialSurface^2/max(d, 1e-9)) / denom;
end

function c = c0_local()
    c = 343;
end

function Y = annular_sector_admittance(k, omega, rho0, a, b, nu, kz)
    radialK2 = k^2 - kz^2;
    if radialK2 < -1e-12
        gamma = sqrt(-radialK2);
        xa = gamma*a; xb = gamma*b;
        Ipb = besselip(nu, xb); Kpb = besselkp(nu, xb);
        F = Kpb*besseli(nu, xa) - Ipb*besselk(nu, xa);
        Fp = gamma*(Kpb*besselip(nu, xa) - Ipb*besselkp(nu, xa));
        fpOverF = Fp/F;
    else
        kr = sqrt_complex(radialK2);
        if abs(nu) > 15
            ratio = (a/b)^(2*nu);
            X = a/nu*(1+ratio)/max(1-ratio, eps);
            Y = 1/(1i*omega*rho0*X);
            return;
        end
        if abs(kr) < 1e-12
            if abs(nu) < 1e-12
                fpOverF = 1/(a*log(a/b));
            else
                fpOverF = nu*(a^(nu-1)-b^(2*nu)*a^(-nu-1))/(a^nu+b^(2*nu)*a^(-nu));
            end
        else
            za = kr*a; zb = kr*b;
            Jpb = besseljp(nu, zb); Ypb = besselyp(nu, zb);
            F = Ypb*besselj(nu, za) - Jpb*bessely(nu, za);
            Fp = kr*(Ypb*besseljp(nu, za) - Jpb*besselyp(nu, za));
            fpOverF = Fp/F;
        end
    end
    Y = -fpOverF/(1i*omega*rho0);
end

%% Duct propagation and probes
function data = precompute_duct_modes(a, bases, obs, opt)
    mVals = []; muVals = []; phiObs = []; phiBasis = cell(size(bases));
    for m = -opt.ductM:opt.ductM
        roots = duct_roots_for_m(abs(m), opt.ductRadialRoots);
        for ir = 1:numel(roots)
            mu = roots(ir);
            norm2 = duct_mode_norm2(abs(m), mu, a);
            wall = duct_radial_shape(abs(m), mu, a, a);
            phiObs(:, end+1) = duct_radial_shape(abs(m), mu, obs.r, a).*exp(1i*m*obs.theta)/sqrt(norm2); %#ok<AGROW>
            mVals(end+1, 1) = m; %#ok<AGROW>
            muVals(end+1, 1) = mu; %#ok<AGROW>
            for ia = 1:numel(bases)
                phiBasis{ia}(:, end+1) = wall*exp(1i*m*bases{ia}.theta)/sqrt(norm2);
            end
        end
    end
    data.a = a; data.m = mVals; data.mu = muVals; data.phiObs = phiObs; data.phiBasis = phiBasis;
end

function G = duct_green_matrix_between(k, omega, rho0, basisObs, basisSrc, data, obsIndex, srcIndex)
    nbObs = size(basisObs.Phi, 2); nbSrc = size(basisSrc.Phi, 2);
    G = zeros(nbObs, nbSrc);
    for im = 1:numel(data.mu)
        beta = sqrt_complex(k^2 - (data.mu(im)/data.a)^2);
        phiObs = data.phiBasis{obsIndex}(:, im);
        phiSrc = data.phiBasis{srcIndex}(:, im);
        Gz = free_space_duct_green(beta, basisObs.z, basisSrc.z);
        src = (basisSrc.w.*conj(phiSrc)).*basisSrc.Phi;
        P = 1i*omega*rho0*(phiObs.*(Gz*src));
        G = G + basisObs.Phi'*(basisObs.w.*P);
    end
end

function p = duct_pressure_from_q(k, omega, rho0, basis, qCoef, obs, data, srcIndex)
    qNodes = basis.Phi*qCoef;
    p = zeros(numel(obs.r), 1);
    for im = 1:numel(data.mu)
        beta = sqrt_complex(k^2 - (data.mu(im)/data.a)^2);
        phiSrc = data.phiBasis{srcIndex}(:, im);
        phiObs = data.phiObs(:, im);
        src0 = basis.w.*conj(phiSrc).*qNodes;
        Gz = free_space_duct_green(beta, obs.z, basis.z);
        p = p + 1i*omega*rho0*phiObs.*(Gz*src0);
    end
end

function G = free_space_duct_green(beta, zObs, zSrc)
    G = 1/(2i*beta)*exp(1i*beta*abs(zObs(:)-zSrc(:).'));
end

function obs = four_wall_probe(a, z)
    theta = [0; 0.5*pi; pi; 1.5*pi];
    obs.r = a*ones(size(theta));
    obs.theta = theta;
    obs.z = z*ones(size(theta));
end

function powers = modal_power_from_four_probes(pPlus, pMinus, k, omega, rho0, a)
    alpha = [0; 0.5*pi; pi; 1.5*pi];
    cz1 = mean(pPlus.*exp(-1i*1*alpha));
    cz0 = mean(pPlus);
    czm = mean(pPlus.*exp(+1i*1*alpha));
    cf1 = mean(pMinus.*exp(+1i*1*alpha));
    cf0 = mean(pMinus);
    cfm = mean(pMinus.*exp(-1i*1*alpha));
    kz00 = k;
    kz10 = sqrt_complex(k^2 - (1.841183781/a)^2);
    C0 = real(kz00*pi*a^2/(2*rho0*omega));
    C1 = real(kz10*pi*a^2*(1-(1/1.841183781)^2)*(besselj(1,1.841183781))^2/(2*rho0*omega));
    powers = [abs(cz1/besselj(1,1.841183781))^2*C1, abs(cz0)^2*C0, ...
        abs(czm/besselj(1,1.841183781))^2*C1, ...
        abs(cf1/besselj(1,1.841183781))^2*C1, abs(cf0)^2*C0, ...
        abs(cfm/besselj(1,1.841183781))^2*C1] / 1e-4;
end

%% Plot and utilities
function plot_modal_power(freq, modalPower, raw, outDir)
    labels = {'Ez1','Ez0','Ez-1','Ef1','Ef0','Ef-1'};
    fig = figure('Color','w','Position',[80 80 1280 760]);
    tiledlayout(3,2,'Padding','compact','TileSpacing','compact');
    if ~isempty(raw) && size(raw,2) >= 7
        target = raw(:,2:7);
        scale = sum(target(:).*modalPower(:))/max(sum(modalPower(:).^2), eps);
    else
        target = [];
        scale = 1;
    end
    for k = 1:6
        nexttile; hold on; grid on; box on;
        if ~isempty(target)
            plot(freq, target(:,k), 'k-', 'LineWidth', 1.5, 'DisplayName','COMSOL Output');
        end
        plot(freq, scale*modalPower(:,k), 'r--', 'LineWidth', 1.6, 'DisplayName','theory');
        title(labels{k});
        xlabel('Frequency [Hz]'); ylabel('Power / 1e-4 W');
        legend('Location','best');
    end
    exportgraphics(fig, fullfile(outDir, 'theory_ab_aperture_mapping_vs_output.png'), 'Resolution', 220);
end

function useParallel = prepare_parallel_pool(opt)
    useParallel = isfield(opt,'useParallel') && opt.useParallel && exist('parpool','file') == 2;
    if ~useParallel, return; end
    pool = gcp('nocreate');
    if isempty(pool)
        try
            parpool('local', opt.parallelWorkers);
        catch
            useParallel = false;
        end
    end
end

function radial = duct_radial_shape(mAbs, mu, r, a)
    if mu == 0, radial = ones(size(r)); else, radial = besselj(mAbs, mu*r/a); end
end

function norm2 = duct_mode_norm2(mAbs, mu, a)
    if mu == 0
        norm2 = pi*a^2;
    else
        fun = @(r) besselj(mAbs, mu*r/a).^2.*r;
        norm2 = 2*pi*integral(fun, 0, a, 'RelTol',1e-9,'AbsTol',1e-12);
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
    key = sprintf('m%d_n%d', m, n);
    if isstruct(cache) && isfield(cache, key)
        x = cache.(key);
        return;
    end
    if m == 0
        f = @(x) -besselj(1,x);
    else
        f = @(x) 0.5*(besselj(m-1,x)-besselj(m+1,x));
    end
    hi = max(20, m + (n + 2)*pi);
    roots = [];
    for tries = 1:20
        xs = linspace(1e-6, hi, max(5000, ceil(500*hi)));
        ys = f(xs);
        good = isfinite(ys(1:end-1)) & isfinite(ys(2:end));
        idxs = find(good & ys(1:end-1).*ys(2:end) < 0);
        roots = nan(numel(idxs), 1);
        for ii = 1:numel(idxs)
            try
                roots(ii) = fzero(f, [xs(idxs(ii)), xs(idxs(ii)+1)]);
            catch
                roots(ii) = NaN;
            end
        end
        roots = roots(isfinite(roots));
        roots = unique(round(roots, 10));
        roots = roots(roots > 1e-8);
        if numel(roots) >= n
            x = roots(n);
            if ~isstruct(cache), cache = struct(); end
            cache.(key) = x;
            return;
        end
        hi = hi + 20;
    end
    error('Could not find Neumann root m=%d n=%d', m, n);
end

function y = sqrt_complex(x)
    y = sqrt(complex(x));
    if imag(y) < 0, y = -y; end
end

function y = besselip(nu,x), y = 0.5*(besseli(nu-1,x)+besseli(nu+1,x)); end
function y = besselkp(nu,x), y = -0.5*(besselk(nu-1,x)+besselk(nu+1,x)); end
function y = besseljp(nu,x), y = 0.5*(besselj(nu-1,x)-besselj(nu+1,x)); end
function y = besselyp(nu,x), y = 0.5*(bessely(nu-1,x)-bessely(nu+1,x)); end

function [x,w] = gauss_legendre(n,a,b)
    beta = 0.5./sqrt(1-(2*(1:n-1)).^(-2));
    T = diag(beta,1)+diag(beta,-1);
    [V,D] = eig(T);
    [x0,idx] = sort(diag(D));
    V = V(:,idx);
    w0 = 2*(V(1,:).^2).';
    x = (b-a)/2*x0 + (a+b)/2;
    w = (b-a)/2*w0;
end
