function files=plot_two_cavity_structure_confirmation(outputDir)
%PLOT_TWO_CAVITY_STRUCTURE_CONFIRMATION Parametric COMSOL geometry audit.
% This function only draws the two cavity types and their active symmetry
% copies.  It performs no acoustic or eigenfrequency calculation.

if nargin<1||isempty(outputDir),outputDir=fileparts(mfilename('fullpath'));end
if ~exist(outputDir,'dir'),mkdir(outputDir);end

g.R0=0.100;
g.c1.depth=0.045171875;g.c1.rout=g.R0+g.c1.depth;
g.c1.span=44;g.c1.zp=[0.050,0.10662041875];
g.c2.depth=0.081458978125;g.c2.rout=g.R0+g.c2.depth;
g.c2.span=44;g.c2.zp=[0.0659704015625,0.0906500171875];
g.c1.zn=-fliplr(g.c1.zp);g.c2.zn=-fliplr(g.c2.zp);
g.pos.c1=[10 54;190 234];g.pos.c2=[64 108;244 288];
g.neg.c1=[0 44;180 224];g.neg.c2=[54 98;234 278];
c1=[0.93 0.45 0.12];c2=[0.12 0.52 0.86];

fig=figure('Color','w','Position',[40 40 1500 980]);
tl=tiledlayout(fig,2,2,'TileSpacing','compact','Padding','compact');
title(tl,'Two cavity types with active COMSOL symmetry copies (geometry only)', ...
    'FontWeight','bold');

ax=nexttile(tl,1);hold(ax,'on');
[th,z]=meshgrid(linspace(0,2*pi,120),linspace(-0.18,0.18,35));
surf(ax,g.R0*cos(th),g.R0*sin(th),z,'FaceColor',[.65 .68 .72], ...
    'FaceAlpha',.20,'EdgeColor','none');
draw_set_3d(ax,g.R0,g.c1.rout,g.pos.c1,g.c1.zp,c1,.88);
draw_set_3d(ax,g.R0,g.c2.rout,g.pos.c2,g.c2.zp,c2,.88);
draw_set_3d(ax,g.R0,g.c1.rout,g.neg.c1,g.c1.zn,c1,.45);
draw_set_3d(ax,g.R0,g.c2.rout,g.neg.c2,g.c2.zn,c2,.45);
plot3(ax,[0 0],[0 0],[-.18 .18],'k:','LineWidth',1);
axis(ax,'equal');grid(ax,'on');box(ax,'on');view(ax,36,24);
xlabel(ax,'x (m)');ylabel(ax,'y (m)');zlabel(ax,'z (m)');
title(ax,'(a) Active 3D structure');
xlim(ax,[-.20 .20]);ylim(ax,[-.20 .20]);zlim(ax,[-.18 .18]);

ax=nexttile(tl,2);hold(ax,'on');
draw_top(ax,g.R0,g.c1.rout,g.pos.c1,c1,'Cavity 1 (+z)');
draw_top(ax,g.R0,g.c2.rout,g.pos.c2,c2,'Cavity 2 (+z)');
circle(ax,g.R0);axis(ax,'equal');grid(ax,'on');box(ax,'on');
xlabel(ax,'x (m)');ylabel(ax,'y (m)');title(ax,'(b) +z layer: rotated +10 deg');
xlim(ax,[-.20 .20]);ylim(ax,[-.20 .20]);

ax=nexttile(tl,3);hold(ax,'on');
draw_top(ax,g.R0,g.c1.rout,g.neg.c1,c1,'Cavity 1 (-z)');
draw_top(ax,g.R0,g.c2.rout,g.neg.c2,c2,'Cavity 2 (-z)');
circle(ax,g.R0);axis(ax,'equal');grid(ax,'on');box(ax,'on');
xlabel(ax,'x (m)');ylabel(ax,'y (m)');title(ax,'(c) -z mirrored layer: unrotated');
xlim(ax,[-.20 .20]);ylim(ax,[-.20 .20]);

