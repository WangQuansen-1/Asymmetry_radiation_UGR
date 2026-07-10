%% theory_ab_bilayer_radiated_field
% Theoretical radiation-field calculation for the bilayer A/B azimuthal
% acoustic resonator.
%
% This script does not call COMSOL and does not use finite elements.
% It uses:
%   1) Radial high-order expansion inside each A/B cavity.
%   2) Inter-cavity Green-type coupling between the expanded cavity modes.
%   3) Aperture-overlap mapping from cavity radial modes to cylindrical duct
%      modes m = 0, +1, -1.
%
% The goal is to provide a transparent theoretical field model that can be
% refined against COMSOL Output.txt after the geometry is fully confirmed.

clear; clc; close all;

%% Physical constants
par.c0 = 343;               % sound speed [m/s]
par.rho0 = 1.21;            % air density [kg/m^3]
par.R0 = 50e-3;             % main duct radius [m]
par.Psrc = 1e-4;            % source acoustic power [W], used for scaling

%% Frequency grid
dataFile = fullfile(fileparts(mfilename('fullpath')), 'Output.txt');
if exist(dataFile, 'file')
    raw = readmatrix(dataFile);
    freq = raw(:, 1);
else
    freq = linspace(2550, 2660, 301).';
end
omega = 2*pi*freq;

%% Geometry from current discussion
geo.rA = 0.01842774646;          % radial thickness of cavity A [m]
geo.rB = 0.01596993708;          % radial thickness of cavity B [m]
geo.betaA = deg2rad(59.217);     % angular width of cavity A [rad]
geo.betaB = deg2rad(57.512);     % angular width of cavity B [rad]
geo.LA = 0.02193599333;          % axial thickness of cavity A [m]
geo.LB = 0.02579109896;          % axial thickness of cavity B [m]
geo.phiA1 = deg2rad(28);         % current placeholder until exact angle is fixed
geo.deltaPhiAB = deg2rad(86);    % current placeholder until exact angle is fixed
geo.twist = deg2rad(10);         % layer 2 rotation after xy mirror
geo.zA1 = 0.04360763048 + geo.LA/2;
geo.zB1 = 0.08778030667 + geo.LB/2;

% Point source inside cavity A of layer 1.
src.cavityIndex = 1;
src.strength = sqrt(par.Psrc);
src.r = par.R0 + 0.55*geo.rA;

%% Build equivalent resonator list
cav = buildCavities(par, geo);
Nc = numel(cav);

%% Lumped acoustic resonator parameters
% Volumes are annular-sector volumes.
for j = 1:Nc
    cav(j).V = 0.5*cav(j).beta*((par.R0 + cav(j).rOut)^2 - par.R0^2)*cav(j).Lz;
    cav(j).S = par.R0*cav(j).beta*cav(j).Lz; % opening area at the duct wall
    cav(j).leff = max(0.65*cav(j).rOut, 2e-3);
    cav(j).omega0 = par.c0*sqrt(cav(j).S/(cav(j).V*cav(j).leff));
end

% Loss and coupling settings. These are theoretical model parameters, not
% fitted channel amplitudes. They represent wall/viscous loss and near-field
% cavity coupling strength.
model.lossFracA = 0.020;
model.lossFracB = 0.020;
model.kappaScale = 0.060;        % coupling fraction of omega0
model.couplingDecay = 0.060;     % spatial decay length [m]
model.radiationScale = 1.0;
model.numRadialOrders = 6;       % radial expansion order inside each cavity
model.radialDispersion = 0.35;   % strength of high-radial-order frequency shift
model.radialCouplingDecay = 1.4; % coupling decay versus radial-order mismatch

radialModes = buildRadialModes(cav, src, model, par);

%% Solve resonator response and modal radiation
mList = [-1, 0, +1];
alphaPrime = containers.Map({'-1','0','1'}, [1.841183781, 0, 1.841183781]);

Aplus = zeros(numel(freq), numel(mList));
Aminus = zeros(numel(freq), numel(mList));
Pplus = zeros(numel(freq), numel(mList));
Pminus = zeros(numel(freq), numel(mList));

