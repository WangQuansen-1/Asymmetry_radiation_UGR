%% aperture_basis_v1_rij
% Aperture_Basis_V1
%
% Phase 3: recover the physical 3x3 reflection matrix for propagating
% modes m=+1, 0, and m=-1.  No fitting factors, scale factors,
% radiation corrections, or empirical end corrections are used.

clear; close all; clc;

c0 = 343;
rho0 = 1.2;
a = 50e-3;
comsolRijFile = 'Cav1234_Rij.txt';
zObs = 160e-3;
zHard = 400e-3;
cav1ThetaDeg = [10, 35.94];
cav2ThetaDeg = [39.2475, 99.5731];
cav1Depth = 24e-3;
cav1LengthZ = 6.2967e-3;
cav2Depth = 32.2570e-3;
cav2LengthZ = 9.3903e-3;

freq = (2800:10:3100).';

opt.quadTheta = 20;
opt.quadZ = 10;
opt.ductM = 30;
opt.ductRadialRoots = 40;
opt.apertureAngularMax = 4;
opt.apertureAxialMax = 2;

opt.cavityAngularMax = 8;
opt.cavityAxialMax = 4;

opt.useParallel = true;
opt.parallelWorkers = 8;

baseGeom = base_geometry(zHard, cav1LengthZ);
geom1 = manual_geometry(baseGeom, cav1ThetaDeg, []);
geom3 = geom1;
geom3.theta1 = geom1.theta1 + pi;
geom3.theta2 = geom1.theta2 + pi;
geom3.thetaC = geom1.thetaC + pi;
geom2 = manual_geometry(baseGeom, cav2ThetaDeg, cav2LengthZ);
geom4 = geom2;
geom4.theta1 = geom2.theta1 + pi;
geom4.theta2 = geom2.theta2 + pi;
geom4.thetaC = geom2.thetaC + pi;
geoms = [geom1, geom2, geom3, geom4];
bVals = a + [cav1Depth, cav2Depth, cav1Depth, cav2Depth];
bases = cell(1, numel(geoms));
for ia = 1:numel(geoms)
    bases{ia} = aperture_basis_v1(geoms(ia), a, opt);
end
obsProbe = four_wall_probe_observation(a, zObs, geom1);
ductData = precompute_duct_modes_multi(a, bases, obsProbe, opt);
cavData = precompute_cavity_modes(a, geoms, bases, opt);

fprintf('\n=== aperture_basis_v1_rij Cav1+Cav2+Cav3+Cav4 ===\n');
fprintf('branch model: Aperture_Basis_V1\n');
for ia = 1:numel(geoms)
    fprintf('Cav%d theta=[%.6f %.6f] deg, dtheta=%.6f deg, r depth=%.4f mm, z length=%.4f mm\n', ...
        ia, rad2deg(geoms(ia).theta1), rad2deg(geoms(ia).theta2), ...
        rad2deg(geoms(ia).deltaTheta), (bVals(ia)-a)*1e3, (geoms(ia).z2-geoms(ia).z1)*1e3);
end
fprintf('basis count per aperture=%d, total=%d\n', size(bases{1}.Phi,2), ...
    size(bases{1}.Phi,2) * numel(bases));
fprintf('aperture basis theta n=0..%d, z n=0..%d\n', opt.apertureAngularMax, opt.apertureAxialMax);
fprintf('cavity angular modes s=0..%d, axial t=0..%d\n', opt.cavityAngularMax, opt.cavityAxialMax);
fprintf('duct Green truncation: m=-%d..%d, radial roots=%d\n', opt.ductM, opt.ductM, opt.ductRadialRoots);
fprintf('precomputed duct modes=%d\n', numel(ductData.mu));

[Rmat] = recover_rij(freq, c0, rho0, a, bVals, bases, obsProbe, ductData, cavData, opt);
write_rij_table(freq, Rmat);
plot_rij_compare(freq, Rmat, comsolRijFile);

fprintf('\nwrote: aperture_basis_v1_rij_cav1234_complex.csv\n');
fprintf('wrote: aperture_basis_v1_rij_cav1234_compare.png\n');