ax=nexttile(tl,4);hold(ax,'on');
draw_unwrapped(ax,g.pos.c1,1000*g.c1.zp,c1,'C1 +z');
draw_unwrapped(ax,g.pos.c2,1000*g.c2.zp,c2,'C2 +z');
draw_unwrapped(ax,g.neg.c1,1000*g.c1.zn,c1,'C1 -z');
draw_unwrapped(ax,g.neg.c2,1000*g.c2.zn,c2,'C2 -z');
xlim(ax,[0 360]);ylim(ax,[-120 120]);xticks(ax,0:45:360);
yline(ax,0,'k:');grid(ax,'on');box(ax,'on');
xlabel(ax,'Azimuth angle theta (deg)');ylabel(ax,'z interval (mm)');
title(ax,'(d) Unwrapped angular/axial positions');

base=fullfile(outputDir,'two_cavity_structure_confirmation');
files.png=[base '.png'];files.pdf=[base '.pdf'];files.fig=[base '.fig'];
exportgraphics(fig,files.png,'Resolution',300);
exportgraphics(fig,files.pdf,'ContentType','vector');savefig(fig,files.fig);drawnow;
fprintf('Displayed and saved structure confirmation figure:\n  %s\n',files.png);
end

function draw_set_3d(ax,rin,rout,ranges,zrange,color,alpha)
for k=1:size(ranges,1)
    draw_sector_volume(ax,rin,rout,ranges(k,1),ranges(k,2),zrange(1),zrange(2),color,alpha);
end
end

function draw_sector_volume(ax,rin,rout,t1,t2,z1,z2,color,alpha)
t=deg2rad(linspace(t1,t2,36));r=linspace(rin,rout,12);
[T,Z]=meshgrid(t,linspace(z1,z2,8));
surf(ax,rout*cos(T),rout*sin(T),Z,'FaceColor',color,'FaceAlpha',alpha,'EdgeColor','none');
surf(ax,rin*cos(T),rin*sin(T),Z,'FaceColor',color,'FaceAlpha',alpha*.75,'EdgeColor','none');
[T,R]=meshgrid(t,r);
surf(ax,R.*cos(T),R.*sin(T),z1+zeros(size(T)),'FaceColor',color,'FaceAlpha',alpha,'EdgeColor','none');
surf(ax,R.*cos(T),R.*sin(T),z2+zeros(size(T)),'FaceColor',color,'FaceAlpha',alpha,'EdgeColor','none');
for q=[t1 t2]
    [R,Z]=meshgrid(r,linspace(z1,z2,8));Q=deg2rad(q);
    surf(ax,R.*cos(Q),R.*sin(Q),Z,'FaceColor',color,'FaceAlpha',alpha,'EdgeColor','none');
end
end

function draw_top(ax,rin,rout,ranges,color,label)
for k=1:size(ranges,1)
    t=deg2rad(linspace(ranges(k,1),ranges(k,2),60));
    x=[rout*cos(t),rin*cos(fliplr(t))];y=[rout*sin(t),rin*sin(fliplr(t))];
    if k==1
        patch(ax,x,y,color,'FaceAlpha',.72,'EdgeColor',color,'LineWidth',1.2, ...
            'DisplayName',label);
    else
        patch(ax,x,y,color,'FaceAlpha',.72,'EdgeColor',color,'LineWidth',1.2, ...
            'HandleVisibility','off');
    end
    tc=mean(t);rc=(rin+rout)/2;
    text(ax,rc*cos(tc),rc*sin(tc),sprintf('%g-%g deg',ranges(k,1),ranges(k,2)), ...
        'HorizontalAlignment','center','FontSize',8,'Rotation',rad2deg(tc)-90);
end
legend(ax,'Location','bestoutside');
end

function circle(ax,r)
t=linspace(0,2*pi,250);plot(ax,r*cos(t),r*sin(t),'k-','LineWidth',1.2,'DisplayName','Duct wall');
end

function draw_unwrapped(ax,ranges,zrange,color,label)
for k=1:size(ranges,1)
    rectangle(ax,'Position',[ranges(k,1),zrange(1),diff(ranges(k,:)),diff(zrange)], ...
        'FaceColor',[color .55],'EdgeColor',color,'LineWidth',1.2);
    text(ax,mean(ranges(k,:)),mean(zrange),label,'HorizontalAlignment','center','FontSize',8);
end
end