for ii = 1:numel(freq)
    w = omega(ii);
    k0 = w/par.c0;
    a = solveRadialModeAmplitudes(radialModes, cav, src, w, model);

    for im = 1:numel(mList)
        m = mList(im);
        alpha = alphaPrime(num2str(abs(m)));
        if alpha == 0
            kr = 0;
        else
            kr = alpha/par.R0;
        end
        kz = sqrt(complex(k0^2 - kr^2, 0));

        [Aplus(ii, im), Aminus(ii, im)] = radiateModeFromRadialExpansion(cav, radialModes, a, m, kz, model);
        normM = ductModeNorm(par.R0, m, alpha);
        Pplus(ii, im) = modalPower(Aplus(ii, im), kz, w, par.rho0, normM);
        Pminus(ii, im) = modalPower(Aminus(ii, im), kz, w, par.rho0, normM);
    end
end

%% Field snapshot near the strongest +1 radiation
[~, idx0] = max(Pplus(:, mList == +1));
fSnap = freq(idx0);
field = computeFieldMap(par, cav, Aplus(idx0, :), Aminus(idx0, :), mList, fSnap);

%% Save results
outDir = fullfile(fileparts(mfilename('fullpath')), 'theory_output');
if ~exist(outDir, 'dir')
    mkdir(outDir);
end

resultTable = table(freq, ...
    Pplus(:, mList == +1), Pplus(:, mList == 0), Pplus(:, mList == -1), ...
    Pminus(:, mList == +1), Pminus(:, mList == 0), Pminus(:, mList == -1), ...
    'VariableNames', {'freq_Hz','P_plus_m1','P_plus_m0','P_plus_mMinus1', ...
    'P_minus_m1','P_minus_m0','P_minus_mMinus1'});
writetable(resultTable, fullfile(outDir, 'theory_ab_bilayer_modal_power.csv'));

plotModalPowers(freq, Pplus, Pminus, mList, outDir);
plotFieldSnapshot(field, fSnap, outDir);
if exist(dataFile, 'file') && size(raw, 2) >= 7
    compareWithOutput(freq, Pplus, Pminus, mList, raw, outDir);
end

fprintf('Theoretical radiation calculation finished.\n');
fprintf('Main outputs:\n');
fprintf('  %s\n', fullfile(outDir, 'theory_ab_bilayer_modal_power.csv'));
fprintf('  %s\n', fullfile(outDir, 'theory_ab_bilayer_modal_power.png'));
fprintf('  %s\n', fullfile(outDir, 'theory_ab_bilayer_field_snapshot.png'));

%% Local functions
function cav = buildCavities(par, geo)
    baseA = [geo.phiA1, geo.phiA1 + pi];
    baseB = [geo.phiA1 + geo.deltaPhiAB, geo.phiA1 + geo.deltaPhiAB + pi];

    cav = struct('name', {}, 'type', {}, 'phi', {}, 'z', {}, 'rOut', {}, ...
        'beta', {}, 'Lz', {}, 'V', {}, 'S', {}, 'leff', {}, 'omega0', {});

    % Layer 1: original AB plus 180-degree rotated AB.
    for k = 1:2
        cav(end+1) = makeCavity(sprintf('A1_%d', k), 'A', baseA(k), geo.zA1, geo.rA, geo.betaA, geo.LA); %#ok<AGROW>
        cav(end+1) = makeCavity(sprintf('B1_%d', k), 'B', baseB(k), geo.zB1, geo.rB, geo.betaB, geo.LB); %#ok<AGROW>
    end

    % Layer 2: mirror about xy plane, then rotate around z by 10 degrees.
    for k = 1:2
        cav(end+1) = makeCavity(sprintf('A2_%d', k), 'A', baseA(k) + geo.twist, -geo.zA1, geo.rA, geo.betaA, geo.LA); %#ok<AGROW>
        cav(end+1) = makeCavity(sprintf('B2_%d', k), 'B', baseB(k) + geo.twist, -geo.zB1, geo.rB, geo.betaB, geo.LB); %#ok<AGROW>
    end

    % Keep angles in [0, 2*pi).
    for j = 1:numel(cav)
        cav(j).phi = mod(cav(j).phi, 2*pi);
        cav(j).rw = par.R0 + 0.5*cav(j).rOut; %#ok<STRNU>
    end
end

function c = makeCavity(name, type, phi, z, rOut, beta, Lz)
    c.name = name;
    c.type = type;
    c.phi = phi;
    c.z = z;
    c.rOut = rOut;
    c.beta = beta;
    c.Lz = Lz;
    c.V = NaN;
    c.S = NaN;
    c.leff = NaN;
    c.omega0 = NaN;
end

