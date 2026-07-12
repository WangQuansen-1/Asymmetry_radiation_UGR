function fig=plot_1300_1500_mode_localization(energyCsv,outputDir)
%PLOT_1300_1500_MODE_LOCALIZATION Plot COMSOL pressure-energy location.
T=readtable(energyCsv);
keep=T.real_Hz>=1300&T.real_Hz<=1500;T=T(keep,:);
if ~exist(outputDir,'dir'),mkdir(outputDir);end
fig=figure('Color','w','Position',[100 100 1250 720]);
tl=tiledlayout(fig,2,1,'TileSpacing','compact','Padding','compact');
title(tl,'COMSOL modes in 1300-1500 Hz: pressure-energy localization');
x=(1:height(T)).';
bar(nexttile,x,[T.PML_fraction,T.physical_duct_fraction,T.cavity_fraction], ...
    'stacked','LineStyle','none');grid on;box on;ylim([0 1]);
xlabel('Solution number within 1300-1500 Hz');ylabel('Fraction of integral |p|^2');
legend('PML','Physical duct','C1+C2 cavities','Location','eastoutside');
ax=nexttile;
yyaxis(ax,'left');plot(ax,x,T.real_Hz,'-o','LineWidth',1.2,'MarkerFaceColor','w');
ylabel(ax,'Re(f) (Hz)');
yyaxis(ax,'right');plot(ax,x,T.imag_Hz,'--s','LineWidth',1.2,'MarkerFaceColor','w');
ylabel(ax,'Im(f) (Hz)');grid(ax,'on');box(ax,'on');xlabel(ax,'Solution number within 1300-1500 Hz');
base=fullfile(outputDir,'comsol_1300_1500_mode_localization');
exportgraphics(fig,[base '.png'],'Resolution',300);
exportgraphics(fig,[base '.pdf'],'ContentType','vector');savefig(fig,[base '.fig']);drawnow;
writetable(T,fullfile(outputDir,'comsol_1300_1500_mode_localization.csv'));
end
