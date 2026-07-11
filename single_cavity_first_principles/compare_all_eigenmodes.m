function result=compare_all_eigenmodes(varargin)
%COMPARE_ALL_EIGENMODES One-to-one comparison of the full saved spectrum.

here=fileparts(mfilename('fullpath'));
ip=inputParser;
ip.addParameter('ReferenceFile',fullfile(here,'comsol_all_eigenmodes.csv'));
ip.addParameter('PMLFile',fullfile(here,'comsol_pml_participation.csv'));
ip.addParameter('PMLThreshold',0.30);
ip.addParameter('OutputDir',fullfile(here,'output_all_modes'));
ip.addParameter('NumCandidates',28);
ip.addParameter('ShiftFrequency',[1300+120i,1500+110i,1650+100i,1700+1i,1800+35i]);
ip.addParameter('ReuseTheory',false,@islogical);
ip.parse(varargin{:});opt=ip.Results;
if ~isfolder(opt.OutputDir),mkdir(opt.OutputDir);end

reference=readtable(opt.ReferenceFile,'VariableNamingRule','preserve');
pml=readtable(opt.PMLFile,'VariableNamingRule','preserve');
[ok,loc]=ismember(reference.comsol_index,pml.comsol_index);
if ~all(ok),error('PML participation table does not cover all COMSOL modes.');end
reference.pml_fraction=pml.pml_fraction(loc);
physical=reference(reference.pml_fraction<opt.PMLThreshold,:);
fRange=[min(reference.frequency_real_Hz)-30,max(reference.frequency_real_Hz)+30];
theoryFile=fullfile(opt.OutputDir,'matlab_all_eigenmodes.csv');
if opt.ReuseTheory && isfile(theoryFile)
    theory=readtable(theoryFile,'VariableNamingRule','preserve');
    spectrum=struct('table',theory,'reused',true);
else
    cfg=single_cavity_parameters;sys=build_acoustic_fem(cfg);
    spectrum=solve_all_eigenmodes(sys,'FrequencyRange',fRange, ...
        'ShiftFrequency',opt.ShiftFrequency,'NumCandidates',opt.NumCandidates);
    theory=spectrum.table;writetable(theory,theoryFile);
end

[pairs,cost,ambiguity]=pair_modes(physical,theory);
main=build_comparison_table(physical,theory,pairs,cost,ambiguity);
writetable(main,fullfile(opt.OutputDir,'all_eigenmode_comparison.csv'));

classification=build_classification(reference,main,opt.PMLThreshold);
writetable(classification,fullfile(opt.OutputDir,'all_comsol_mode_classification.csv'));
summary=make_summary(main,height(reference),height(theory),height(physical));
writetable(summary,fullfile(opt.OutputDir,'all_eigenmode_summary.csv'));
save(fullfile(opt.OutputDir,'all_eigenmode_state.mat'), ...
    'spectrum','pairs','cost','ambiguity','summary','-v7.3');
disp(summary);
result=struct('reference',reference,'physicalReference',physical, ...
    'theory',theory,'comparison',main,'classification',classification, ...
    'summary',summary,'pairs',pairs);
end

function [pairs,pairCost,ambiguity]=pair_modes(R,T)
rf=R.frequency_real_Hz;tf=T.frequency_real_Hz;
ri=abs(R.frequency_imag_Hz);ti=abs(T.frequency_imag_Hz);
rchan=R{:,{'Eoz1_fraction','Eoz0_fraction','Eoz_1_fraction', ...
    'Eof1_fraction','Eof0_fraction','Eof_1_fraction'}};
tchan=T{:,{'Eoz1_fraction','Eoz0_fraction','Eoz_1_fraction', ...
    'Eof1_fraction','Eof0_fraction','Eof_1_fraction'}};
C=zeros(numel(rf),numel(tf));
for i=1:numel(rf)
    df=abs(tf-rf(i))/12;
    di=abs(log10((ti+0.25)/(ri(i)+0.25)));
    dc=sum(abs(tchan-rchan(i,:)),2);
    C(i,:)=df(:).'+0.35*di(:).'+0.40*dc(:).';
end
if exist('matchpairs','file')==2
    pairs=matchpairs(C,1e6,'min');
else
    pairs=greedy_pairs(C);
end
pairs=sortrows(pairs,1);
pairCost=C(sub2ind(size(C),pairs(:,1),pairs(:,2)));
ambiguity=zeros(size(pairCost));
for k=1:size(pairs,1)
    row=sort(C(pairs(k,1),:));
    ambiguity(k)=row(min(2,numel(row)))-row(1);
end
end

