%% high_chiral_geometry_model
% Draw the same geometry generated in high_chiral.m using native MATLAB.
% This is a geometry-only reconstruction: no acoustics, no mesh, no COMSOL.

clear; clc; close all;

%% Parameters copied from high_chiral.m
P.D = 100e-3;
P.L = 300e-3*2;
P.delta_th = 10;       % deg
P.zi = 0.05;
P.pml = P.L/4;
P.f0 = 3000;
P.c0 = 343;
P.lbd = P.c0/P.f0;
P.xy_theta = -10;      % active default value in high_chiral.m
P.R0 = P.D/2;

P.r_min = P.lbd/16;
P.r_max = P.lbd/4;
P.th1_min = 10;        % deg
P.th1_max = 180;       % deg
P.z1_min = P.lbd/16;
P.z1_max = P.lbd/4;
P.z2_min = P.lbd/16;
P.z2_max = P.lbd/4;

% Active default normalized values in high_chiral.m, lines 93-98.
N.th1 = 0.28951;
N.th2 = 0.27948;
N.r1 = 0.52627;
N.r2 = 0.41162;
N.z1 = 0.86975;
N.z2 = 0.68992;

% Active default axial offsets in high_chiral.m, lines 308-317.
N.dis_c2_x1 = 0.36359; % mov2: ext2
N.dis_c2_x2 = 0.81160; % mov3: ext1
N.dis_c2_x3 = 0.35459; % mov4: ext4
N.dis_c2_x4 = 0.42007; % mov5: ext3

P.r1 = P.r_min + (P.r_max-P.r_min)*N.r1;
P.r2 = P.r_min + (P.r_max-P.r_min)*N.r2;
P.th1 = P.th1_min + (P.th1_max-P.th1_min)*N.th1;
P.th2 = P.th1_min + (P.th1_max-P.th1_min)*N.th2;
P.z1 = P.z1_min + (P.z1_max-P.z1_min)*N.z1;
P.z2 = P.z2_min + (P.z2_max-P.z2_min)*N.z2;

P.dis_c2_xmax = P.lbd/2;
P.dis_c2_xmin = -P.lbd/2.5;
P.dis_c2_x1 = normToOffset(P, N.dis_c2_x1);
P.dis_c2_x2 = normToOffset(P, N.dis_c2_x2);
P.dis_c2_x3 = normToOffset(P, N.dis_c2_x3);
P.dis_c2_x4 = normToOffset(P, N.dis_c2_x4);

%% Reconstruct geometry features from high_chiral.m
% A COMSOL Circle with "angle" is a circular sector beginning at its
% rotation angle. Difference of the larger and smaller sectors gives an
% annular sector. Extrude distance is positive along z.
ext1 = annularSectorSolid("ext1", P.R0, P.R0+P.r1, 0, P.th1, ...
    P.zi, P.zi+P.z1, [0.13 0.44 0.78], 1.00);

ext2 = annularSectorSolid("ext2", P.R0, P.R0+P.r2, P.th1+P.delta_th, P.th2, ...
    P.zi+P.z1/2-P.z2/2, P.zi+P.z1/2+P.z2/2, [0.92 0.55 0.13], 1.00);

ext3 = annularSectorSolid("ext3", P.R0, P.R0+P.r1, 180, P.th1, ...
    P.zi, P.zi+P.z1, [0.12 0.63 0.56], 1.00);

ext4 = annularSectorSolid("ext4", P.R0, P.R0+P.r2, 180+P.th1+P.delta_th, P.th2, ...
    P.zi+P.z1/2-P.z2/2, P.zi+P.z1/2+P.z2/2, [0.72 0.44 0.80], 1.00);

% Move features.
mov2 = translateSolid(ext2, [0 0 P.dis_c2_x1], "mov2(ext2)");
mov3 = translateSolid(ext1, [0 0 P.dis_c2_x2], "mov3(ext1)");
mov4 = translateSolid(ext4, [0 0 P.dis_c2_x3], "mov4(ext4)");
mov5 = translateSolid(ext3, [0 0 P.dis_c2_x4], "mov5(ext3)");