function geom = base_geometry(zHard, zLength)
    geom.theta1 = 0;
    geom.theta2 = 0;
    geom.thetaC = 0;
    geom.deltaTheta = 0;
    geom.zHard = zHard;
    geom.z1 = 0;
    geom.z2 = zLength;
end

function geom = manual_geometry(baseGeom, thetaDeg, zLength)
    geom = baseGeom;
    geom.theta1 = deg2rad(thetaDeg(1));
    geom.theta2 = deg2rad(thetaDeg(2));
    geom.thetaC = 0.5*(geom.theta1 + geom.theta2);
    geom.deltaTheta = geom.theta2 - geom.theta1;
    if ~isempty(zLength)
        geom.z2 = geom.z1 + zLength;
    end
end

function Rmat = recover_rij(freq, c0, rho0, a, bVals, bases, obsProbe, ductData, cavData, opt)
    incModes = [1 -1];
    Rmat = zeros(numel(freq), 3, 2);
    alpha = (0:3).' * 0.5*pi;
    useParallel = prepare_parallel_pool(opt);

    if useParallel
        fprintf('Rij recovery: parallel over %d frequency points.\n', numel(freq));
        parfor jf = 1:numel(freq)
            Rone = recover_rij_one_frequency(freq(jf), incModes, alpha, ...
                c0, rho0, a, bVals, bases, obsProbe, ductData, cavData);
            Rmat(jf,:,:) = Rone;
        end
    else
        fprintf('Rij recovery: serial over %d frequency points.\n', numel(freq));
        for jf = 1:numel(freq)
            Rone = recover_rij_one_frequency(freq(jf), incModes, alpha, ...
                c0, rho0, a, bVals, bases, obsProbe, ductData, cavData);
            Rmat(jf,:,:) = Rone;
        end
    end
end

function useParallel = prepare_parallel_pool(opt)
    useParallel = isfield(opt, 'useParallel') && opt.useParallel;
    if ~useParallel
        return;
    end
    if exist('parpool', 'file') ~= 2
        warning('parpool is not available on the MATLAB path. Falling back to serial calculation.');
        useParallel = false;
        return;
    end
    pool = gcp('nocreate');
    if isempty(pool)
        if isfield(opt, 'parallelWorkers') && ~isempty(opt.parallelWorkers)
            workerList = unique([opt.parallelWorkers, 6, 4, 2], 'stable');
        else
            workerList = [8, 6, 4, 2];
        end
        for iw = 1:numel(workerList)
            try
                pool = parpool('local', workerList(iw));
                break;
            catch ME
                warning('Could not start a %d-worker parallel pool (%s).', workerList(iw), ME.message);
            end
        end
        if isempty(pool)
            warning('Could not start a parallel pool. Falling back to serial calculation.');
            useParallel = false;
            return;
        end
    end
    fprintf('parallel pool: %d workers\n', pool.NumWorkers);
end

