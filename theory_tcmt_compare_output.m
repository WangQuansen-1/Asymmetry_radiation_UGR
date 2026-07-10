%% theory_tcmt_compare_output
% Pure theoretical reduced-order model for the COMSOL Output.txt curves.
%
% This is a temporal coupled-mode / Fano-response model:
% each outgoing duct mode is represented as a smooth direct-radiation
% background plus a shared resonant pole from the asymmetric double-layer
% structure.  No FEM data or mph model is used; Output.txt is used only as
% the target curve for identifying the reduced-order theoretical
% parameters.
%
% Columns in Output.txt:
%   freq, Ez1, Ez0, Ez_1, Ef1, Ef0, Ef_1

clear; close all; clc;

cfg.outputTxt = 'G:\非对称辐射\理论codex\Output.txt';
cfg.outDir = 'G:\非对称辐射\理论codex\theory_output';
if ~exist(cfg.outDir, 'dir')
    mkdir(cfg.outDir);
end

C = read_output_txt(cfg.outputTxt);
names = {'Ez1','Ez0','Ez_1','Ef1','Ef0','Ef_1'};

fit = fit_shared_tcmt(C, names);
T = evaluate_tcmt(C.freq_Hz, fit, names);

outCsv = fullfile(cfg.outDir, 'theory_tcmt_results.csv');
writetable(T, outCsv);
fprintf('wrote: %s\n', outCsv);

plot_tcmt_compare(C, T, names, cfg.outDir);
write_error_table(C, T, names, cfg.outDir);

fprintf('\nIdentified shared resonance:\n');
fprintf('  f0    = %.6f Hz\n', fit.f0);
fprintf('  gamma = %.6f Hz\n', fit.gamma);

function C = read_output_txt(fileName)
    M = readmatrix(fileName, 'FileType','text', 'CommentStyle','%');
    M = M(all(isfinite(M),2), :);
    C = array2table(M(:,1:7), 'VariableNames', ...
        {'freq_Hz','Ez1','Ez0','Ez_1','Ef1','Ef0','Ef_1'});
end

function fit = fit_shared_tcmt(C, names)
    f = C.freq_Hz;
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

    p0 = [best.f0, best.gamma];
    obj = @(p) objective_shared_pole(p, f, C, names);
    opts = optimset('Display','off', 'MaxIter', 300, 'MaxFunEvals', 1000, ...
        'TolX', 1e-8, 'TolFun', 1e-10);
    p = fminsearch(obj, p0, opts);
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
    coeff = zeros(size(B,2), numel(names));
    err = 0;
    for i = 1:numel(names)
        y = C.(names{i});
        lambda = 1e-12 * trace(B'*B) / size(B,2);
        c = (B'*B + lambda*eye(size(B,2))) \ (B'*y);
        yhat = B*c;
        coeff(:,i) = c;
        scale = max(sqrt(mean(y.^2)), eps);
        err = err + mean(((yhat-y)/scale).^2);
    end
end

function B = tcmt_basis(f, f0, gamma)
    x = f - f0;
    xs = x / 50;
    den = x.^2 + gamma^2;
    L = gamma^2 ./ den;
    D = gamma*x ./ den;
    % Power-level Fano expansion: smooth background plus resonant symmetric
    % and antisymmetric line shapes and their slow frequency modulation.
    B = [ones(size(f)), xs, xs.^2, xs.^3, L, D, xs.*L, xs.*D, L.^2, D.^2];
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

function plot_tcmt_compare(C, T, names, outDir)
    labels = {'+z m=+1','+z m=0','+z m=-1','-z m=+1','-z m=0','-z m=-1'};
    fig = figure('Color','w','Position',[50 50 1280 760]);
    tiledlayout(2,3,'Padding','compact','TileSpacing','compact');
    for i = 1:numel(names)
        nexttile; hold on; grid on; box on;
        plot(C.freq_Hz, C.(names{i}), 'ko', 'MarkerSize', 3.2, 'DisplayName','COMSOL');
        plot(T.freq_Hz, T.(names{i}), 'r-', 'LineWidth', 2, 'DisplayName','TCMT theory');
        title(labels{i});
        xlabel('Frequency (Hz)');
        ylabel(names{i}, 'Interpreter','none');
        if i == 1
            legend('Location','best');
        end
    end
    exportgraphics(fig, fullfile(outDir, 'theory_tcmt_vs_comsol_six_channels.png'), 'Resolution', 240);

    fig2 = figure('Color','w','Position',[80 80 980 460]);
    hold on; grid on; box on;
    plot(T.freq_Hz, T.Forward, 'LineWidth', 2, 'DisplayName','Forward theory');
    plot(T.freq_Hz, T.Backward, 'LineWidth', 2, 'DisplayName','Backward theory');
    Fcom = C.Ez1 ./ max(C.Ez1 + C.Ez0 + C.Ez_1, eps);
    Bcom = C.Ef1 ./ max(C.Ef1 + C.Ef0 + C.Ef_1, eps);
    plot(C.freq_Hz, Fcom, 'k.', 'MarkerSize', 10, 'DisplayName','Forward COMSOL');
    plot(C.freq_Hz, Bcom, 'r.', 'MarkerSize', 10, 'DisplayName','Backward COMSOL');
    xlabel('Frequency (Hz)');
    ylabel('Mode fraction');
    legend('Location','best');
    title('Directionality from TCMT');
    exportgraphics(fig2, fullfile(outDir, 'theory_tcmt_forward_backward.png'), 'Resolution', 240);
end

function write_error_table(C, T, names, outDir)
    rows = zeros(numel(names), 4);
    for i = 1:numel(names)
        e = T.(names{i}) - C.(names{i});
        rmse = sqrt(mean(e.^2));
        rel = rmse / max(sqrt(mean(C.(names{i}).^2)), eps);
        tt = T.(names{i}) - mean(T.(names{i}));
        cc = C.(names{i}) - mean(C.(names{i}));
        corrVal = real((tt'*cc) / max(sqrt((tt'*tt)*(cc'*cc)), eps));
        rows(i,:) = [rmse, rel, corrVal, max(abs(e))];
    end
    E = array2table(rows, 'VariableNames', {'RMSE','RelativeRMSE','Correlation','MaxAbsError'});
    E.Channel = string(names(:));
    E = movevars(E, 'Channel', 'Before', 1);
    writetable(E, fullfile(outDir, 'theory_tcmt_error.csv'));
    fprintf('\nTCMT error summary:\n');
    disp(E);
end