% mir1 in the exported COMSOL file keeps the original and mirrored objects.
% The default 3D mirror plane is the xy plane through the origin, which
% maps z -> -z. We draw only the mirrored copy as mir1 output, because the
% final union is selection {'mir1','rot3'}.
mir1 = [mirrorZ(mov3, "mir1(mov3)") mirrorZ(mov2, "mir1(mov2)") ...
        mirrorZ(mov5, "mir1(mov5)") mirrorZ(mov4, "mir1(mov4)")];

% rot3 rotates the moved, non-mirrored group around the z axis by xy_theta.
rot3 = [rotateZ(mov3, P.xy_theta, "rot3(mov3)") ...
        rotateZ(mov2, P.xy_theta, "rot3(mov2)") ...
        rotateZ(mov5, P.xy_theta, "rot3(mov5)") ...
        rotateZ(mov4, P.xy_theta, "rot3(mov4)")];

finalSolids = [mir1 rot3];

% Active point source from high_chiral.m:
%   mps1 -> point [8],  phi = pi, P_rms = 1e-4, active(false), not drawn
%   mps2 -> COMSOL point [19], phi = 0, P_rms = 1e-4, active by default
% The exported file stores only COMSOL point IDs, not explicit coordinates.
% For MATLAB visualization, place the active source at the center of its
% inferred A-type host cavity in the final rot3 group.
sources = sourceFromSolid("mps2", 19, "0", 1e-4, true, rot3(3));

%% Draw and export
outDir = fullfile(fileparts(mfilename('fullpath')), 'theory_output');
if ~exist(outDir, 'dir')
    mkdir(outDir);
end