function Rone = recover_rij_one_frequency(f, incModes, alpha, c0, rho0, a, bVals, bases, obsProbe, ductData, cavData)
    Rone = zeros(3, numel(incModes));
    omega = 2*pi*f;
    k = omega/c0;
    nAps = numel(bases);
    nb = size(bases{1}.Phi, 2);
    Gduct = zeros(nAps*nb, nAps*nb);
    Ycav = zeros(nAps*nb, nAps*nb);
    for io = 1:nAps
        rows = (io-1)*nb + (1:nb);
        Ycav(rows, rows) = cavity_admittance_projected(k, omega, rho0, a, bVals(io), cavData{io});
        for is = 1:nAps
            cols = (is-1)*nb + (1:nb);
            Gduct(rows, cols) = duct_green_matrix_between(k, omega, rho0, ...
                bases{io}, bases{is}, ductData, io, is);
        end
    end
    A = eye(size(Gduct)) - Gduct * Ycav;

    for ii = 1:numel(incModes)
        inc = incModes(ii);
        rhs = zeros(nAps*nb, 1);
        for ia = 1:nAps
            rows = (ia-1)*nb + (1:nb);
            pIncNodes = incident_rigid_pressure(k, a, bases{ia}, inc);
            rhs(rows) = bases{ia}.Phi' * (bases{ia}.w .* pIncNodes);
        end
        pCoef = A \ rhs;
        qCoef = Ycav * pCoef;

        psProbe = hard_reflected_pressure(k, a, obsProbe, inc);
        for ia = 1:nAps
            rows = (ia-1)*nb + (1:nb);
            psProbe = psProbe + duct_pressure_from_q(k, omega, rho0, ...
                bases{ia}, qCoef(rows), obsProbe, ductData, ia);
        end
        pbProbe = comsol_style_background_pressure(k, a, obsProbe, inc);

        [cFirstRaw, cZeroRaw, cThirdRaw] = comsol_fourier_coeff(psProbe, alpha);
        cin = mean(pbProbe(:) .* exp(-1i*inc*alpha));

        % COMSOL definitions in D100mm_CPA_EP_DH_no_solve.m:
        %   c_10  = mean(p_s * exp(+i*1*alpha))      -> + reflected
        %   c_00  = mean(p_s)                        -> 0 reflected
        %   c__1  = mean(p_s * exp(+i*(-1)*alpha))   -> - reflected
        Rone(1,ii) = cFirstRaw / cin; % +ref
        Rone(2,ii) = cZeroRaw / cin;  % 0ref
        Rone(3,ii) = cThirdRaw / cin; % -ref
    end
end

function p = incident_rigid_pressure(k, a, basis, mComsol)
    % COMSOL bpf3 uses p_10_2 = J1(k10*r2)*exp(+i*th2)*exp(-i*kz10*z)
    % while cin_10 extracts it with mean(p_b*exp(-i*alpha)).  Therefore
    % the incident field driving the aperture must use the same physical
    % angular sign as the COMSOL-labelled incident mode.
    mGlobal = mComsol;
    mu = modal_mu(mComsol);
    beta = sqrt(k^2 - (mu/a)^2);
    if mGlobal == 0
        wallShape = ones(size(basis.theta));
    else
        wallShape = besselj(abs(mGlobal), mu) * exp(1i*mGlobal*basis.theta);
    end
    p = 2 * wallShape .* cos(beta * basis.z);
end

function p = hard_reflected_pressure(k, a, obs, mComsol)
    mGlobal = mComsol;
    mu = modal_mu(mComsol);
    beta = sqrt(k^2 - (mu/a)^2);
    if mGlobal == 0
        radial = ones(size(obs.r));
    else
        radial = besselj(abs(mGlobal), mu*obs.r/a) .* exp(1i*mGlobal*obs.theta);
    end
    p = radial .* exp(1i*beta*obs.z);
end

function ps = duct_pressure_from_q(k, omega, rho0, basis, qCoef, obs, ductData, srcIndex)
    qNodes = basis.Phi * qCoef;
    ps = zeros(numel(obs.r),1);
    for im = 1:numel(ductData.mu)
        beta = sqrt_complex(k^2 - (ductData.mu(im)/ductData.a)^2);
        phiSrc = ductData.phiBasis{srcIndex}(:,im);
        phiObs = ductData.phiObs(:,im);
        src0 = basis.w .* conj(phiSrc) .* qNodes;
        Gz = hard_end_green_between(beta, obs.z, basis.z);
        ps = ps + 1i*omega*rho0 * phiObs .* (Gz * src0);
    end
end

function obs = four_wall_probe_observation(a, zObs, geom)
    theta = [-0.5*pi; 0; 0.5*pi; pi];
    obs.r = a * ones(size(theta));
    obs.theta = theta;
    obs.z = (geom.zHard - zObs) * ones(size(theta));
end

function p = comsol_style_background_pressure(k, a, obs, inc)
    mu = modal_mu(inc);
    beta = sqrt(k^2 - (mu/a)^2);
    if inc == 0
        radial = ones(size(obs.r));
    else
        radial = besselj(abs(inc), mu*obs.r/a);
    end
    p = radial .* exp(1i*inc*obs.theta) .* exp(-1i*beta*obs.z);
end