function pairs=greedy_pairs(C)
pairs=zeros(min(size(C)),2);W=C;
for k=1:size(pairs,1)
    [~,q]=min(W,[],'all','linear');[i,j]=ind2sub(size(W),q);
    pairs(k,:)=[i,j];W(i,:)=inf;W(:,j)=inf;
end
end

function T=build_comparison_table(R,M,pairs,cost,ambiguity)
n=size(pairs,1);T=table;
T.comsol_index=zeros(n,1);T.theory_index=zeros(n,1);
base={'Eoz1','Eoz0','Eoz_1','Eof1','Eof0','Eof_1'};
for k=1:n
    i=pairs(k,1);j=pairs(k,2);
    T.comsol_index(k)=R.comsol_index(i);T.theory_index(k)=M.theory_index(j);
    T.comsol_pml_fraction(k)=R.pml_fraction(i);
    T.comsol_real_Hz(k)=R.frequency_real_Hz(i);T.theory_real_Hz(k)=M.frequency_real_Hz(j);
    T.real_error_Hz(k)=T.theory_real_Hz(k)-T.comsol_real_Hz(k);
    T.comsol_imag_Hz(k)=R.frequency_imag_Hz(i);T.theory_imag_Hz(k)=M.frequency_imag_Hz(j);
    T.imag_error_Hz(k)=T.theory_imag_Hz(k)-T.comsol_imag_Hz(k);
    T.comsol_Q(k)=R.Q(i);T.theory_Q(k)=M.Q(j);
    for q=1:6
        rv=R.([base{q} '_fraction'])(i);mv=M.([base{q} '_fraction'])(j);
        T.(['comsol_' base{q}])(k)=rv;T.(['theory_' base{q}])(k)=mv;
        T.([base{q} '_error'])(k)=mv-rv;
    end
    T.pair_cost(k)=cost(k);T.pair_ambiguity(k)=ambiguity(k);
end
T.pair_quality=repmat("low",height(T),1);
T.pair_quality(T.pair_cost<2.5)="moderate";
T.pair_quality(T.pair_cost<1)="high";
T.pair_quality(T.pair_ambiguity<0.15)="ambiguous";
end

function C=build_classification(R,matched,threshold)
C=R(:,{'comsol_index','frequency_real_Hz','frequency_imag_Hz','Q','pml_fraction'});
C.mode_class=repmat("physical",height(C),1);
C.mode_class(C.pml_fraction>=threshold)="PML-dominated";
C.matched_theory_index=nan(height(C),1);
C.real_error_Hz=nan(height(C),1);C.imag_error_Hz=nan(height(C),1);
C.pair_quality=repmat("not-applicable",height(C),1);
for k=1:height(matched)
    i=find(C.comsol_index==matched.comsol_index(k),1);
    C.matched_theory_index(i)=matched.theory_index(k);
    C.real_error_Hz(i)=matched.real_error_Hz(k);
    C.imag_error_Hz(i)=matched.imag_error_Hz(k);
    C.pair_quality(i)=matched.pair_quality(k);
end
end

function S=make_summary(T,nReference,nTheory,nPhysical)
channelVars=endsWith(T.Properties.VariableNames,'_error') & ...
    ~ismember(T.Properties.VariableNames,{'real_error_Hz','imag_error_Hz'});
ce=T{:,channelVars};
high=T.pair_quality=="high";
he=T{high,channelVars};
S=table(nReference,nPhysical,nReference-nPhysical,nTheory,height(T), ...
    sqrt(mean(T.real_error_Hz.^2)),median(abs(T.real_error_Hz)),max(abs(T.real_error_Hz)), ...
    sqrt(mean(T.imag_error_Hz.^2)),median(abs(T.imag_error_Hz)), ...
    sqrt(mean(ce.^2,'all')),max(abs(ce),[],'all'),nnz(T.pair_ambiguity<0.15), ...
    nnz(high),sqrt(mean(T.real_error_Hz(high).^2)), ...
    sqrt(mean(T.imag_error_Hz(high).^2)),sqrt(mean(he.^2,'all')), ...
    'VariableNames',{'comsol_mode_count','physical_comsol_mode_count', ...
    'pml_dominated_mode_count','theory_candidate_count','paired_count', ...
    'real_RMSE_Hz','real_median_abs_Hz','real_max_abs_Hz', ...
    'imag_RMSE_Hz','imag_median_abs_Hz','channel_RMSE','channel_max_abs', ...
    'ambiguous_pair_count','high_confidence_count','high_real_RMSE_Hz', ...
    'high_imag_RMSE_Hz','high_channel_RMSE'});
end