fig = figure('Color', 'w', 'Position', [80 60 1500 900]);
tiledlayout(fig, 2, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

ax1 = nexttile(1);
drawFinal3D(ax1, P, finalSolids, sources, false);
title(ax1, 'Final 3D geometry: union(mir1, rot3)');

ax2 = nexttile(2);
drawFinal3D(ax2, P, finalSolids, sources, true);
view(ax2, 2);
title(ax2, 'Top view');

ax3 = nexttile(3);
drawFinal3D(ax3, P, finalSolids, sources, true);
view(ax3, [90 0]);
title(ax3, 'Side view');

ax4 = nexttile(4);
drawFeatureTable(ax4, P, finalSolids, sources);

sgtitle('MATLAB reconstruction of high\_chiral.m geometry', ...
    'FontSize', 15, 'FontWeight', 'bold');

pngFile = fullfile(outDir, 'high_chiral_geometry_model.png');
figFile = fullfile(outDir, 'high_chiral_geometry_model.fig');
pngFullFile = fullfile(outDir, 'high_chiral_geometry_full_extent.png');
figFullFile = fullfile(outDir, 'high_chiral_geometry_full_extent.fig');
pngSourceFile = fullfile(outDir, 'high_chiral_point_source_in_cavity.png');
figSourceFile = fullfile(outDir, 'high_chiral_point_source_in_cavity.fig');
csvFile = fullfile(outDir, 'high_chiral_geometry_parameters.csv');
sourceCsvFile = fullfile(outDir, 'high_chiral_point_sources.csv');
sourceCheckCsvFile = fullfile(outDir, 'high_chiral_point_source_cavity_check.csv');

exportgraphics(fig, pngFile, 'Resolution', 260);
savefig(fig, figFile);
writetable(solidsToTable(finalSolids), csvFile);
writetable(sourcesToTable(sources), sourceCsvFile);
writetable(sourceCavityCheck(sources, finalSolids), sourceCheckCsvFile);

figFull = figure('Color', 'w', 'Position', [120 80 920 980]);
axFull = axes(figFull);
drawFullOverview(axFull, P, finalSolids, sources);
title(axFull, 'Full COMSOL cylinder extent with final sector solids');
exportgraphics(figFull, pngFullFile, 'Resolution', 260);
savefig(figFull, figFullFile);

figSource = figure('Color', 'w', 'Position', [140 80 1280 760]);
drawSourceCavityFigure(figSource, P, finalSolids, sources);
exportgraphics(figSource, pngSourceFile, 'Resolution', 260);
savefig(figSource, figSourceFile);

fprintf('Geometry reconstruction finished.\n');
fprintf('PNG: %s\n', pngFile);
fprintf('FIG: %s\n', figFile);
fprintf('FULL PNG: %s\n', pngFullFile);
fprintf('FULL FIG: %s\n', figFullFile);
fprintf('SOURCE PNG: %s\n', pngSourceFile);
fprintf('SOURCE FIG: %s\n', figSourceFile);
fprintf('CSV: %s\n', csvFile);
fprintf('SOURCE CSV: %s\n', sourceCsvFile);
fprintf('SOURCE CHECK CSV: %s\n', sourceCheckCsvFile);

%% Local functions
function dx = normToOffset(P, n)
    dx = P.dis_c2_xmin + (P.dis_c2_xmax-P.dis_c2_xmin)*n;
end

function s = annularSectorSolid(name, rIn, rOut, phiStartDeg, widthDeg, z0, z1, color, alphaVal)
    s.name = string(name);
    s.rIn = rIn;
    s.rOut = rOut;
    s.phiStartDeg = phiStartDeg;
    s.widthDeg = widthDeg;
    s.z0 = z0;
    s.z1 = z1;
    s.color = color;
    s.alpha = alphaVal;
    s.note = "";
end

function s = translateSolid(s, dxyz, newName)
    s.z0 = s.z0 + dxyz(3);
    s.z1 = s.z1 + dxyz(3);
    s.name = string(newName);
    s.note = "translated";
end

function s = mirrorZ(s, newName)
    oldZ0 = s.z0;
    oldZ1 = s.z1;
    s.z0 = -oldZ1;
    s.z1 = -oldZ0;
    s.name = string(newName);
    s.alpha = 0.58;
    s.note = "mirror z";
end

function s = rotateZ(s, angleDeg, newName)
    s.phiStartDeg = s.phiStartDeg + angleDeg;
    s.name = string(newName);
    s.note = "rotate z";
end

function q = sourceFromSolid(name, pointId, phaseText, powerRms, isActive, solid)
    phiMid = deg2rad(solid.phiStartDeg + solid.widthDeg/2);
    rMid = 0.5*(solid.rIn + solid.rOut);
    q.name = string(name);
    q.pointId = pointId;
    q.phase = string(phaseText);
    q.powerRms = powerRms;
    q.active = isActive;
    q.x = rMid*cos(phiMid);
    q.y = rMid*sin(phiMid);
    q.z = 0.5*(solid.z0 + solid.z1);
    q.host = solid.name;
end

function drawFinal3D(ax, P, solids, sources, simple)
    hold(ax, 'on');
    axis(ax, 'equal');
    axis(ax, 'off');
    drawDuct(ax, P, simple);
    for k = 1:numel(solids)
        drawSolid(ax, solids(k), simple);
    end
    drawSources(ax, sources, simple);
    light(ax, 'Position', [0.2 -0.4 1.2], 'Style', 'infinite');
    lighting(ax, 'gouraud');
    material(ax, 'dull');
    view(ax, [-37 22]);
    camproj(ax, 'perspective');
    xlim(ax, [-0.120 0.120]);
    ylim(ax, [-0.120 0.120]);
    zAll = [[solids.z0] [solids.z1]];
    zlim(ax, [min(zAll)-0.03 max(zAll)+0.03]);
end

function drawFullOverview(ax, P, solids, sources)
    hold(ax, 'on');
    axis(ax, 'equal');
    axis(ax, 'off');
    th = linspace(0, 2*pi, 180);
    zEnds = [-P.L/2-P.pml, -P.L/2, P.L/2, P.L/2+P.pml];
    for z = zEnds
        plot3(ax, P.R0*cos(th), P.R0*sin(th), z+zeros(size(th)), ...
            '-', 'Color', [0.72 0.76 0.82], 'LineWidth', 0.9);
    end
    for phi = deg2rad(0:45:315)
        plot3(ax, [P.R0*cos(phi) P.R0*cos(phi)], ...
            [P.R0*sin(phi) P.R0*sin(phi)], ...
            [-P.L/2-P.pml P.L/2+P.pml], '-', ...
            'Color', [0.78 0.81 0.86], 'LineWidth', 0.6);
    end
    for k = 1:numel(solids)
        drawSolid(ax, solids(k), true);
    end
    drawSources(ax, sources, true);
    view(ax, [-30 16]);
    xlim(ax, [-0.120 0.120]);
    ylim(ax, [-0.120 0.120]);
    zlim(ax, [-P.L/2-P.pml P.L/2+P.pml]);
end

function drawSourceCavityFigure(figSource, P, solids, sources)
    tiledlayout(figSource, 1, 3, 'TileSpacing', 'compact', 'Padding', 'compact');
    host = findHostSolid(solids, sources.host);

    ax1 = nexttile(1);
    drawHostTop2D(ax1, host, sources);
    title(ax1, 'top view: source inside annular cavity');

    ax2 = nexttile(2);
    drawHostRZ2D(ax2, host, sources);
    title(ax2, 'z-r section: source inside cavity depth');

    ax3 = nexttile(3);
    axis(ax3, 'off');
    C = sourceCavityCheck(sources, solids);
    rows = {
        'Cavity inclusion check'
        sprintf('source: %s, COMSOL point %d', C.Name, C.ComsolPointId)
        sprintf('host cavity: %s', C.HostSolid)
        ''
        sprintf('r_source = %.3f mm', C.R_mm)
        sprintf('r_cavity = %.3f to %.3f mm', C.Rin_mm, C.Rout_mm)
        sprintf('inside r: %d', C.InsideR)
        ''
        sprintf('phi_source = %.3f deg', C.Phi_deg)
        sprintf('phi_cavity = %.3f to %.3f deg', C.PhiStart_deg, C.PhiEnd_deg)
        sprintf('inside phi: %d', C.InsidePhi)
        ''
        sprintf('z_source = %.3f mm', C.Z_mm)
        sprintf('z_cavity = %.3f to %.3f mm', C.Z0_mm, C.Z1_mm)
        sprintf('inside z: %d', C.InsideZ)
        ''
        sprintf('inside cavity volume: %d', C.InsideCavity)
        };
    text(ax3, 0.02, 0.96, rows, 'Units', 'normalized', ...
        'VerticalAlignment', 'top', 'FontName', 'Consolas', ...
        'FontSize', 12, 'Interpreter', 'none');
end

function drawHostTop2D(ax, host, source)
    hold(ax, 'on'); axis(ax, 'equal'); grid(ax, 'on');
    th = deg2rad(linspace(host.phiStartDeg, host.phiStartDeg+host.widthDeg, 100));
    x = [host.rIn*cos(th), fliplr(host.rOut*cos(th))]*1e3;
    y = [host.rIn*sin(th), fliplr(host.rOut*sin(th))]*1e3;
    patch(ax, x, y, host.color, 'FaceAlpha', 0.72, ...
        'EdgeColor', max(0, host.color*0.55), 'LineWidth', 1.2);
    plot(ax, source.x*1e3, source.y*1e3, 'o', ...
        'MarkerFaceColor', [1 0.05 0.02], 'MarkerEdgeColor', [0.15 0 0], ...
        'MarkerSize', 8, 'LineWidth', 1.2);
    text(ax, source.x*1e3+4, source.y*1e3+3, ...
        sprintf('%s P%d', source.name, source.pointId), ...
        'Color', [0.55 0 0], 'FontWeight', 'bold', 'Interpreter', 'none');
    xlabel(ax, 'x (mm)'); ylabel(ax, 'y (mm)');
    pad = 10;
    xlim(ax, [min(x)-pad max(x)+pad]);
    ylim(ax, [min(y)-pad max(y)+pad]);
end

function drawHostRZ2D(ax, host, source)
    hold(ax, 'on'); axis(ax, 'equal'); grid(ax, 'on');
    rectangle(ax, 'Position', [host.z0*1e3, host.rIn*1e3, ...
        (host.z1-host.z0)*1e3, (host.rOut-host.rIn)*1e3], ...
        'FaceColor', host.color, ...
        'EdgeColor', max(0, host.color*0.55), 'LineWidth', 1.4);
    rSource = hypot(source.x, source.y)*1e3;
    plot(ax, source.z*1e3, rSource, 'o', ...
        'MarkerFaceColor', [1 0.05 0.02], 'MarkerEdgeColor', [0.15 0 0], ...
        'MarkerSize', 8, 'LineWidth', 1.2);
    text(ax, source.z*1e3+2, rSource+1.5, ...
        sprintf('%s P%d', source.name, source.pointId), ...
        'Color', [0.55 0 0], 'FontWeight', 'bold', 'Interpreter', 'none');
    xlabel(ax, 'z (mm)'); ylabel(ax, 'r (mm)');
    xlim(ax, [host.z0*1e3-8 host.z1*1e3+12]);
    ylim(ax, [host.rIn*1e3-5 host.rOut*1e3+8]);
end

function drawSources(ax, sources, simple)
    for k = 1:numel(sources)
        if sources(k).active
            markerFace = [1.00 0.05 0.02];
            labelSuffix = "";
        else
            markerFace = [1.00 0.80 0.10];
            labelSuffix = " off";
        end
        scatter3(ax, sources(k).x, sources(k).y, sources(k).z, ...
            ternary(simple, 90, 125), 'o', 'filled', ...
            'MarkerFaceColor', markerFace, ...
            'MarkerEdgeColor', [0.15 0.02 0.02], ...
            'LineWidth', 1.2);
        labelX = sources(k).x + 0.018;
        labelY = sources(k).y + 0.014;
        labelZ = sources(k).z + 0.012;
        plot3(ax, [sources(k).x labelX], [sources(k).y labelY], ...
            [sources(k).z labelZ], '-', 'Color', [0.55 0.00 0.00], ...
            'LineWidth', 1.0);
        text(ax, labelX, labelY, labelZ, ...
            sprintf('%s P%d%s', sources(k).name, sources(k).pointId, labelSuffix), ...
            'Color', [0.55 0.00 0.00], 'FontSize', ternary(simple, 8, 9), ...
            'FontWeight', 'bold', 'HorizontalAlignment', 'center', ...
            'Interpreter', 'none');
    end
end

function host = findHostSolid(solids, hostName)
    names = [solids.name];
    idx = find(names == string(hostName), 1);
    if isempty(idx)
        error('Host solid %s not found.', hostName);
    end
    host = solids(idx);
end

function drawDuct(ax, P, simple)
    nTheta = 96;
    nZ = 2;
    th = linspace(0, 2*pi, nTheta);
    z = linspace(-P.L/2-P.pml, P.L/2+P.pml, nZ);
    [TH, ZZ] = meshgrid(th, z);
    XX = P.R0*cos(TH);
    YY = P.R0*sin(TH);
    surf(ax, XX, YY, ZZ, 'FaceColor', [0.84 0.88 0.94], ...
        'FaceAlpha', ternary(simple, 0.16, 0.23), 'EdgeColor', 'none');
    drawCirclePlane(ax, P.R0, -P.L/2, [0.55 0.58 0.62], 0.25);
    drawCirclePlane(ax, P.R0, P.L/2, [0.55 0.58 0.62], 0.25);
end

function drawCirclePlane(ax, r, z, color, alphaVal)
    th = linspace(0, 2*pi, 160);
    color = color*(1-alphaVal) + [1 1 1]*alphaVal;
    plot3(ax, r*cos(th), r*sin(th), z+zeros(size(th)), ...
        '-', 'Color', color, 'LineWidth', 1.0);
end

function drawSolid(ax, s, simple)
    nTheta = 42;
    th = deg2rad(linspace(s.phiStartDeg, s.phiStartDeg+s.widthDeg, nTheta));
    z = [s.z0 s.z1];
    [TH, ZZ] = meshgrid(th, z);

    drawSurf(ax, s.rOut*cos(TH), s.rOut*sin(TH), ZZ, s, simple);
    drawSurf(ax, s.rIn*cos(TH), s.rIn*sin(TH), ZZ, s, simple);

    [RR, THT] = meshgrid([s.rIn s.rOut], th);
    Z0 = s.z0*ones(size(RR));
    Z1 = s.z1*ones(size(RR));
    drawSurf(ax, RR'.*cos(THT'), RR'.*sin(THT'), Z0', s, simple);
    drawSurf(ax, RR'.*cos(THT'), RR'.*sin(THT'), Z1', s, simple);

    for phi = [th(1), th(end)]
        [RR2, ZZ2] = meshgrid([s.rIn s.rOut], z);
        drawSurf(ax, RR2*cos(phi), RR2*sin(phi), ZZ2, s, simple);
    end
