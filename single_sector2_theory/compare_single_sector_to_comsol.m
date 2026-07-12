function out=compare_single_sector_to_comsol(C,M,outputDir)
%COMPARE_SINGLE_SECTOR_TO_COMSOL Pair physical theory poles with TXT rows.

if nargin<3||isempty(outputDir),outputDir=fullfile(fileparts(mfilename('fullpath')),'output');end
if ~exist(outputDir,'dir'),mkdir(outputDir);end
nc=height(C);nt=height(M);pairs=zeros(0,2);
if nt>0
    er=abs(C.frequency_real_Hz-M.frequency_real_Hz.')./C.frequency_real_Hz;
    ei=abs(C.frequency_imag_Hz-M.frequency_imag_Hz.')./max(abs(C.frequency_imag_Hz),1);
    ef=abs(C.Forward-M.Forward.');eb=abs(C.Backward-M.Backward.');
    cost=er+0.35*ei+0.15*(ef+eb);
    if exist('matchpairs','file')==2
        pairs=sortrows(matchpairs(cost,1e6,'min'),1);
    else
        W=cost;
        for k=1:min(size(W))
            [~,q]=min(W,[],'all','linear');[i,j]=ind2sub(size(W),q);
            pairs(end+1,:)=[i,j];W(i,:)=inf;W(:,j)=inf; %#ok<AGROW>
        end
        pairs=sortrows(pairs,1);
    end
end

n=size(pairs,1);T=table;
if n>0
    i=pairs(:,1);j=pairs(:,2);
    T=table(C.solution_index(i),M.theory_index(j),C.frequency_real_Hz(i), ...
        M.frequency_real_Hz(j),C.frequency_imag_Hz(i),M.frequency_imag_Hz(j), ...
        C.Forward(i),M.Forward(j),C.Backward(i),M.Backward(j), ...
        abs(M.frequency_real_Hz(j)-C.frequency_real_Hz(i))./C.frequency_real_Hz(i), ...
        abs(M.frequency_imag_Hz(j)-C.frequency_imag_Hz(i))./max(abs(C.frequency_imag_Hz(i)),1), ...
        'VariableNames',{'comsol_index','theory_index','comsol_real_Hz','theory_real_Hz', ...
        'comsol_imag_Hz','theory_imag_Hz','comsol_Forward','theory_Forward', ...
        'comsol_Backward','theory_Backward','real_relative_error','imag_relative_error'});
end
writetable(C,fullfile(outputDir,'comsol_reference_from_txt.csv'));
writetable(M,fullfile(outputDir,'single_sector2_theory_roots.csv'));
writetable(T,fullfile(outputDir,'matched_physical_roots.csv'));

theoryReal=nan(nc,1);theoryImag=nan(nc,1);theoryF=nan(nc,1);theoryB=nan(nc,1);
if n>0
    ii=pairs(:,1);jj=pairs(:,2);
    theoryReal(ii)=M.frequency_real_Hz(jj);theoryImag(ii)=M.frequency_imag_Hz(jj);
    theoryF(ii)=M.Forward(jj);theoryB(ii)=M.Backward(jj);
end
x=(1:nc).';fig=figure('Color','w','Position',[80 80 1320 820]);
tl=tiledlayout(fig,2,2,'TileSpacing','compact','Padding','compact');
title(tl,'Single sector cavity 2: COMSOL TXT vs analytic mode matching');
pairplot(nexttile,x,C.frequency_real_Hz,theoryReal,'Re(f) (Hz)');
pairplot(nexttile,x,C.frequency_imag_Hz,theoryImag,'Im(f) (Hz)');
pairplot(nexttile,x,C.Forward,theoryF,'Forward');
pairplot(nexttile,x,C.Backward,theoryB,'Backward');
lg=legend('COMSOL TXT','Theory physical pole','Location','best');lg.Layout.Tile='east';
base=fullfile(outputDir,'single_sector2_comsol_matlab_comparison');
exportgraphics(fig,[base '.png'],'Resolution',300);
exportgraphics(fig,[base '.pdf'],'ContentType','vector');savefig(fig,[base '.fig']);
drawnow;

allPassed=nt==nc && n==nc && all(T.real_relative_error<=.10) && ...
    all(T.imag_relative_error<=.10);
S=table(nc,nt,n,allPassed,'VariableNames', ...
    {'comsol_root_count','theory_physical_root_count','matched_root_count','all_60_passed'});
writetable(S,fullfile(outputDir,'comparison_summary.csv'));
fprintf('Single-sector comparison: COMSOL=%d, theory physical poles=%d, matched=%d, all60=%d\n', ...
    nc,nt,n,allPassed);
fprintf('Displayed and saved comparison figure:\n  %s\n', [base '.png']);
out=struct('comparison',T,'summary',S,'pairs',pairs,'plot',[base '.png']);
end

function pairplot(ax,x,c,m,label)
plot(ax,x,c,'-o','Color',[.1 .1 .1],'LineWidth',1.1,'MarkerSize',4, ...
    'MarkerFaceColor','w');hold(ax,'on');
plot(ax,x,m,'--s','Color',[0 .447 .741],'LineWidth',1.2,'MarkerSize',6, ...
    'MarkerFaceColor','w');grid(ax,'on');box(ax,'on');
xlabel(ax,'Solution number');ylabel(ax,label);xlim(ax,[1 max(x)]);
end
