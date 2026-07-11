function files=plot_eigenfrequency_forward_backward(varargin)
%PLOT_EIGENFREQUENCY_FORWARD_BACKWARD Four-panel COMSOL/MATLAB comparison.

here=fileparts(mfilename('fullpath'));
ip=inputParser;
ip.addParameter('ComparisonFile',fullfile(here,'output_eigen_fb', ...
    'eigenfrequency_forward_backward_comparison.csv'));
ip.addParameter('OutputDir',fullfile(here,'output_eigen_fb'));
ip.parse(varargin{:});opt=ip.Results;
if ~isfolder(opt.OutputDir),mkdir(opt.OutputDir);end

T=readtable(opt.ComparisonFile,'VariableNamingRule','preserve');
T=sortrows(T,'comsol_index');
x=(1:height(T)).';
target=find(T.comsol_index==8,1);

comsolColor=[0.12 0.12 0.12];
matlabColor=[0.10 0.38 0.72];
targetColor=[0.82 0.22 0.18];
gridColor=[0.88 0.88 0.88];

fig=figure('Color','w','Position',[80 60 1240 850]);
tl=tiledlayout(fig,2,2,'TileSpacing','compact','Padding','compact');

ax1=nexttile(tl);
draw_pair(ax1,x,T.comsol_real_Hz,T.theory_real_Hz, ...
    'Re(f) (Hz)','a  Eigenfrequency real part',comsolColor,matlabColor,gridColor);
legend(ax1,'Location','northwest','Box','off');

ax2=nexttile(tl);
draw_pair(ax2,x,T.comsol_imag_Hz,T.theory_imag_Hz, ...
    'Im(f) (Hz)','b  Eigenfrequency imaginary part',comsolColor,matlabColor,gridColor);

ax3=nexttile(tl);
draw_pair(ax3,x,T.comsol_Forward,T.theory_Forward, ...
    'Forward','c  Forward',comsolColor,matlabColor,gridColor);
ylim(ax3,[-0.03 1.03]);

ax4=nexttile(tl);
draw_pair(ax4,x,T.comsol_Backward,T.theory_Backward, ...
    'Backward','d  Backward',comsolColor,matlabColor,gridColor);
ylim(ax4,[-0.03 1.03]);

axs=[ax1 ax2 ax3 ax4];
for ax=axs
    xlim(ax,[0.4 height(T)+0.6]);
    xticks(ax,1:2:height(T));
    if ~isempty(target)
        xline(ax,target,':','Color',targetColor,'LineWidth',1.2, ...
            'HandleVisibility','off');
    end
end

if ~isempty(target)
    highlight_target(ax1,target,T.comsol_real_Hz(target),T.theory_real_Hz(target),targetColor);
    text(ax1,target+0.45,max(T.comsol_real_Hz(target),T.theory_real_Hz(target))+18, ...
        '1479 Hz target','Color',targetColor,'FontSize',9,'FontWeight','bold');
    highlight_target(ax2,target,T.comsol_imag_Hz(target),T.theory_imag_Hz(target),targetColor);
    highlight_target(ax3,target,T.comsol_Forward(target),T.theory_Forward(target),targetColor);
    highlight_target(ax4,target,T.comsol_Backward(target),T.theory_Backward(target),targetColor);
end

xlabel(tl,'Paired physical-mode number','FontSize',12,'FontWeight','bold');
title(tl,'COMSOL and independent MATLAB eigenmode comparison', ...
    'FontSize',15,'FontWeight','bold');

pngFile=fullfile(opt.OutputDir,'eigenfrequency_forward_backward_comparison.png');
pdfFile=fullfile(opt.OutputDir,'eigenfrequency_forward_backward_comparison.pdf');
svgFile=fullfile(opt.OutputDir,'eigenfrequency_forward_backward_comparison.svg');
exportgraphics(fig,pngFile,'Resolution',400);
exportgraphics(fig,pdfFile,'ContentType','vector');
print(fig,svgFile,'-dsvg');
close(fig);
files=struct('png',pngFile,'pdf',pdfFile,'svg',svgFile);
fprintf('Saved figure:\n  %s\n  %s\n  %s\n',pngFile,pdfFile,svgFile);
end

function draw_pair(ax,x,comsol,matlab,ylabelText,titleText,c1,c2,gridColor)
hold(ax,'on');box(ax,'on');grid(ax,'on');
ax.GridColor=gridColor;ax.GridAlpha=0.75;ax.LineWidth=0.8;
ax.FontName='Arial';ax.FontSize=10;
plot(ax,x,comsol,'-o','Color',c1,'LineWidth',1.35,'MarkerSize',4.5, ...
    'MarkerFaceColor','w','MarkerEdgeColor',c1,'DisplayName','COMSOL');
plot(ax,x,matlab,'--s','Color',c2,'LineWidth',1.35,'MarkerSize',4.3, ...
    'MarkerFaceColor','w','MarkerEdgeColor',c2,'DisplayName','MATLAB theory');
ylabel(ax,ylabelText,'FontWeight','bold');
title(ax,titleText,'FontWeight','bold','HorizontalAlignment','left');
end

function highlight_target(ax,x,y1,y2,color)
plot(ax,x,y1,'o','MarkerSize',8,'LineWidth',1.5,'Color',color, ...
    'MarkerFaceColor','w','HandleVisibility','off');
plot(ax,x,y2,'s','MarkerSize',7.5,'LineWidth',1.5,'Color',color, ...
    'MarkerFaceColor','w','HandleVisibility','off');
end
