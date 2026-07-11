function comparison = compare_with_comsol(varargin)
%COMPARE_WITH_COMSOL Compare completed independent theory with COMSOL.
% This function is deliberately separate from run_first_principles_model.
% COMSOL data are never passed back into the theoretical calculation.

    here = fileparts(mfilename('fullpath'));
    ip = inputParser;
    ip.addParameter('TheoryFile',fullfile(here,'output','first_principles_results.csv'));
    ip.addParameter('ComsolFile',fullfile(fileparts(here), ...
        'prototype_theory_fit','output','comsol_reference.csv'));
    ip.addParameter('OutputDir',fullfile(here,'comparison_output'));
    ip.parse(varargin{:});
    cfg = ip.Results;
    if ~isfolder(cfg.OutputDir),mkdir(cfg.OutputDir);end

    theory=readtable(cfg.TheoryFile);
    comsol=readtable(cfg.ComsolFile);
    theory=sortrows(theory,'freq_Hz');
    comsol=sortrows(comsol,'freq_Hz');
    if ~isequal(theory.freq_Hz,comsol.freq_Hz)
        error('Theory and COMSOL frequency grids do not match.');
    end

    quantities={'Ez1','Ez0','Ez_1','Ef1','Ef0','Ef_1', ...
        'Forward','Backward','F1','B1'};
    rows=zeros(numel(quantities),6);
    for i=1:numel(quantities)
        y=comsol.(quantities{i}); yh=theory.(quantities{i}); e=yh-y;
        rmse=sqrt(mean(e.^2));
        relative=rmse/max(sqrt(mean(y.^2)),eps);
        peakShift=theory.freq_Hz(argmax(yh))-comsol.freq_Hz(argmax(y));
        rows(i,:)=[rmse,relative,max(abs(e)),mean(abs(e)), ...
            safe_correlation(y,yh),peakShift];
    end
    E=array2table(rows,'VariableNames',{'RMSE','RelativeRMSE','MaxAbsError', ...
        'MeanAbsError','Correlation','PeakFrequencyShift_Hz'});
    E.Quantity=string(quantities(:)); E=movevars(E,'Quantity','Before',1);
    writetable(E,fullfile(cfg.OutputDir,'first_principles_error.csv'));
    make_comparison_plots(theory,comsol,cfg.OutputDir);

    comparison=struct('theory',theory,'comsol',comsol,'errors',E);
    fprintf('\nIndependent-theory comparison:\n');
    disp(E);
end

function i=argmax(x)
    [~,i]=max(x);
end

function r=safe_correlation(a,b)
    a=a-mean(a);b=b-mean(b);
    r=real((a'*b)/max(sqrt((a'*a)*(b'*b)),eps));
end

function make_comparison_plots(T,C,outDir)
    names={'Ez1','Ez0','Ez_1','Ef1','Ef0','Ef_1'};
    labels={'lower target','lower m=0','lower opposite', ...
        'upper target','upper m=0','upper opposite'};
    fig=figure('Color','w','Position',[50 50 1320 760]);
    tiledlayout(2,3,'Padding','compact','TileSpacing','compact');
    for i=1:6
        nexttile;hold on;grid on;box on;
        plot(C.freq_Hz,C.(names{i}),'ko','MarkerSize',3.2,'DisplayName','COMSOL');
        plot(T.freq_Hz,T.(names{i}),'r-','LineWidth',1.8,'DisplayName','Independent theory');
        title(labels{i});xlabel('Frequency (Hz)');ylabel('Power (W)');
        if i==1,legend('Location','best');end
    end
    exportgraphics(fig,fullfile(outDir,'six_channel_independent_comparison.png'),'Resolution',230);
    close(fig);

    fig=figure('Color','w','Position',[80 80 1120 470]);
    tiledlayout(1,2,'Padding','compact','TileSpacing','compact');
    nexttile;hold on;grid on;box on;
    plot(C.freq_Hz,C.Forward,'ko','MarkerSize',3.2,'DisplayName','Forward COMSOL');
    plot(C.freq_Hz,C.Backward,'bs','MarkerSize',3.2,'DisplayName','Backward COMSOL');
    plot(T.freq_Hz,T.Forward,'k-','LineWidth',1.8,'DisplayName','Forward theory');
    plot(T.freq_Hz,T.Backward,'b-','LineWidth',1.8,'DisplayName','Backward theory');
    xlabel('Frequency (Hz)');ylabel('Target-mode fraction');legend('Location','best');
    nexttile;hold on;grid on;box on;
    plot(C.freq_Hz,C.F1,'ko','MarkerSize',3.2,'DisplayName','F1 COMSOL');
    plot(C.freq_Hz,C.B1,'bs','MarkerSize',3.2,'DisplayName','B1 COMSOL');
    plot(T.freq_Hz,T.F1,'k-','LineWidth',1.8,'DisplayName','F1 theory');
    plot(T.freq_Hz,T.B1,'b-','LineWidth',1.8,'DisplayName','B1 theory');
    xlabel('Frequency (Hz)');ylabel('Power enhancement');legend('Location','best');
    exportgraphics(fig,fullfile(outDir,'FB_F1B1_independent_comparison.png'),'Resolution',230);
    close(fig);
end