end

function drawSurf(ax, X, Y, Z, s, simple)
    edgeColor = ternary(simple, 'none', [0.08 0.08 0.08]);
    edgeAlpha = ternary(simple, 1.0, 0.16);
    surf(ax, X, Y, Z, 'FaceColor', s.color, 'FaceAlpha', s.alpha, ...
        'EdgeColor', edgeColor, 'EdgeAlpha', edgeAlpha, 'LineWidth', 0.3);
end

function drawFeatureTable(ax, P, solids, sources)
    axis(ax, 'off');
    textLines = {
        'Parameters from high_chiral.m'
        sprintf('D = %.1f mm, R0 = %.1f mm', P.D*1e3, P.R0*1e3)
        sprintf('L = %.1f mm, pml = %.1f mm each side', P.L*1e3, P.pml*1e3)
        sprintf('r1 = %.3f mm, r2 = %.3f mm', P.r1*1e3, P.r2*1e3)
        sprintf('th1 = %.3f deg, th2 = %.3f deg', P.th1, P.th2)
        sprintf('z1 = %.3f mm, z2 = %.3f mm', P.z1*1e3, P.z2*1e3)
        sprintf('zi = %.3f mm, delta_th = %.3f deg', P.zi*1e3, P.delta_th)
        sprintf('xy_theta = %.3f deg', P.xy_theta)
        sprintf('dis_c2_x1 = %.3f mm for ext2', P.dis_c2_x1*1e3)
        sprintf('dis_c2_x2 = %.3f mm for ext1', P.dis_c2_x2*1e3)
        sprintf('dis_c2_x3 = %.3f mm for ext4', P.dis_c2_x3*1e3)
        sprintf('dis_c2_x4 = %.3f mm for ext3', P.dis_c2_x4*1e3)
        ''
        'Final solids drawn'
        };
    for k = 1:numel(solids)
        textLines{end+1} = sprintf('%s: phi %.2f to %.2f deg, z %.2f to %.2f mm', ...
            solids(k).name, solids(k).phiStartDeg, ...
            solids(k).phiStartDeg+solids(k).widthDeg, ...
            solids(k).z0*1e3, solids(k).z1*1e3); %#ok<AGROW>
    end
    textLines{end+1} = ''; %#ok<AGROW>
    textLines{end+1} = 'Active point source from high_chiral.m'; %#ok<AGROW>
    for k = 1:numel(sources)
        textLines{end+1} = sprintf('%s: COMSOL point %d, phase %s, active %d, xyz = [%.2f %.2f %.2f] mm', ...
            sources(k).name, sources(k).pointId, sources(k).phase, ...
            sources(k).active, sources(k).x*1e3, sources(k).y*1e3, sources(k).z*1e3); %#ok<AGROW>
    end
    text(ax, 0.02, 0.98, textLines, 'Units', 'normalized', ...
        'VerticalAlignment', 'top', 'FontName', 'Consolas', ...
        'FontSize', 9.1, 'Interpreter', 'none');
