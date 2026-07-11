function T=run_order_convergence()
%RUN_ORDER_CONVERGENCE Compare P1 and P2 without changing physical inputs.
cfg=single_cavity_parameters('quick');
rows=zeros(2,10);
for order=1:2
    cfg.femOrder=order;
    sys=build_acoustic_fem(cfg);
    e=solve_open_eigenmodes(sys);
    r=solve_point_source_radiation(sys,cfg.driveFrequency);
    rows(order,:)=[real(e.targetFrequency),imag(e.targetFrequency), ...
        e.targetChannels.lowerFraction(1),e.targetChannels.upperFraction(1), ...
        r.channels.lowerFraction,r.channels.upperFraction];
end
T=array2table(rows,'RowNames',{'P1','P2'},'VariableNames', ...
    {'eigen_real_Hz','eigen_imag_Hz','eigen_Eoz1','eigen_Eof1', ...
    'rad_Eoz1','rad_Eoz0','rad_Eoz_1','rad_Eof1','rad_Eof0','rad_Eof_1'});
out=fullfile(fileparts(mfilename('fullpath')),'output');if ~isfolder(out),mkdir(out);end
writetable(T,fullfile(out,'order_convergence.csv'),'WriteRowNames',true);
disp(T);
end
