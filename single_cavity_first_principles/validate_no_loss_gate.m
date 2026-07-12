function [T,S,passed]=validate_no_loss_gate(varargin)
%VALIDATE_NO_LOSS_GATE Require every complex no-loss frequency to pass.

here=fileparts(mfilename('fullpath'));
ip=inputParser;
ip.addParameter('ReferenceFile',fullfile(here,'comsol_no_loss_reproducible_sorted.csv'));
ip.addParameter('TheoryFile',fullfile(here,'matlab_p1_pml_refine2_noloss.csv'));
ip.addParameter('RealTolerance',0.10);
ip.addParameter('ImagTolerance',0.10);
ip.addParameter('ImaginaryFloorHz',1.0);
ip.addParameter('OutputDir',fullfile(here,'output_no_loss_complex_gate'));
ip.addParameter('MakePlot',true,@islogical);
ip.parse(varargin{:});opt=ip.Results;
R=readtable(opt.ReferenceFile,'VariableNamingRule','preserve');
M=readtable(opt.TheoryFile,'VariableNamingRule','preserve');

er=abs(R.frequency_real_Hz-M.frequency_real_Hz.')./max(abs(R.frequency_real_Hz),eps);
ei=abs(R.frequency_imag_Hz-M.frequency_imag_Hz.')./ ...
    max(abs(R.frequency_imag_Hz),opt.ImaginaryFloorHz);
valid=er<=opt.RealTolerance & ei<=opt.ImagTolerance;
cost=er+ei+1e3*(~valid);
[pairs,unmatchedRows]=matchpairs(cost,1e6,'min');

n=height(R);theoryRow=nan(n,1);pass=false(n,1);
for k=1:size(pairs,1)
    i=pairs(k,1);j=pairs(k,2);
    theoryRow(i)=j;pass(i)=valid(i,j);
end
T=table(R.comsol_index,R.frequency_real_Hz,R.frequency_imag_Hz,R.Forward,R.Backward, ...
    theoryRow,nan(n,1),nan(n,1),nan(n,1),nan(n,1),nan(n,1),nan(n,1),pass, ...
    'VariableNames',{'comsol_index','comsol_real_Hz','comsol_imag_Hz', ...
    'comsol_Forward','comsol_Backward','matlab_row','matlab_real_Hz', ...
    'matlab_imag_Hz','matlab_Forward','matlab_Backward','real_relative_error', ...
    'imag_relative_error','complex_frequency_pass'});
q=(1:n).';j=theoryRow(q);
T.matlab_real_Hz(q)=M.frequency_real_Hz(j);
T.matlab_imag_Hz(q)=M.frequency_imag_Hz(j);
T.matlab_Forward(q)=M.Eoz1_fraction(j);
T.matlab_Backward(q)=M.Eof1_fraction(j);
T.real_relative_error(q)=er(sub2ind(size(er),q,j));
T.imag_relative_error(q)=ei(sub2ind(size(ei),q,j));
passed=all(pass) && isempty(unmatchedRows);
S=table(n,nnz(pass),n-nnz(pass),opt.RealTolerance,opt.ImagTolerance,passed, ...
    'VariableNames',{'mode_count','passed_mode_count','failed_mode_count', ...
    'real_tolerance','imag_tolerance','all_modes_passed'});
if ~exist(opt.OutputDir,'dir'),mkdir(opt.OutputDir);end
writetable(T,fullfile(opt.OutputDir,'no_loss_complex_frequency_gate.csv'));
writetable(S,fullfile(opt.OutputDir,'no_loss_complex_frequency_gate_summary.csv'));
if opt.MakePlot
    plot_comsol_matlab_modes(T,fullfile(opt.OutputDir,'no_loss_comsol_matlab'), ...
        'Title','No-loss eigenmodes: COMSOL vs MATLAB', ...
        'RealTolerance',opt.RealTolerance,'ImagTolerance',opt.ImagTolerance);
end
fprintf('No-loss complex-frequency gate: %d/%d modes passed; all passed=%d\n', ...
    nnz(pass),n,passed);
end
