function result=compare_eigenfrequency_forward_backward(varargin)
%COMPARE_EIGENFREQUENCY_FORWARD_BACKWARD Compare f, Forward and Backward.

here=fileparts(mfilename('fullpath'));
ip=inputParser;
ip.addParameter('ReferenceFile',fullfile(here,'comsol_all_eigenmodes.csv'));
ip.addParameter('PMLFile',fullfile(here,'comsol_pml_participation.csv'));
ip.addParameter('PMLThreshold',0.30);
ip.addParameter('OutputDir',fullfile(here,'output_eigen_fb'));
ip.addParameter('TheoryFile','');
ip.addParameter('IncludePMLModes',false,@islogical);
ip.addParameter('MaxRealRelativeError',inf);
ip.addParameter('RecomputeTheory',false,@islogical);
ip.addParameter('NumCandidates',28);
ip.addParameter('ShiftFrequency',[1300+120i,1500+110i,1650+100i,1700+1i,1800+35i]);
ip.parse(varargin{:});opt=ip.Results;
if ~isfolder(opt.OutputDir),mkdir(opt.OutputDir);end

R=readtable(opt.ReferenceFile,'VariableNamingRule','preserve');
P=readtable(opt.PMLFile,'VariableNamingRule','preserve');
[ok,loc]=ismember(R.comsol_index,P.comsol_index);
if ~all(ok),error('PML participation data do not cover all COMSOL modes.');end
R.pml_fraction=P.pml_fraction(loc);
R.Forward=R.Eoz1_fraction;
R.Backward=R.Eof1_fraction;
if opt.IncludePMLModes
    physical=R;
else
    physical=R(R.pml_fraction<opt.PMLThreshold,:);
end

sharedTheory=fullfile(here,'output_all_modes','matlab_all_eigenmodes.csv');
if ~isempty(opt.TheoryFile)
    M=readtable(opt.TheoryFile,'VariableNamingRule','preserve');
elseif ~opt.RecomputeTheory && isfile(sharedTheory)
    M=readtable(sharedTheory,'VariableNamingRule','preserve');
else
    cfg=single_cavity_parameters;sys=build_acoustic_fem(cfg);
    range=[min(R.frequency_real_Hz)-30,max(R.frequency_real_Hz)+30];
    spectrum=solve_all_eigenmodes(sys,'FrequencyRange',range, ...
        'ShiftFrequency',opt.ShiftFrequency,'NumCandidates',opt.NumCandidates);
    M=spectrum.table;
end
M.Forward=M.Eoz1_fraction;
M.Backward=M.Eof1_fraction;
writetable(M,fullfile(opt.OutputDir,'matlab_eigenfrequency_forward_backward.csv'));

[pairs,cost,ambiguity]=pair_by_fb(physical,M,opt.MaxRealRelativeError);
T=make_pair_table(physical,M,pairs,cost,ambiguity);
writetable(T,fullfile(opt.OutputDir,'eigenfrequency_forward_backward_comparison.csv'));

A=make_all_mode_table(R,T,opt.PMLThreshold);
writetable(A,fullfile(opt.OutputDir,'all_comsol_eigenfrequency_forward_backward.csv'));
S=make_fb_summary(T,height(R),height(physical),height(M));
writetable(S,fullfile(opt.OutputDir,'eigenfrequency_forward_backward_summary.csv'));
P=table((1:height(T)).',T.comsol_real_Hz,T.comsol_imag_Hz, ...
    T.comsol_Forward,T.comsol_Backward,T.theory_real_Hz,T.theory_imag_Hz, ...
    T.theory_Forward,T.theory_Backward, ...
    abs(T.real_error_Hz)./max(abs(T.comsol_real_Hz),eps), ...
    abs(T.imag_error_Hz)./max(abs(T.comsol_imag_Hz),1), ...
    'VariableNames',{'solution_index','comsol_real_Hz','comsol_imag_Hz', ...
    'comsol_Forward','comsol_Backward','matlab_real_Hz','matlab_imag_Hz', ...
    'matlab_Forward','matlab_Backward','real_relative_error','imag_relative_error'});
