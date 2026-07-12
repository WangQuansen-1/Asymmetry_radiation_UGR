function files=plot_comsol_matlab_modes(T,outputBase,varargin)
%PLOT_COMSOL_MATLAB_MODES Plot paired COMSOL and MATLAB modal quantities.

ip=inputParser;
ip.addParameter('Title','COMSOL vs MATLAB');
ip.addParameter('RealTolerance',0.10);
ip.addParameter('ImagTolerance',0.10);
ip.parse(varargin{:});opt=ip.Results;

[folder,~,~]=fileparts(outputBase);if ~isempty(folder)&&~exist(folder,'dir'),mkdir(folder);end
x=(1:height(T)).';
fig=figure('Color','w','Position',[100 100 1320 820]);
tl=tiledlayout(fig,2,2,'TileSpacing','compact','Padding','compact');
title(tl,opt.Title,'Interpreter','none','FontWeight','bold');
draw_pair(nexttile,x,T.comsol_real_Hz,T.matlab_real_Hz,'Re(f) (Hz)');
draw_pair(nexttile,x,T.comsol_imag_Hz,T.matlab_imag_Hz,'Im(f) (Hz)');
draw_pair(nexttile,x,T.comsol_Forward,T.matlab_Forward,'Forward');
draw_pair(nexttile,x,T.comsol_Backward,T.matlab_Backward,'Backward');
lg=legend('COMSOL','MATLAB','Location','best');lg.Layout.Tile='east';
files.comparison_png=[outputBase '_comparison.png'];
files.comparison_pdf=[outputBase '_comparison.pdf'];
files.comparison_fig=[outputBase '_comparison.fig'];
exportgraphics(fig,files.comparison_png,'Resolution',300);
exportgraphics(fig,files.comparison_pdf,'ContentType','vector');
savefig(fig,files.comparison_fig);close(fig);

fig=figure('Color','w','Position',[120 120 1320 560]);
tl=tiledlayout(fig,1,2,'TileSpacing','compact','Padding','compact');
title(tl,[opt.Title ' — relative error'],'Interpreter','none','FontWeight','bold');
draw_error(nexttile,x,100*T.real_relative_error,100*opt.RealTolerance,'Re(f) error (%)');
draw_error(nexttile,x,100*T.imag_relative_error,100*opt.ImagTolerance,'Im(f) error (%)');
files.error_png=[outputBase '_relative_error.png'];
files.error_pdf=[outputBase '_relative_error.pdf'];
files.error_fig=[outputBase '_relative_error.fig'];
exportgraphics(fig,files.error_png,'Resolution',300);
exportgraphics(fig,files.error_pdf,'ContentType','vector');
savefig(fig,files.error_fig);close(fig);
fprintf('Saved MATLAB comparison plots: %s\n',files.comparison_png);
end

function draw_pair(ax,x,a,b,label)
plot(ax,x,a,'-o','Color',[0.10 0.10 0.10],'LineWidth',1.15,'MarkerSize',4, ...
    'MarkerFaceColor','w');hold(ax,'on');
plot(ax,x,b,'--s','Color',[0.00 0.45 0.74],'LineWidth',1.15,'MarkerSize',4, ...
    'MarkerFaceColor','w');
grid(ax,'on');box(ax,'on');xlabel(ax,'Solution number');ylabel(ax,label);
xlim(ax,[1 max(x)]);
end

function draw_error(ax,x,e,limit,label)
pass=e<=limit;
plot(ax,x,e,'--s','Color',[0.00 0.45 0.74],'LineWidth',1.0,'MarkerSize',4);hold(ax,'on');
plot(ax,x(~pass),e(~pass),'x','Color',[0.85 0.20 0.15],'LineWidth',1.3,'MarkerSize',7);
yline(ax,limit,':',sprintf('%.1f%% limit',limit),'Color',[0.85 0.20 0.15],'LineWidth',1.2);
grid(ax,'on');box(ax,'on');xlabel(ax,'Solution number');ylabel(ax,label);
xlim(ax,[1 max(x)]);
legend(ax,'Relative error','Failed mode','Tolerance','Location','best');
end