function radialModes = buildRadialModes(cav, src, model, par)
    Nm = numel(cav)*model.numRadialOrders;
    radialModes = struct('cavity', cell(Nm, 1), 'order', cell(Nm, 1), ...
        'omega0', cell(Nm, 1), 'gamma', cell(Nm, 1), 'sourceWeight', cell(Nm, 1), ...
        'apertureWeight', cell(Nm, 1));

    q = 0;
    for j = 1:numel(cav)
        if cav(j).type == "A"
            lossFrac = model.lossFracA;
        else
            lossFrac = model.lossFracB;
        end

        if j == src.cavityIndex
            xSrc = (src.r - par.R0)/cav(j).rOut;
            xSrc = min(max(xSrc, 0), 1);
        else
            xSrc = 0.5;
        end

        for n = 0:model.numRadialOrders-1
            q = q + 1;
            radialWavenumber = n*pi/max(cav(j).rOut, 1e-6);
            omegaN = sqrt(cav(j).omega0^2 + (model.radialDispersion*par.c0*radialWavenumber)^2);
            radialModes(q).cavity = j;
            radialModes(q).order = n;
            radialModes(q).omega0 = omegaN;
            radialModes(q).gamma = lossFrac*omegaN;
            radialModes(q).sourceWeight = cos(n*pi*xSrc)/sqrt(1+n);
            radialModes(q).apertureWeight = 1/sqrt(1+n); % psi_n(r=R0), normalized
        end
    end
end

function a = solveRadialModeAmplitudes(radialModes, cav, src, w, model)
    N = numel(radialModes);
    H = zeros(N, N);
    b = zeros(N, 1);

    for p = 1:N
        H(p, p) = radialModes(p).omega0^2 - w^2 - 1i*w*radialModes(p).gamma;
        if radialModes(p).cavity == src.cavityIndex
            b(p) = src.strength*radialModes(p).omega0^2*radialModes(p).sourceWeight;
        end
    end

    for p = 1:N
        jp = radialModes(p).cavity;
        np = radialModes(p).order;
        for q = p+1:N
            jq = radialModes(q).cavity;
            nq = radialModes(q).order;
            if jp == jq
                continue;
            end

            dphi = angle(exp(1i*(cav(jp).phi - cav(jq).phi)));
            rMean = 0.5*(cav(jp).rOut + cav(jq).rOut) + 0.5*max(cav(jp).rOut, cav(jq).rOut);
            ds = sqrt((rMean*dphi)^2 + (cav(jp).z - cav(jq).z)^2);
            orderFactor = exp(-abs(np-nq)/model.radialCouplingDecay);
            kappa = model.kappaScale*sqrt(radialModes(p).omega0*radialModes(q).omega0)^2 ...
                * exp(-ds/model.couplingDecay)*orderFactor;
            H(p, q) = -kappa;
            H(q, p) = -kappa;
        end
    end

    a = H\b;
end

function [Ap, Am] = radiateModeFromRadialExpansion(cav, radialModes, a, m, kz, model)
    Ap = 0;
    Am = 0;
    for p = 1:numel(radialModes)
        j = radialModes(p).cavity;
        angularIntegral = cav(j).beta*sincLocal(m*cav(j).beta/2)*exp(-1i*m*cav(j).phi);
        axialIntegralPlus = cav(j).Lz*sincLocal(kz*cav(j).Lz/2)*exp(-1i*kz*cav(j).z);
        axialIntegralMinus = cav(j).Lz*sincLocal(kz*cav(j).Lz/2)*exp(+1i*kz*cav(j).z);
        apertureMap = cav(j).S/(cav(j).beta*cav(j).Lz)*angularIntegral*radialModes(p).apertureWeight;
        q = model.radiationScale*apertureMap*a(p);
        Ap = Ap + q*axialIntegralPlus;
        Am = Am + q*axialIntegralMinus;
    end
end

function y = sincLocal(x)
    if abs(x) < 1e-12
        y = 1;
    else
        y = sin(x)/x;
    end
end

function N = ductModeNorm(R0, m, alpha)
    if alpha == 0
        N = pi*R0^2;
    else
        % Integral of |J_m(alpha r/R)|^2 over circular cross-section.
        r = linspace(0, R0, 800).';
        psi2 = abs(besselj(abs(m), alpha*r/R0)).^2;
        N = 2*pi*trapz(r, psi2.*r);
    end
end

function P = modalPower(A, kz, w, rho0, normM)
    if real(kz) <= 0
        P = 0;
        return;
    end
    P = abs(A).^2*real(kz)*normM/(2*rho0*w);
end