plot_comsol_matlab_modes(P,fullfile(opt.OutputDir,'comsol_matlab_modes'), ...
    'Title','Eigenmodes: COMSOL vs MATLAB','RealTolerance',0.10,'ImagTolerance',0.10);
save(fullfile(opt.OutputDir,'eigenfrequency_forward_backward_state.mat'), ...
    'pairs','cost','ambiguity','S','-v7.3');
disp(S);
result=struct('allComsol',A,'physicalComparison',T,'summary',S, ...
    'theory',M,'pairs',pairs);
end

function [pairs,pairCost,ambiguity]=pair_by_fb(R,M,maxRelativeError)
nr=height(R);nm=height(M);C=zeros(nr,nm);
for i=1:nr
    df=abs(M.frequency_real_Hz-R.frequency_real_Hz(i))/12;
    di=abs(log10((abs(M.frequency_imag_Hz)+0.25)/ ...
        (abs(R.frequency_imag_Hz(i))+0.25)));
    dFB=abs(M.Forward-R.Forward(i))+abs(M.Backward-R.Backward(i));
    C(i,:)=df(:).'+0.35*di(:).'+0.50*dFB(:).';
    if isfinite(maxRelativeError)
        rel=abs(M.frequency_real_Hz-R.frequency_real_Hz(i))/R.frequency_real_Hz(i);
        C(i,rel>maxRelativeError)=inf;
    end
end
if nm>=nr
    pairs=monotonic_pairs(C,0.05);
    if any(~isfinite(C(sub2ind(size(C),pairs(:,1),pairs(:,2)))))
        error('No order-preserving pairing satisfies MaxRealRelativeError=%.4g.', ...
            maxRelativeError);
    end
elseif exist('matchpairs','file')==2
    pairs=matchpairs(C,1e6,'min');
else
    pairs=greedy_pairs(C);
end

pairs=sortrows(pairs,1);
pairCost=C(sub2ind(size(C),pairs(:,1),pairs(:,2)));
ambiguity=zeros(size(pairCost));
for k=1:size(pairs,1)
    q=sort(C(pairs(k,1),:));
    ambiguity(k)=q(min(2,numel(q)))-q(1);
end

function pairs=monotonic_pairs(C,skipPenalty)
% Order-preserving assignment with optional unused MATLAB candidates.
[nr,nm]=size(C);D=inf(nr,nm);prev=zeros(nr,nm);
D(1,:)=C(1,:)+skipPenalty*(0:nm-1);
for i=2:nr
    for j=i:nm
        k=(i-1):(j-1);
        [best,q]=min(D(i-1,k)+skipPenalty*(j-k-1));
        D(i,j)=C(i,j)+best;prev(i,j)=k(q);
    end
end
[~,j]=min(D(nr,:)+skipPenalty*(nm-(1:nm)));
pairs=zeros(nr,2);
for i=nr:-1:1
    pairs(i,:)=[i,j];
    if i>1,j=prev(i,j);end
end
end
end

function pairs=greedy_pairs(C)
pairs=zeros(min(size(C)),2);W=C;
for k=1:size(pairs,1)
    [~,q]=min(W,[],'all','linear');[i,j]=ind2sub(size(W),q);
    pairs(k,:)=[i,j];W(i,:)=inf;W(:,j)=inf;
end
end

function T=make_pair_table(R,M,pairs,cost,ambiguity)
n=size(pairs,1);
names={'comsol_index','theory_index','pml_fraction','comsol_real_Hz', ...
    'theory_real_Hz','real_error_Hz','comsol_imag_Hz','theory_imag_Hz', ...
    'imag_error_Hz','comsol_Q','theory_Q','comsol_Forward', ...
    'theory_Forward','Forward_error','comsol_Backward','theory_Backward', ...
    'Backward_error','pair_cost','pair_ambiguity'};
