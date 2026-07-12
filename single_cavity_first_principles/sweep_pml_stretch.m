function summary=sweep_pml_stretch(varargin)
%SWEEP_PML_STRETCH Audit finite-PML stretch against all COMSOL no-loss roots.

here=fileparts(mfilename('fullpath'));
ip=inputParser;
ip.addParameter('ImaginaryScale',[0.7 0.85 1.0 1.15 1.3 1.5]);
ip.addParameter('ReferenceFile',fullfile(here,'comsol_no_loss_reproducible_sorted.csv'));
ip.addParameter('OutputDir',fullfile(here,'output_pml_stretch_sweep'));
ip.parse(varargin{:});opt=ip.Results;
if ~exist(opt.OutputDir,'dir'),mkdir(opt.OutputDir);end
R=readtable(opt.ReferenceFile,'VariableNamingRule','preserve');

ns=numel(opt.ImaginaryScale);rows=zeros(ns,9);
for k=1:ns
    scale=opt.ImaginaryScale(k);
    cfg=single_cavity_parameters;cfg.femOrder=1;cfg.useFinitePML=true;
    cfg.useThermoviscous=false;cfg.pmlStretch=3*(1-1i*scale);
    sys=build_acoustic_fem(cfg);
    spectrum=solve_all_eigenmodes(sys,'FrequencyRange',[900 2100], ...
        'ShiftFrequency',1500+100i,'NumCandidates',220);
    M=spectrum.table;
    rr=abs(R.frequency_real_Hz-M.frequency_real_Hz.')./max(abs(R.frequency_real_Hz),eps);
    ri=abs(R.frequency_imag_Hz-M.frequency_imag_Hz.')./max(abs(R.frequency_imag_Hz),1);
    cost=rr+ri;cost(rr>0.10)=cost(rr>0.10)+1e3;
    pairs=sortrows(matchpairs(cost,1e6,'min'),1);
    er=rr(sub2ind(size(rr),pairs(:,1),pairs(:,2)));
    ei=ri(sub2ind(size(ri),pairs(:,1),pairs(:,2)));
    pass=er<=0.10 & ei<=0.10;
    rows(k,:)=[scale,height(M),nnz(pass),max(er),median(er),max(ei),median(ei), ...
        sqrt(mean(er.^2)),sqrt(mean(ei.^2))];
    writetable(M,fullfile(opt.OutputDir,sprintf('spectrum_imag_scale_%0.3f.csv',scale)));
    runDir=fullfile(opt.OutputDir,sprintf('imag_scale_%0.3f',scale));
    [~,gateSummary]=validate_no_loss_gate('ReferenceFile',opt.ReferenceFile, ...
        'TheoryFile',fullfile(opt.OutputDir,sprintf('spectrum_imag_scale_%0.3f.csv',scale)), ...
        'OutputDir',runDir,'RealTolerance',0.10,'ImagTolerance',0.10,'MakePlot',true);
    rows(k,3)=gateSummary.passed_mode_count;
    fprintf('PML imag scale %.3f: pass=%d/60, max real=%.2f%%, max imag=%.2f%%\n', ...
        scale,nnz(pass),100*max(er),100*max(ei));
end
summary=array2table(rows,'VariableNames',{'pml_imaginary_scale','candidate_count', ...
    'both_within_10pct','max_real_relative_error','median_real_relative_error', ...
    'max_imag_relative_error','median_imag_relative_error', ...
    'rms_real_relative_error','rms_imag_relative_error'});
writetable(summary,fullfile(opt.OutputDir,'pml_stretch_sweep_summary.csv'));
end