function [cFirst, cZero, cThird] = comsol_fourier_coeff(p, alpha)
    p = p(:);
    cFirst = mean(p .* exp(1i*1*alpha));
    cZero = mean(p);
    cThird = mean(p .* exp(1i*(-1)*alpha));
end

function write_rij_table(freq, Rmat)
    rows = [];
    names = ["Rpp","R0p","Rmp","Rpm","R0m","Rmm"];
    pairs = [1 1; 2 1; 3 1; 1 2; 2 2; 3 2];
    for jf = 1:numel(freq)
        for k = 1:numel(names)
            r = pairs(k,1);
            c = pairs(k,2);
            z = Rmat(jf,r,c);
            rows = [rows; freq(jf), k, real(z), imag(z), abs(z), angle(z)]; %#ok<AGROW>
        end
    end
    T = array2table(rows, 'VariableNames', {'freq_Hz','entry','real_R','imag_R','abs_R','angle_R'});
    T.name = names(T.entry).';
    T = movevars(T, 'name', 'After', 'entry');
    writetable(T, 'aperture_basis_v1_rij_cav1234_complex.csv');
end

function plot_rij_compare(freq, Rmat, comsolFile)
    C = readmatrix(comsolFile, 'FileType','text', 'CommentStyle','%');
    names = ["Rpp","R0p","Rmp","Rpm","R0m","Rmm"];
    pairs = [1 1; 2 1; 3 1; 1 2; 2 2; 3 2];
    groups = {1:3, 4:6};
    titles = ["+ incidence", "- incidence"];
    colors = lines(3);

    fig = figure('Color','w','Position',[80 80 1280 520]);
    tiledlayout(1,2,'Padding','compact','TileSpacing','compact');
    for ig = 1:2
        nexttile; hold on; grid on; box on;
        for jj = 1:3
            k = groups{ig}(jj);
            r = pairs(k,1);
            c = pairs(k,2);
            plot(freq, abs(squeeze(Rmat(:,r,c))), '-', ...
                'Color', colors(jj,:), 'LineWidth', 1.8, ...
                'DisplayName', sprintf('MATLAB %s', names(k)));
            plot(C(:,1), C(:,k+1), 'o', ...
                'Color', colors(jj,:), 'MarkerSize', 4.5, ...
                'LineStyle', 'none', ...
                'DisplayName', sprintf('COMSOL %s', names(k)));
        end
        xlabel('Frequency (Hz)');
        ylabel('|R|');
        title(titles(ig));
        legend('Location','best');
    end
    sgtitle('Cav1234 Rij comparison');
    exportgraphics(fig, 'aperture_basis_v1_rij_cav1234_compare.png', 'Resolution', 240);
end

function ductData = precompute_duct_modes_multi(a, bases, obs, opt)
    mVals = [];
    muVals = [];
    phiObs = [];
    phiBasis = cell(size(bases));
    for m = -opt.ductM:opt.ductM
        roots = duct_roots_for_m(abs(m), opt.ductRadialRoots);
        for ir = 1:numel(roots)
            mu = roots(ir);
            norm2 = duct_mode_norm2(abs(m), mu, a);
            radialAtWall = duct_radial_shape(abs(m), mu, a, a);
            obsShape = duct_radial_shape(abs(m), mu, obs.r, a) .* exp(1i*m*obs.theta) / sqrt(norm2);
            mVals(end+1,1) = m; %#ok<AGROW>
            muVals(end+1,1) = mu; %#ok<AGROW>
            phiObs(:,end+1) = obsShape; %#ok<AGROW>
            for ia = 1:numel(bases)
                basisShape = radialAtWall * exp(1i*m*bases{ia}.theta) / sqrt(norm2);
                phiBasis{ia}(:,end+1) = basisShape;
            end
        end
    end
    ductData.a = a;
    ductData.m = mVals;
    ductData.mu = muVals;
    ductData.phiBasis = phiBasis;
    ductData.phiObs = phiObs;
end