T=array2table(zeros(n,numel(names)),'VariableNames',names);
for k=1:n
    i=pairs(k,1);j=pairs(k,2);
    T.comsol_index(k,1)=R.comsol_index(i);T.theory_index(k,1)=M.theory_index(j);
    T.pml_fraction(k,1)=R.pml_fraction(i);
    T.comsol_real_Hz(k,1)=R.frequency_real_Hz(i);
    T.theory_real_Hz(k,1)=M.frequency_real_Hz(j);
    T.real_error_Hz(k,1)=T.theory_real_Hz(k)-T.comsol_real_Hz(k);
    T.comsol_imag_Hz(k,1)=R.frequency_imag_Hz(i);
    T.theory_imag_Hz(k,1)=M.frequency_imag_Hz(j);
    T.imag_error_Hz(k,1)=T.theory_imag_Hz(k)-T.comsol_imag_Hz(k);
    T.comsol_Q(k,1)=R.Q(i);T.theory_Q(k,1)=M.Q(j);
    T.comsol_Forward(k,1)=R.Forward(i);T.theory_Forward(k,1)=M.Forward(j);
    T.Forward_error(k,1)=T.theory_Forward(k)-T.comsol_Forward(k);
    T.comsol_Backward(k,1)=R.Backward(i);T.theory_Backward(k,1)=M.Backward(j);
    T.Backward_error(k,1)=T.theory_Backward(k)-T.comsol_Backward(k);
    T.pair_cost(k,1)=cost(k);T.pair_ambiguity(k,1)=ambiguity(k);
end
T.pair_quality=repmat("low",height(T),1);
T.pair_quality(T.pair_cost<1.5)="moderate";
T.pair_quality(T.pair_cost<0.5)="high";
T.pair_quality(T.pair_ambiguity<0.15)="ambiguous";
end

function A=make_all_mode_table(R,T,threshold)
A=R(:,{'comsol_index','frequency_real_Hz','frequency_imag_Hz','Q', ...
    'Forward','Backward','pml_fraction'});
A.mode_class=repmat("physical",height(A),1);
A.mode_class(A.pml_fraction>=threshold)="PML-dominated";
A.matched_theory_index=nan(height(A),1);
A.theory_real_Hz=nan(height(A),1);A.theory_imag_Hz=nan(height(A),1);
A.theory_Forward=nan(height(A),1);A.theory_Backward=nan(height(A),1);
A.pair_quality=repmat("not-applicable",height(A),1);
for k=1:height(T)
    i=find(A.comsol_index==T.comsol_index(k),1);
    A.matched_theory_index(i)=T.theory_index(k);
    A.theory_real_Hz(i)=T.theory_real_Hz(k);
    A.theory_imag_Hz(i)=T.theory_imag_Hz(k);
    A.theory_Forward(i)=T.theory_Forward(k);
    A.theory_Backward(i)=T.theory_Backward(k);
    A.pair_quality(i)=T.pair_quality(k);
end
end

function S=make_fb_summary(T,nAll,nPhysical,nTheory)
high=T.pair_quality=="high";
S=table(nAll,nPhysical,nAll-nPhysical,nTheory,height(T),nnz(high), ...
    sqrt(mean(T.real_error_Hz.^2)),median(abs(T.real_error_Hz)), ...
    sqrt(mean(T.imag_error_Hz.^2)), ...
    sqrt(mean(T.Forward_error.^2)),sqrt(mean(T.Backward_error.^2)), ...
    sqrt(mean(T.real_error_Hz(high).^2)), ...
    sqrt(mean(T.Forward_error(high).^2)),sqrt(mean(T.Backward_error(high).^2)), ...
    'VariableNames',{'comsol_total','comsol_physical','comsol_pml_dominated', ...
    'theory_candidates','paired_physical','high_confidence_pairs', ...
    'real_RMSE_Hz','real_median_abs_Hz','imag_RMSE_Hz', ...
    'Forward_RMSE','Backward_RMSE','high_real_RMSE_Hz', ...
    'high_Forward_RMSE','high_Backward_RMSE'});
end
