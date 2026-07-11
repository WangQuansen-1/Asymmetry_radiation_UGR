function comparison=compare_independent_with_comsol(outputDir)
if nargin<1,outputDir=fullfile(fileparts(mfilename('fullpath')),'output');end
theory=readtable(fullfile(outputDir,'six_channel_fractions.csv'));
reference=readtable(fullfile(fileparts(mfilename('fullpath')),'comsol_reference.csv'));
vars={'frequency_real_Hz','frequency_imag_Hz','Eoz1_fraction','Eoz0_fraction', ...
    'Eoz_1_fraction','Eof1_fraction','Eof0_fraction','Eof_1_fraction'};
comparison=outerjoin(reference,theory,'Keys','case_name','MergeKeys',true, ...
    'LeftVariables',vars,'RightVariables',vars);
for k=1:numel(vars)
    comparison.([vars{k} '_error'])=comparison.([vars{k} '_theory'])-comparison.([vars{k} '_reference']);
end
writetable(comparison,fullfile(outputDir,'comparison_error.csv'));
disp(comparison);
end

