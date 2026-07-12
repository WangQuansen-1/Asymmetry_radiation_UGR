function out=compare_two_cavity_to_comsol(C,M,outputDir)
%COMPARE_TWO_CAVITY_TO_COMSOL Match by complex frequency and plot all data.
if ~exist(outputDir,'dir'),mkdir(outputDir);end
nc=height(C);nt=height(M);pairs=zeros(0,2);
if nt>0
    er=abs(C.frequency_real_Hz-M.frequency_real_Hz.')./C.frequency_real_Hz;
    ei=abs(C.frequency_imag_Hz-M.frequency_imag_Hz.')./max(abs(C.frequency_imag_Hz),1);
    cost=er+0.35*ei;
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

names={'Eoz1_ratio','Eoz0_ratio','Eoz_1_ratio','Eof1_ratio','Eof0_ratio','Eof_1_ratio'};
n=size(pairs,1);T=table;
if n>0
    i=pairs(:,1);j=pairs(:,2);
    T=table(C.solution_index(i),M.theory_index(j),C.frequency_real_Hz(i), ...
        M.frequency_real_Hz(j),C.frequency_imag_Hz(i),M.frequency_imag_Hz(j), ...
        abs(M.frequency_real_Hz(j)-C.frequency_real_Hz(i))./C.frequency_real_Hz(i), ...
        abs(M.frequency_imag_Hz(j)-C.frequency_imag_Hz(i))./max(abs(C.frequency_imag_Hz(i)),1), ...
        'VariableNames',{'comsol_index','theory_index','comsol_real_Hz','theory_real_Hz', ...
        'comsol_imag_Hz','theory_imag_Hz','real_relative_error','imag_relative_error'});
    for q=1:numel(names)
        T.(['comsol_' names{q}])=C.(names{q})(i);
        T.(['theory_' names{q}])=M.(names{q})(j);
        T.([names{q} '_absolute_error'])=abs(C.(names{q})(i)-M.(names{q})(j));
    end
end
writetable(C,fullfile(outputDir,'comsol_below_1600Hz.csv'));
writetable(M,fullfile(outputDir,'matlab_two_cavity_roots_below_1600Hz.csv'));
writetable(T,fullfile(outputDir,'matched_comparison.csv'));

mapped=nan(nc,8); % Re, Im, then six ratios
if n>0
    ii=pairs(:,1);jj=pairs(:,2);
    mapped(ii,1)=M.frequency_real_Hz(jj);mapped(ii,2)=M.frequency_imag_Hz(jj);
    for q=1:6,mapped(ii,q+2)=M.(names{q})(jj);end
end
x=(1:nc).';fig=figure('Color','w','Position',[30 30 1500 1050]);
tl=tiledlayout(fig,4,2,'TileSpacing','compact','Padding','compact');
title(tl,sprintf(['Selected C1+C2 domains (-z layer): COMSOL versus analytic MATLAB ' ...
    '(%.0f-%.0f Hz)'],min(C.frequency_real_Hz),max(C.frequency_real_Hz)));
pairplot(nexttile,x,C.frequency_real_Hz,mapped(:,1),'Re(f) (Hz)');
pairplot(nexttile,x,C.frequency_imag_Hz,mapped(:,2),'Im(f) (Hz)');
labels={'Eoz1 / sum(Eoz) = Forward','Eoz0 / sum(Eoz)', ...
    'Eoz-1 / sum(Eoz)','Eof1 / sum(Eof) = Backward','Eof0 / sum(Eof)','Eof-1 / sum(Eof)'};
for q=1:6,pairplot(nexttile,x,C.(names{q}),mapped(:,q+2),labels{q});end
lg=legend('COMSOL','MATLAB analytic','Location','best');lg.Layout.Tile='east';
base=fullfile(outputDir,'two_cavity_comsol_matlab_comparison');
exportgraphics(fig,[base '.png'],'Resolution',300);
exportgraphics(fig,[base '.pdf'],'ContentType','vector');savefig(fig,[base '.fig']);drawnow;

allReal=false;allImag=false;
if n==nc&&nt==nc
    allReal=all(T.real_relative_error<=0.10);
    allImag=all(T.imag_relative_error<=0.10);
end
S=table(nc,nt,n,allReal,allImag,allReal&&allImag, ...
    'VariableNames',{'comsol_count','theory_count','matched_count', ...
    'all_real_within_10pct','all_imag_within_10pct','all_frequency_components_within_10pct'});
writetable(S,fullfile(outputDir,'comparison_summary.csv'));
fprintf('C1+C2 comparison: COMSOL=%d theory=%d matched=%d, Re gate=%d, Im gate=%d\n', ...
    nc,nt,n,allReal,allImag);
fprintf('Displayed and saved: %s\n',[base '.png']);
out=struct('comparison',T,'summary',S,'pairs',pairs,'plot',[base '.png']);
end

function pairplot(ax,x,c,m,label)
plot(ax,x,c,'-o','Color',[.08 .08 .08],'LineWidth',1.1,'MarkerSize',5, ...
    'MarkerFaceColor','w');hold(ax,'on');
plot(ax,x,m,'--s','Color',[0 .447 .741],'LineWidth',1.25,'MarkerSize',6, ...
    'MarkerFaceColor','w');grid(ax,'on');box(ax,'on');
xlabel(ax,'Solution number');ylabel(ax,label);xlim(ax,[1 max(x)]);
end