end

function T = solidsToTable(solids)
    n = numel(solids);
    Name = strings(n,1);
    Rin_mm = zeros(n,1);
    Rout_mm = zeros(n,1);
    PhiStart_deg = zeros(n,1);
    PhiEnd_deg = zeros(n,1);
    Z0_mm = zeros(n,1);
    Z1_mm = zeros(n,1);
    Operation = strings(n,1);
    for k = 1:n
        Name(k) = solids(k).name;
        Rin_mm(k) = solids(k).rIn*1e3;
        Rout_mm(k) = solids(k).rOut*1e3;
        PhiStart_deg(k) = solids(k).phiStartDeg;
        PhiEnd_deg(k) = solids(k).phiStartDeg + solids(k).widthDeg;
        Z0_mm(k) = solids(k).z0*1e3;
        Z1_mm(k) = solids(k).z1*1e3;
        Operation(k) = solids(k).note;
    end
    T = table(Name, Rin_mm, Rout_mm, PhiStart_deg, PhiEnd_deg, ...
        Z0_mm, Z1_mm, Operation);
end

function T = sourcesToTable(sources)
    n = numel(sources);
    Name = strings(n,1);
    ComsolPointId = zeros(n,1);
    Phase = strings(n,1);
    PowerRms_W = zeros(n,1);
    Active = false(n,1);
    X_mm = zeros(n,1);
    Y_mm = zeros(n,1);
    Z_mm = zeros(n,1);
    HostSolid = strings(n,1);
    for k = 1:n
        Name(k) = sources(k).name;
        ComsolPointId(k) = sources(k).pointId;
        Phase(k) = sources(k).phase;
        PowerRms_W(k) = sources(k).powerRms;
        Active(k) = sources(k).active;
        X_mm(k) = sources(k).x*1e3;
        Y_mm(k) = sources(k).y*1e3;
        Z_mm(k) = sources(k).z*1e3;
        HostSolid(k) = sources(k).host;
    end
    T = table(Name, ComsolPointId, Phase, PowerRms_W, Active, ...
        X_mm, Y_mm, Z_mm, HostSolid);
