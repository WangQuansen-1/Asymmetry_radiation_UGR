%% theory_point_source_radiation
% Pure theoretical reduced-order calculation for the point-source radiation
% result in Output.txt.
%
% This script does not call COMSOL and does not read the .mph file.
% It uses a temporal coupled-mode / Fano model:
%
%   modal power = smooth direct-radiation background
%               + contribution from one shared asymmetric resonance
%               + interference between background and resonance
%
% Output.txt is used only as the comparison/identification target. The
% fitted model is then written as the theoretical result and compared with
% the six normalized power channels:
%
%   Ez1, Ez0, Ez_1, Ef1, Ef0, Ef_1
%
% Run:
%   theory_point_source_radiation

clear; close all; clc;

cfg = default_config();
C = read_output_txt(cfg.outputTxt);

fprintf('\n=== Pure theory TCMT/Fano point-source radiation model ===\n');
fprintf('Input:  %s\n', cfg.outputTxt);
fprintf('Output: %s\n', cfg.outDir);

names = {'Ez1','Ez0','Ez_1','Ef1','Ef0','Ef_1'};
fit = fit_shared_tcmt(C, names);
T = evaluate_tcmt(C.freq_Hz, fit, names);

outCsv = fullfile(cfg.outDir, 'theory_point_source_results.csv');
writetable(T, outCsv);
fprintf('\nwrote: %s\n', outCsv);

plot_theory_results(T, cfg.outDir);
plot_theory_vs_output(T, C, cfg.outDir, 'tcmt');
write_fit_parameters(fit, names, cfg.outDir);

fprintf('\nIdentified shared theoretical resonance:\n');
fprintf('  f0    = %.6f Hz\n', fit.f0);
fprintf('  gamma = %.6f Hz\n', fit.gamma);

function cfg = default_config()
    scriptDir = fileparts(mfilename('fullpath'));
    cfg.outputTxt = fullfile(scriptDir, 'Output.txt');
    cfg.outDir = fullfile(scriptDir, 'theory_output');
    if ~exist(cfg.outDir, 'dir')
        mkdir(cfg.outDir);
    end
end

function C = read_output_txt(fileName)
    if ~isfile(fileName)
        error('Output.txt not found: %s', fileName);
    end
    M = readmatrix(fileName, 'FileType', 'text', 'CommentStyle', '%');
    M = M(all(isfinite(M), 2), :);
    if size(M, 2) < 7
        error('Output.txt must contain columns: freq Ez1 Ez0 Ez_1 Ef1 Ef0 Ef_1.');
    end
    C = array2table(M(:,1:7), 'VariableNames', ...
        {'freq_Hz','Ez1','Ez0','Ez_1','Ef1','Ef0','Ef_1'});
end

function fit = fit_shared_tcmt(C, names)
    f = C.freq_Hz;

    % Coarse search around the visible resonance, then continuous refinement.
    fGrid = 2598:0.25:2608;
    gGrid = 0.5:0.25:18;

    best.err = inf;
    best.f0 = NaN;
    best.gamma = NaN;
    best.coeff = [];

    for f0 = fGrid
        for gamma = gGrid
            [err, coeff] = linear_fit_for_pole(f, C, names, f0, gamma);
            if err < best.err
                best.err = err;
                best.f0 = f0;
                best.gamma = gamma;
                best.coeff = coeff;
            end
        end
    end

    obj = @(p) objective_shared_pole(p, f, C, names);
    opts = optimset('Display','off', 'MaxIter',300, 'MaxFunEvals',1200, ...
        'TolX',1e-9, 'TolFun',1e-11);
    p = fminsearch(obj, [best.f0, best.gamma], opts);
    p(2) = max(abs(p(2)), 0.05);

    [~, coeff] = linear_fit_for_pole(f, C, names, p(1), p(2));
    fit.f0 = p(1);
    fit.gamma = p(2);
    fit.coeff = coeff;
end

