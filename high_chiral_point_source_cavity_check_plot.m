%% high_chiral_point_source_cavity_check_plot
% Independent plot to verify that the active point source lies inside the
% cavity volume reconstructed from high_chiral.m.

clear; clc; close all;

rootDir = fileparts(mfilename('fullpath'));
outDir = fullfile(rootDir, 'theory_output');

src = readtable(fullfile(outDir, 'high_chiral_point_sources.csv'));
geo = readtable(fullfile(outDir, 'high_chiral_geometry_parameters.csv'));

hostName = string(src.HostSolid(1));
host = geo(string(geo.Name) == hostName, :);
if isempty(host)
    error('Host cavity %s was not found in geometry table.', hostName);
end

x = src.X_mm(1);
y = src.Y_mm(1);
z = src.Z_mm(1);
r = hypot(x, y);
phi = atan2d(y, x);
if phi < 0
    phi = phi + 360;
end

insideR = r > host.Rin_mm && r < host.Rout_mm;
insidePhi = phi > host.PhiStart_deg && phi < host.PhiEnd_deg;
insideZ = z > host.Z0_mm && z < host.Z1_mm;
insideCavity = insideR && insidePhi && insideZ;

fig = figure('Color', 'w', 'Position', [120 80 1350 700]);
tiledlayout(fig, 1, 3, 'TileSpacing', 'compact', 'Padding', 'compact');

ax1 = nexttile(1);
hold(ax1, 'on'); axis(ax1, 'equal'); grid(ax1, 'on');
th = deg2rad(linspace(host.PhiStart_deg, host.PhiEnd_deg, 120));
sectorX = [host.Rin_mm*cos(th), fliplr(host.Rout_mm*cos(th))];
sectorY = [host.Rin_mm*sin(th), fliplr(host.Rout_mm*sin(th))];
patch(ax1, sectorX, sectorY, [0.12 0.63 0.56], ...
    'FaceAlpha', 0.70, 'EdgeColor', [0.05 0.35 0.30], 'LineWidth', 1.4);
plot(ax1, x, y, 'o', 'MarkerSize', 9, 'LineWidth', 1.4, ...
    'MarkerFaceColor', [1 0.05 0.02], 'MarkerEdgeColor', [0.25 0 0]);
text(ax1, x+3.5, y+3.0, sprintf('%s  P%d', string(src.Name(1)), src.ComsolPointId(1)), ...
    'Color', [0.55 0 0], 'FontWeight', 'bold', 'Interpreter', 'none');
xlabel(ax1, 'x (mm)');
ylabel(ax1, 'y (mm)');
title(ax1, 'Top view: source inside annular cavity');
xlim(ax1, [min(sectorX)-8, max(sectorX)+12]);
ylim(ax1, [min(sectorY)-8, max(sectorY)+12]);

ax2 = nexttile(2);
hold(ax2, 'on'); axis(ax2, 'equal'); grid(ax2, 'on');
rectangle(ax2, 'Position', [host.Z0_mm, host.Rin_mm, ...
    host.Z1_mm-host.Z0_mm, host.Rout_mm-host.Rin_mm], ...
    'FaceColor', [0.12 0.63 0.56], 'EdgeColor', [0.05 0.35 0.30], ...
    'LineWidth', 1.4);
plot(ax2, z, r, 'o', 'MarkerSize', 9, 'LineWidth', 1.4, ...
    'MarkerFaceColor', [1 0.05 0.02], 'MarkerEdgeColor', [0.25 0 0]);
text(ax2, z+1.5, r+1.2, sprintf('%s  P%d', string(src.Name(1)), src.ComsolPointId(1)), ...
    'Color', [0.55 0 0], 'FontWeight', 'bold', 'Interpreter', 'none');
xlabel(ax2, 'z (mm)');
ylabel(ax2, 'r (mm)');
title(ax2, 'z-r section: source inside cavity depth');
xlim(ax2, [host.Z0_mm-8, host.Z1_mm+12]);
ylim(ax2, [host.Rin_mm-6, host.Rout_mm+8]);

ax3 = nexttile(3);
axis(ax3, 'off');
rows = {
    'Cavity inclusion check'
    sprintf('source: %s, COMSOL point %d', string(src.Name(1)), src.ComsolPointId(1))
    sprintf('host cavity: %s', hostName)
    ''
    sprintf('r_source = %.3f mm', r)
    sprintf('r_cavity = %.3f to %.3f mm', host.Rin_mm, host.Rout_mm)
    sprintf('inside r = %d', insideR)
    ''
    sprintf('phi_source = %.3f deg', phi)
    sprintf('phi_cavity = %.3f to %.3f deg', host.PhiStart_deg, host.PhiEnd_deg)
    sprintf('inside phi = %d', insidePhi)
    ''
    sprintf('z_source = %.3f mm', z)
    sprintf('z_cavity = %.3f to %.3f mm', host.Z0_mm, host.Z1_mm)
    sprintf('inside z = %d', insideZ)
    ''
    sprintf('inside cavity volume = %d', insideCavity)
    };
text(ax3, 0.02, 0.96, rows, 'Units', 'normalized', ...
    'VerticalAlignment', 'top', 'FontName', 'Consolas', ...
    'FontSize', 12, 'Interpreter', 'none');

pngFile = fullfile(outDir, 'high_chiral_point_source_in_cavity.png');
figFile = fullfile(outDir, 'high_chiral_point_source_in_cavity.fig');
exportgraphics(fig, pngFile, 'Resolution', 260);
savefig(fig, figFile);

check = table(string(src.Name(1)), src.ComsolPointId(1), hostName, ...
    r, host.Rin_mm, host.Rout_mm, phi, host.PhiStart_deg, host.PhiEnd_deg, ...
    z, host.Z0_mm, host.Z1_mm, insideR, insidePhi, insideZ, insideCavity, ...
    'VariableNames', {'Name','ComsolPointId','HostSolid','R_mm','Rin_mm','Rout_mm', ...
    'Phi_deg','PhiStart_deg','PhiEnd_deg','Z_mm','Z0_mm','Z1_mm', ...
    'InsideR','InsidePhi','InsideZ','InsideCavity'});
writetable(check, fullfile(outDir, 'high_chiral_point_source_cavity_check.csv'));

fprintf('Source-cavity check figure: %s\n', pngFile);
fprintf('Inside cavity volume: %d\n', insideCavity);