end

function T = sourceCavityCheck(sources, solids)
    n = numel(sources);
    Name = strings(n,1);
    ComsolPointId = zeros(n,1);
    HostSolid = strings(n,1);
    R_mm = zeros(n,1);
    Phi_deg = zeros(n,1);
    Z_mm = zeros(n,1);
    Rin_mm = zeros(n,1);
    Rout_mm = zeros(n,1);
    PhiStart_deg = zeros(n,1);
    PhiEnd_deg = zeros(n,1);
    Z0_mm = zeros(n,1);
    Z1_mm = zeros(n,1);
    InsideR = false(n,1);
    InsidePhi = false(n,1);
    InsideZ = false(n,1);
    InsideCavity = false(n,1);
    for k = 1:n
        host = findHostSolid(solids, sources(k).host);
        r = hypot(sources(k).x, sources(k).y);
        phi = atan2d(sources(k).y, sources(k).x);
        if phi < 0
            phi = phi + 360;
        end
        phiStart = mod(host.phiStartDeg, 360);
        phiEnd = mod(host.phiStartDeg + host.widthDeg, 360);

        Name(k) = sources(k).name;
        ComsolPointId(k) = sources(k).pointId;
        HostSolid(k) = host.name;
        R_mm(k) = r*1e3;
        Phi_deg(k) = phi;
        Z_mm(k) = sources(k).z*1e3;
        Rin_mm(k) = host.rIn*1e3;
        Rout_mm(k) = host.rOut*1e3;
        PhiStart_deg(k) = phiStart;
        PhiEnd_deg(k) = phiEnd;
        Z0_mm(k) = host.z0*1e3;
        Z1_mm(k) = host.z1*1e3;
        InsideR(k) = r > host.rIn && r < host.rOut;
        InsidePhi(k) = isAngleInside(phi, phiStart, phiEnd);
        InsideZ(k) = sources(k).z > host.z0 && sources(k).z < host.z1;
        InsideCavity(k) = InsideR(k) && InsidePhi(k) && InsideZ(k);
    end
    T = table(Name, ComsolPointId, HostSolid, R_mm, Rin_mm, Rout_mm, ...
        Phi_deg, PhiStart_deg, PhiEnd_deg, Z_mm, Z0_mm, Z1_mm, ...
        InsideR, InsidePhi, InsideZ, InsideCavity);
end

function tf = isAngleInside(phi, phiStart, phiEnd)
    if phiEnd >= phiStart
        tf = phi > phiStart && phi < phiEnd;
    else
        tf = phi > phiStart || phi < phiEnd;
    end
end

function y = ternary(cond, a, b)
    if cond
        y = a;
    else
        y = b;
    end
end