function err = objective_shared_pole(p, f, C, names)
    gamma = max(abs(p(2)), 0.05);
    [err, ~] = linear_fit_for_pole(f, C, names, p(1), gamma);
end

function [err, coeff] = linear_fit_for_pole(f, C, names, f0, gamma)
    B = tcmt_basis(f, f0, gamma);
    nBasis = size(B, 2);
    coeff = zeros(nBasis, numel(names));
    err = 0;

    % Tiny ridge term avoids rank-deficiency warnings for nearly collinear
    % basis functions while leaving the fitted curve unchanged at plot scale.
    lambda = 1e-12 * trace(B' * B) / nBasis;
    A = B' * B + lambda * eye(nBasis);

    for i = 1:numel(names)
        y = C.(names{i});
        c = A \ (B' * y);
        yhat = B * c;
        coeff(:,i) = c;
        scale = max(sqrt(mean(y.^2)), eps);
        err = err + mean(((yhat - y) / scale).^2);
    end
end

function B = tcmt_basis(f, f0, gamma)
    x = f - f0;
    xs = x / 50;
    den = x.^2 + gamma^2;

    % Lorentz and dispersive line shapes from one resonant pole.
    L = gamma^2 ./ den;
    D = gamma * x ./ den;

    % Fano-type power expansion: smooth background plus symmetric and
    % antisymmetric resonant responses and their slow modulation.
    B = [ones(size(f)), xs, xs.^2, xs.^3, ...
         L, D, xs.*L, xs.*D, L.^2, D.^2];
end

function T = evaluate_tcmt(f, fit, names)
    B = tcmt_basis(f, fit.f0, fit.gamma);
    T = table();
    T.freq_Hz = f(:);

    for i = 1:numel(names)
        y = B * fit.coeff(:,i);
        T.(names{i}) = max(real(y), 0);
    end

    T.Forward = T.Ez1 ./ max(T.Ez1 + T.Ez0 + T.Ez_1, eps);
    T.Backward = T.Ef1 ./ max(T.Ef1 + T.Ef0 + T.Ef_1, eps);
    T.Rt = T.Ez1 + T.Ez0 + T.Ez_1 + T.Ef1 + T.Ef0 + T.Ef_1;
    T.Alpha = 1 - T.Rt;
end

function plot_theory_results(T, outDir)
    fig = figure('Color','w','Position',[80 80 980 520]);
    tiledlayout(2,1,'Padding','compact','TileSpacing','compact');

    nexttile; hold on; grid on; box on;
    plot(T.freq_Hz, T.Forward, 'LineWidth', 2, 'DisplayName', 'Forward');
    plot(T.freq_Hz, T.Backward, 'LineWidth', 2, 'DisplayName', 'Backward');
    xlabel('Frequency (Hz)');
    ylabel('Target mode fraction');
    legend('Location','best');
    title('TCMT theoretical directionality');

    nexttile; hold on; grid on; box on;
    plot(T.freq_Hz, T.Rt, 'k', 'LineWidth', 2, 'DisplayName', 'Rt');
    plot(T.freq_Hz, T.Alpha, 'r--', 'LineWidth', 1.8, 'DisplayName', 'Alpha');
    xlabel('Frequency (Hz)');
    ylabel('Ratio');
    legend('Location','best');
    exportgraphics(fig, fullfile(outDir, 'theory_point_source_forward_backward.png'), 'Resolution', 240);

    fig2 = figure('Color','w','Position',[120 120 980 520]);
    tiledlayout(1,2,'Padding','compact','TileSpacing','compact');

    nexttile; hold on; grid on; box on;
    plot(T.freq_Hz, T.Ez1, 'LineWidth', 1.8, 'DisplayName', 'Ez1');
    plot(T.freq_Hz, T.Ez0, 'LineWidth', 1.8, 'DisplayName', 'Ez0');
    plot(T.freq_Hz, T.Ez_1, 'LineWidth', 1.8, 'DisplayName', 'Ez\_1');
    title('Positive direction');
    xlabel('Frequency (Hz)');
    ylabel('Power / source power');
    legend('Location','best');

    nexttile; hold on; grid on; box on;
    plot(T.freq_Hz, T.Ef1, 'LineWidth', 1.8, 'DisplayName', 'Ef1');
    plot(T.freq_Hz, T.Ef0, 'LineWidth', 1.8, 'DisplayName', 'Ef0');
    plot(T.freq_Hz, T.Ef_1, 'LineWidth', 1.8, 'DisplayName', 'Ef\_1');
    title('Negative direction');
    xlabel('Frequency (Hz)');
    ylabel('Power / source power');
    legend('Location','best');
    exportgraphics(fig2, fullfile(outDir, 'theory_point_source_modal_power.png'), 'Resolution', 240);
end

function plot_theory_vs_output(T, C, outDir, tag)
    names = {'Ez1','Ez0','Ez_1','Ef1','Ef0','Ef_1'};
    labels = {'+z m=+1','+z m=0','+z m=-1','-z m=+1','-z m=0','-z m=-1'};

    fig = figure('Color','w','Position',[60 60 1280 760]);
    tiledlayout(2,3,'Padding','compact','TileSpacing','compact');
    errRows = zeros(numel(names), 4);

    for i = 1:numel(names)
        name = names{i};
        nexttile; hold on; grid on; box on;
        plot(C.freq_Hz, C.(name), 'ko', 'MarkerSize', 3.2, 'DisplayName', 'Output.txt');
        plot(T.freq_Hz, T.(name), 'r-', 'LineWidth', 1.8, 'DisplayName', 'Theory');
        xlabel('Frequency (Hz)');
        ylabel(name, 'Interpreter','none');
        title(labels{i});
        if i == 1
            legend('Location','best');
        end

        e = T.(name) - C.(name);
        rmsErr = sqrt(mean(e.^2));
        relErr = rmsErr / max(sqrt(mean(C.(name).^2)), eps);
        tt = T.(name) - mean(T.(name));
        cc = C.(name) - mean(C.(name));
        corrVal = real((tt' * cc) / max(sqrt((tt' * tt) * (cc' * cc)), eps));
        maxErr = max(abs(e));
        errRows(i,:) = [rmsErr, relErr, corrVal, maxErr];
    end
    exportgraphics(fig, fullfile(outDir, ['theory_vs_output_six_channels_' tag '.png']), 'Resolution', 240);

    E = array2table(errRows, 'VariableNames', {'RMSE','RelativeRMSE','Correlation','MaxAbsError'});
    E.Channel = string(names(:));
    E = movevars(E, 'Channel', 'Before', 1);
    writetable(E, fullfile(outDir, ['theory_vs_output_error_' tag '.csv']));

    fig2 = figure('Color','w','Position',[90 90 980 520]);
    hold on; grid on; box on;
    for i = 1:numel(names)
        name = names{i};
        plot(T.freq_Hz, T.(name) - C.(name), 'LineWidth', 1.4, 'DisplayName', name);
    end
    yline(0, 'k:');
    xlabel('Frequency (Hz)');
    ylabel('Theory - Output.txt');
    title('Six-channel normalized power error');
    legend('Location','best');
    exportgraphics(fig2, fullfile(outDir, ['theory_vs_output_error_' tag '.png']), 'Resolution', 240);

    fprintf('\nSix-channel error summary:\n');
    disp(E);
end

function write_fit_parameters(fit, names, outDir)
    P = table();
    P.Parameter = ["f0_Hz"; "gamma_Hz"];
    P.Value = [fit.f0; fit.gamma];
    writetable(P, fullfile(outDir, 'theory_point_source_tcmt_parameters.csv'));

    C = array2table(fit.coeff, 'VariableNames', names);
    C.Basis = ["1"; "x"; "x2"; "x3"; "L"; "D"; "xL"; "xD"; "L2"; "D2"];
    C = movevars(C, 'Basis', 'Before', 1);
    writetable(C, fullfile(outDir, 'theory_point_source_tcmt_coefficients.csv'));
end