function basis = aperture_basis_v1(geom, a, opt)
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
            raw(:,end+1) = cos(nt*pi*xi) .* cos(nz*pi*eta); %#ok<AGROW>
        end
    end

    Phi = zeros(size(raw));
    for j = 1:size(raw,2)
        col = raw(:,j);
        for pass = 1:2
            for q = 1:j-1
                col = col - Phi(:,q) * sum(w .* conj(Phi(:,q)) .* col);
            end
        end
        nrm = sqrt(real(sum(w .* abs(col).^2)));
        Phi(:,j) = col / max(nrm, eps);
    end

    basis.theta = theta;
    basis.z = z;
    basis.w = w;
    basis.Phi = Phi;
    basis.raw = raw;
    basis.gram_raw = raw' * (w .* raw);
end

function G = duct_green_matrix_between(k, omega, rho0, basisObs, basisSrc, ductData, obsIndex, srcIndex)
    nbObs = size(basisObs.Phi,2);
    nbSrc = size(basisSrc.Phi,2);
    G = zeros(nbObs, nbSrc);
    phiObsAll = ductData.phiBasis{obsIndex};
    phiSrcAll = ductData.phiBasis{srcIndex};
    for im = 1:numel(ductData.mu)
        beta = sqrt_complex(k^2 - (ductData.mu(im)/ductData.a)^2);
        phiObs = phiObsAll(:,im);
        phiSrc = phiSrcAll(:,im);
        Gz = hard_end_green_between(beta, basisObs.z, basisSrc.z);
        src = (basisSrc.w .* conj(phiSrc)) .* basisSrc.Phi;
        P = 1i*omega*rho0 * (phiObs .* (Gz * src));
        G = G + basisObs.Phi' * (basisObs.w .* P);
    end
end

function cavData = precompute_cavity_modes(a, geoms, bases, opt)
    cavData = cell(1, numel(bases));
    for ia = 1:numel(bases)
        geom = geoms(ia);
        basis = bases{ia};
        rows = [];
        for s = 0:opt.cavityAngularMax
            for t = 0:opt.cavityAxialMax
                chi = cavity_surface_mode(geom, basis.theta, basis.z, a, s, t);
                c = basis.Phi' * (basis.w .* chi);
                rows = [rows, struct( ...
                    'c', c, ...
                    'nu', s*pi/geom.deltaTheta, ...
                    'kz', t*pi/(geom.z2-geom.z1))]; %#ok<AGROW>
            end
        end
        cavData{ia} = rows;
    end
end