function field = computeFieldMap(par, cav, Ap, Am, mList, f)
    z = linspace(-0.22, 0.22, 360);
    th = linspace(0, 2*pi, 181);
    [ZZ, TT] = meshgrid(z, th);
    p = zeros(size(ZZ));
    w = 2*pi*f;
    k0 = w/par.c0;
    rObs = 0.82*par.R0;
    for im = 1:numel(mList)
        m = mList(im);
        if abs(m) == 0
            alpha = 0;
            radial = 1;
        else
            alpha = 1.841183781;
            radial = besselj(abs(m), alpha*rObs/par.R0);
        end
        kr = alpha/par.R0;
        kz = sqrt(complex(k0^2 - kr^2, 0));
        p = p + radial*exp(1i*m*TT).*(Ap(im).*exp(1i*kz*ZZ) + Am(im).*exp(-1i*kz*ZZ));
    end
    field.z = z;
    field.theta = th;
    field.p = p;
    field.cav = cav;
end

function plotModalPowers(freq, Pplus, Pminus, mList, outDir)
    fig = figure('Color', 'w', 'Position', [120 120 1050 620]);
    tiledlayout(fig, 2, 1, 'TileSpacing', 'compact');

    nexttile; hold on; grid on;
    for im = 1:numel(mList)
        plot(freq, Pplus(:, im), 'LineWidth', 1.5, 'DisplayName', sprintf('+z, m=%+d', mList(im)));
    end
    ylabel('Modal power [arb.]');
    title('Forward radiation');
    legend('Location', 'best');

    nexttile; hold on; grid on;
    for im = 1:numel(mList)
        plot(freq, Pminus(:, im), 'LineWidth', 1.5, 'DisplayName', sprintf('-z, m=%+d', mList(im)));
    end
    xlabel('Frequency [Hz]');
    ylabel('Modal power [arb.]');
    title('Backward radiation');
    legend('Location', 'best');

    exportgraphics(fig, fullfile(outDir, 'theory_ab_bilayer_modal_power.png'), 'Resolution', 220);
end

function plotFieldSnapshot(field, fSnap, outDir)
    fig = figure('Color', 'w', 'Position', [160 120 1050 560]);
    imagesc(field.z, field.theta, real(field.p));
    axis xy;
    colormap(turbo);
    colorbar;
    xlabel('z [m]');
    ylabel('\theta [rad]');
    title(sprintf('Real pressure field on r = 0.82R_0, f = %.2f Hz', fSnap));
    exportgraphics(fig, fullfile(outDir, 'theory_ab_bilayer_field_snapshot.png'), 'Resolution', 220);
end

function compareWithOutput(freq, Pplus, Pminus, mList, raw, outDir)
    comsol = raw(:, 2:7);
    theory = [Pplus(:, mList == +1), Pplus(:, mList == 0), Pplus(:, mList == -1), ...
        Pminus(:, mList == +1), Pminus(:, mList == 0), Pminus(:, mList == -1)];

    % Use one global scale so only the absolute normalization is adjusted.
    scale = sum(comsol(:).*theory(:))/max(sum(theory(:).^2), eps);
    theoryScaled = scale*theory;

    labels = {'+z m=+1','+z m=0','+z m=-1','-z m=+1','-z m=0','-z m=-1'};
    err = zeros(6, 1);
    for k = 1:6
        err(k) = sqrt(mean((theoryScaled(:, k)-comsol(:, k)).^2))/max(rms(comsol(:, k)), eps);
    end

    errTable = table(labels(:), err, 'VariableNames', {'channel','relative_RMSE'});
    writetable(errTable, fullfile(outDir, 'theory_ab_bilayer_vs_output_error.csv'));

    fig = figure('Color', 'w', 'Position', [90 80 1280 780]);
    tiledlayout(fig, 3, 2, 'TileSpacing', 'compact', 'Padding', 'compact');
    for k = 1:6
        nexttile; hold on; grid on;
        plot(freq, comsol(:, k), 'k-', 'LineWidth', 1.6, 'DisplayName', 'COMSOL Output');
        plot(freq, theoryScaled(:, k), 'r--', 'LineWidth', 1.5, 'DisplayName', 'Theory radial mapping');
        title(sprintf('%s, relRMSE=%.3g', labels{k}, err(k)));
        xlabel('Frequency [Hz]');
        ylabel('Power / 1e-4 W');
        legend('Location', 'best');
    end
    exportgraphics(fig, fullfile(outDir, 'theory_ab_bilayer_vs_output.png'), 'Resolution', 220);
end