function Y = cavity_admittance_projected(k, omega, rho0, a, b, cavModes)
    nb = numel(cavModes(1).c);
    Y = zeros(nb, nb);
    for im = 1:numel(cavModes)
        yst = annular_sector_admittance(k, omega, rho0, a, b, cavModes(im).nu, cavModes(im).kz);
        c = cavModes(im).c;
        Y = Y + yst * (c * c');
    end
end

function chi = cavity_surface_mode(geom, theta, z, a, s, t)
    dth = geom.deltaTheta;
    L = geom.z2 - geom.z1;
    Ns = sqrt((2 - double(s==0)) / dth);
    Nt = sqrt((2 - double(t==0)) / L);
    chi = Ns * Nt / sqrt(a) .* ...
        cos(s*pi*(theta-geom.theta1)/dth) .* cos(t*pi*(z-geom.z1)/L);
end

function Y = annular_sector_admittance(k, omega, rho0, a, b, nu, kz)
    radialK2 = k^2 - kz^2;
    if radialK2 < -1e-12
        gamma = sqrt(-radialK2);
        xa = gamma*a;
        xb = gamma*b;
        Ipb = besselip(nu, xb);
        Kpb = besselkp(nu, xb);
        F = Kpb*besseli(nu, xa) - Ipb*besselk(nu, xa);
        Fp = gamma*(Kpb*besselip(nu, xa) - Ipb*besselkp(nu, xa));
        fpOverF = Fp / F;
    else
        kr = sqrt_complex(radialK2);
        if abs(nu) > 15
            ratio = (a/b)^(2*nu);
            X = a/nu * (1 + ratio) / max(1 - ratio, eps);
            Y = 1 / (1i*omega*rho0*X);
            return;
        end
        if abs(kr) < 1e-12
            if abs(nu) < 1e-12
                fpOverF = 1 / (a * log(a/b));
            else
                fpOverF = nu*(a^(nu-1) - b^(2*nu)*a^(-nu-1)) / ...
                    (a^nu + b^(2*nu)*a^(-nu));
            end
        else
            za = kr*a;
            zb = kr*b;
            Jpb = besseljp(nu, zb);
            Ypb = besselyp(nu, zb);
            F = Ypb*besselj(nu, za) - Jpb*bessely(nu, za);
            Fp = kr*(Ypb*besseljp(nu, za) - Jpb*besselyp(nu, za));
            fpOverF = Fp / F;
        end
    end
    Y = -fpOverF / (1i*omega*rho0);
end

function G = hard_end_green_between(beta, zObs, zSrc)
    zo = zObs(:);
    zs = zSrc(:).';
    G = 1/(2i*beta) * (exp(1i*beta*abs(zo - zs)) + exp(1i*beta*(zo + zs)));
end

function radial = duct_radial_shape(mAbs, mu, r, a)
    if mu == 0
        radial = ones(size(r));
    else
        radial = besselj(mAbs, mu*r/a);
    end
end

function norm2 = duct_mode_norm2(mAbs, mu, a)
    if mu == 0
        norm2 = pi*a^2;
    else
        fun = @(r) (besselj(mAbs, mu*r/a).^2).*r;
        norm2 = 2*pi*integral(fun, 0, a, 'RelTol',1e-10,'AbsTol',1e-12);
    end
end

function mu = modal_mu(m)
    if m == 0
        mu = 0;
    else
        mu = 1.84;
    end
end

function roots = duct_roots_for_m(m, nRoots)
    if nRoots == 0
        if m == 0
            roots = 0;
        else
            roots = [];
        end
        return;
    end
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
    key = sprintf('abv1_m%d_n%d', m, n);
    if isstruct(cache) && isfield(cache, key)
        x = cache.(key);
        return;
    end
    if m == 0
        f = @(x) -besselj(1,x);
    else
        f = @(x) 0.5*(besselj(m-1,x) - besselj(m+1,x));
    end
    hi = max(20, m + (n + 1.5)*pi + 5);
    roots = [];
    for it = 1:20
        grid = linspace(1e-6, hi, max(4000, ceil(300*hi)));
        vals = f(grid);
        good = isfinite(vals(1:end-1)) & isfinite(vals(2:end));
        idxs = find(good & vals(1:end-1).*vals(2:end) < 0);
        roots = nan(numel(idxs),1);
        for ii = 1:numel(idxs)
            try
                roots(ii) = fzero(f, [grid(idxs(ii)), grid(idxs(ii)+1)]);
            catch
                roots(ii) = NaN;
            end
        end
        roots = roots(isfinite(roots));
        roots = unique(round(roots, 10));
        roots = roots(roots > 1e-8);
        if numel(roots) >= n
            break;
        end
        hi = hi + 20;
    end
    x = roots(n);
    if ~isstruct(cache), cache = struct(); end
    cache.(key) = x;
end

function y = sqrt_complex(x)
    y = sqrt(complex(x));
    if imag(y) < 0
        y = -y;
    end
end

function y = besselip(nu, x)
    y = 0.5*(besseli(nu-1,x) + besseli(nu+1,x));
end

function y = besselkp(nu, x)
    y = -0.5*(besselk(nu-1,x) + besselk(nu+1,x));
end

function y = besseljp(nu, x)
    y = 0.5*(besselj(nu-1,x) - besselj(nu+1,x));
end

function y = besselyp(nu, x)
    y = 0.5*(bessely(nu-1,x) - bessely(nu+1,x));
end

function [x,w] = gauss_legendre(n,a,b)
    beta = 0.5 ./ sqrt(1 - (2*(1:n-1)).^(-2));
    T = diag(beta,1) + diag(beta,-1);
    [V,D] = eig(T);
    x0 = diag(D);
    [x0,idx] = sort(x0);
    V = V(:,idx);
    w0 = 2*(V(1,:).^2).';
    x = (b-a)/2*x0 + (a+b)/2;
    w = (b-a)/2*w0;
end
