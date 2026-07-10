%% draw_structure_for_discussion
% Draw a parameterized schematic of the bilayer azimuthal acoustic resonator.
% This script is for geometry discussion only; it does not solve acoustics.

clear; clc; close all;

%% Adjustable geometry parameters
cfg.R0 = 50e-3;             % Main tube radius [m]
cfg.rA = 0.01842774646;     % Radial thickness of cavity A [m]
cfg.rB = 0.01596993708;     % Radial thickness of cavity B [m]
cfg.betaA = deg2rad(59.217); % Angular width of cavity A [rad]
cfg.betaB = deg2rad(57.512); % Angular width of cavity B [rad]
cfg.phiA1 = deg2rad(28);    % Cavity A center angle in layer 1 [rad]
cfg.deltaPhiAB = deg2rad(86); % Center-angle distance from A to B [rad]
cfg.twist = deg2rad(10);    % Layer-2 rotation angle around z after xy mirror [rad]
cfg.cavityLengthA = 0.02193599333; % Axial thickness of cavity A [m]
cfg.cavityLengthB = 0.02579109896; % Axial thickness of cavity B [m]
cfg.zA1 = 0.04360763048 + cfg.cavityLengthA/2; % Layer-1 A center z [m]
cfg.zB1 = 0.08778030667 + cfg.cavityLengthB/2; % Layer-1 B center z [m]
cfg.deltaZAB = cfg.zB1 - cfg.zA1; % Axial center distance from A to B [m]
cfg.dz = 2*cfg.zA1;        % A-center mirror distance between layer 1 and layer 2 [m]
cfg.sourceZ = cfg.zA1;      % Point source is inside cavity A [m]
cfg.sourcePhi = cfg.phiA1;  % Point source angular position follows cavity A [rad]
cfg.sourceR = cfg.R0 + 0.55*cfg.rA; % Point source radial location inside cavity A [m]

%% Derived geometry
% Layer 1 contains the original A/B pair and a 180-degree rotated copy.
layer1.zA = cfg.zA1;
layer1.zB = cfg.zB1;
layer1.A = [cfg.phiA1, cfg.phiA1 + pi];
layer1.B = [cfg.phiA1 + cfg.deltaPhiAB, cfg.phiA1 + cfg.deltaPhiAB + pi];

% Layer 2 is obtained by mirroring layer 1 about the xy plane (z -> -z),
% then rotating the mirrored layer around the z axis by cfg.twist.
layer2.zA = -layer1.zA;
layer2.zB = -layer1.zB;
layer2.A = layer1.A + cfg.twist;
layer2.B = layer1.B + cfg.twist;

%% Figure
fig = figure('Color', 'w', 'Position', [80 80 1380 760]);
tiledlayout(fig, 2, 3, 'TileSpacing', 'compact', 'Padding', 'compact');

% Panel 1: Layer 1 cross-section
ax1 = nexttile(1);
drawLayerCrossSection(ax1, cfg, layer1, "Layer 1 cross-section", true);

% Panel 2: Layer 2 cross-section
ax2 = nexttile(2);
drawLayerCrossSection(ax2, cfg, layer2, "Layer 2 cross-section", false);
drawTwistArrow(ax2, cfg.twist);

% Panel 3: overlay
ax3 = nexttile(3);
drawOverlay(ax3, cfg, layer1, layer2);

% Panel 4-5: side view along z
ax4 = nexttile([1 2]);
drawSideView(ax4, cfg, layer1, layer2);

% Panel 6: parameter table
ax5 = nexttile(6);
drawParameterPanel(ax5, cfg);

sgtitle('Bilayer azimuthal resonator schematic for discussion', ...
    'FontSize', 16, 'FontWeight', 'bold');

%% Save outputs
outDir = fullfile(fileparts(mfilename('fullpath')), 'theory_output');
if ~exist(outDir, 'dir')
    mkdir(outDir);
end
pngFile = fullfile(outDir, 'structure_for_discussion.png');
figFile = fullfile(outDir, 'structure_for_discussion.fig');
exportgraphics(fig, pngFile, 'Resolution', 220);
savefig(fig, figFile);

fprintf('Saved figure:\n  %s\n  %s\n', pngFile, figFile);

%% Local functions
function drawLayerCrossSection(ax, cfg, layer, ttl, showSource)
    hold(ax, 'on'); axis(ax, 'equal'); axis(ax, 'off');
    maxR = cfg.R0 + max(cfg.rA, cfg.rB);
    drawCircle(ax, 0, 0, cfg.R0, [0.90 0.93 0.96], [0.15 0.18 0.22], 1.5);
    drawCircle(ax, 0, 0, maxR, 'none', [0.65 0.70 0.76], 0.8, '--');
    for k = 1:numel(layer.A)
        drawAnnularSector(ax, cfg.R0, cfg.R0 + cfg.rA, layer.A(k), cfg.betaA, [0.18 0.56 0.86], 0.88);
        drawAnnularSector(ax, cfg.R0, cfg.R0 + cfg.rB, layer.B(k), cfg.betaB, [0.95 0.66 0.12], 0.90);
        drawRadialLine(ax, layer.A(k), cfg.R0 + cfg.rA, [0.08 0.30 0.55]);
        drawRadialLine(ax, layer.B(k), cfg.R0 + cfg.rB, [0.55 0.35 0.00]);
        if k == 1
            drawAngleArc(ax, 0.50*cfg.R0, layer.A(k), layer.B(k), '\Delta\phi_{AB}');
        end
        text(ax, (cfg.R0+0.5*cfg.rA)*cos(layer.A(k)), (cfg.R0+0.5*cfg.rA)*sin(layer.A(k)), ...
            sprintf('A%d', k), 'FontSize', 11, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
        text(ax, (cfg.R0+0.5*cfg.rB)*cos(layer.B(k)), (cfg.R0+0.5*cfg.rB)*sin(layer.B(k)), ...
            sprintf('B%d', k), 'FontSize', 11, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
    end
    if showSource
        plot(ax, cfg.sourceR*cos(cfg.sourcePhi), cfg.sourceR*sin(cfg.sourcePhi), 'o', ...
            'MarkerFaceColor', [0.86 0.12 0.18], ...
            'MarkerEdgeColor', [0.45 0.05 0.08], 'MarkerSize', 6);
        text(ax, 0.02, -maxR*1.10, 'point source inside cavity A', 'FontSize', 9, ...
            'HorizontalAlignment', 'center', 'Color', [0.35 0.35 0.35]);
    end
    text(ax, 0, maxR*1.20, ttl, 'FontSize', 12, 'FontWeight', 'bold', ...
        'HorizontalAlignment', 'center');
    lim = maxR*1.35;
    xlim(ax, [-lim lim]); ylim(ax, [-lim lim]);
end

function drawOverlay(ax, cfg, layer1, layer2)
    hold(ax, 'on'); axis(ax, 'equal'); axis(ax, 'off');
    maxR = cfg.R0 + max(cfg.rA, cfg.rB);
    drawCircle(ax, 0, 0, cfg.R0, [0.93 0.95 0.97], [0.15 0.18 0.22], 1.5);
    for k = 1:numel(layer1.A)
        drawAnnularSector(ax, cfg.R0, cfg.R0 + cfg.rA, layer1.A(k), cfg.betaA, [0.18 0.56 0.86], 0.85);
        drawAnnularSector(ax, cfg.R0, cfg.R0 + cfg.rB, layer1.B(k), cfg.betaB, [0.95 0.66 0.12], 0.88);
        drawAnnularSector(ax, cfg.R0, cfg.R0 + cfg.rA, layer2.A(k), cfg.betaA, [0.18 0.56 0.86], 0.35);
        drawAnnularSector(ax, cfg.R0, cfg.R0 + cfg.rB, layer2.B(k), cfg.betaB, [0.95 0.66 0.12], 0.38);
    end
    drawAngleArc(ax, 0.72*cfg.R0, layer1.A(1), layer2.A(1), '\theta=10^\circ');
    text(ax, 0, maxR*1.20, 'two-layer angular overlay', 'FontSize', 12, ...
        'FontWeight', 'bold', 'HorizontalAlignment', 'center');
    text(ax, -maxR*1.16, -maxR*1.10, 'solid: layer 1', 'FontSize', 9);
    text(ax, -maxR*1.16, -maxR*1.25, 'transparent: layer 2', 'FontSize', 9);
    lim = maxR*1.35;
    xlim(ax, [-lim lim]); ylim(ax, [-lim lim]);
end

function drawSideView(ax, cfg, layer1, layer2)
    hold(ax, 'on'); axis(ax, 'off');
    allZ = [cfg.sourceZ, layer1.zA, layer1.zB, layer2.zA, layer2.zB];
    zMin = min(allZ) - 0.08;
    zMax = max(allZ) + 0.12;
    R = cfg.R0;
    rectangle(ax, 'Position', [zMin, -R, zMax-zMin, 2*R], ...
        'Curvature', 0.10, 'FaceColor', [0.93 0.95 0.97], ...
        'EdgeColor', [0.15 0.18 0.22], 'LineWidth', 1.5);
    plot(ax, [zMin zMax], [0 0], '--', 'Color', [0.60 0.65 0.70], 'LineWidth', 1.0);
    drawSideCavity(ax, layer1.zA, +R, cfg.cavityLengthA, cfg.rA, [0.18 0.56 0.86], 'A1');
    drawSideCavity(ax, layer1.zB, -R, cfg.cavityLengthB, cfg.rB, [0.95 0.66 0.12], 'B1');
    drawSideCavity(ax, layer2.zA, +R, cfg.cavityLengthA, cfg.rA, [0.18 0.56 0.86], 'A2');
    drawSideCavity(ax, layer2.zB, -R, cfg.cavityLengthB, cfg.rB, [0.95 0.66 0.12], 'B2');
    plot(ax, cfg.sourceZ, R + 0.55*cfg.rA, 'o', 'MarkerFaceColor', [0.86 0.12 0.18], ...
        'MarkerEdgeColor', [0.45 0.05 0.08], 'MarkerSize', 7);
    text(ax, cfg.sourceZ, R + 0.55*cfg.rA + 0.012, 'point source in A', 'FontSize', 9, ...
        'HorizontalAlignment', 'center');
    annotationText = sprintf('A-B axial offset = %.1f mm;  twist \\theta = %.1f deg', ...
        cfg.deltaZAB*1e3, rad2deg(cfg.twist));
    text(ax, mean([layer1.zA, layer1.zB, layer2.zA, layer2.zB]), R+max(cfg.rA,cfg.rB)+0.020, annotationText, ...
        'FontSize', 11, 'HorizontalAlignment', 'center', 'FontWeight', 'bold');
    quiver(ax, zMin, -R-0.050, zMax-zMin, 0, 0, 'Color', [0.12 0.15 0.18], ...
        'LineWidth', 1.4, 'MaxHeadSize', 0.08);
    text(ax, zMax, -R-0.062, 'z', 'FontSize', 11);
    title(ax, 'side view along propagation direction', 'FontSize', 12);
    xlim(ax, [zMin zMax]);
    ylim(ax, [-R-max(cfg.rA,cfg.rB)-0.06, R+max(cfg.rA,cfg.rB)+0.06]);
end

function drawParameterPanel(ax, cfg)
    axis(ax, 'off');
    lines = {
        'Editable parameters'
        sprintf('R0 = %.1f mm', cfg.R0*1e3)
        sprintf('rA = %.1f mm,  rB = %.1f mm', cfg.rA*1e3, cfg.rB*1e3)
        sprintf('\\beta_A = %.1f deg,  \\beta_B = %.1f deg', rad2deg(cfg.betaA), rad2deg(cfg.betaB))
        sprintf('\\Delta\\phi_{AB} = %.1f deg', rad2deg(cfg.deltaPhiAB))
        sprintf('\\Delta z_{AB} = %.3f mm', cfg.deltaZAB*1e3)
        'Layer 1: AB + rot_z(180 deg) AB'
        sprintf('Layer 2: mirror_{xy}(Layer 1), then rot_z(%.1f deg)', rad2deg(cfg.twist))
        sprintf('A-center mirror distance = %.1f mm', cfg.dz*1e3)
        'Point source: inside cavity A'
        ''
        'Discussion targets'
        '1. Are A/B positions correct?'
        '2. Are A/B shapes cavity-like or sector-like?'
        '3. Does layer 2 rotate this way?'
        '4. Should the source be on-axis or off-axis?'
        };
    text(ax, 0.02, 0.96, lines, 'Units', 'normalized', 'VerticalAlignment', 'top', ...
        'FontSize', 11, 'Interpreter', 'tex');
end

function drawCircle(ax, x0, y0, r, faceColor, edgeColor, lineWidth, lineStyle)
    if nargin < 8
        lineStyle = '-';
    end
    th = linspace(0, 2*pi, 361);
    h = patch(ax, x0 + r*cos(th), y0 + r*sin(th), [1 1 1], ...
        'EdgeColor', edgeColor, 'LineWidth', lineWidth, 'LineStyle', lineStyle);
    set(h, 'FaceColor', faceColor);
end

function drawAnnularSector(ax, rIn, rOut, phiCtr, beta, color, alphaVal)
    th1 = phiCtr - beta/2;
    th2 = phiCtr + beta/2;
    th = linspace(th1, th2, 60);
    x = [rIn*cos(th), fliplr(rOut*cos(th))];
    y = [rIn*sin(th), fliplr(rOut*sin(th))];
    patch(ax, x, y, color, 'FaceAlpha', alphaVal, ...
        'EdgeColor', max(0, color*0.55), 'LineWidth', 1.4);
end

function drawRadialLine(ax, phi, r, color)
    plot(ax, [0 r*cos(phi)], [0 r*sin(phi)], '-', 'Color', color, 'LineWidth', 1.0);
end

function drawAngleArc(ax, r, phi1, phi2, labelText)
    phi2 = unwrapAngleNear(phi2, phi1);
    th = linspace(phi1, phi2, 80);
    plot(ax, r*cos(th), r*sin(th), '-', 'Color', [0.15 0.16 0.18], 'LineWidth', 1.2);
    mid = 0.5*(phi1 + phi2);
    text(ax, 1.10*r*cos(mid), 1.10*r*sin(mid), labelText, 'FontSize', 11, ...
        'HorizontalAlignment', 'center', 'Interpreter', 'tex');
end

function val = unwrapAngleNear(val, ref)
    while val - ref > pi
        val = val - 2*pi;
    end
    while val - ref < -pi
        val = val + 2*pi;
    end
end

function drawTwistArrow(ax, twist)
    text(ax, 0, -0.115, sprintf('\\theta = %.1f^\\circ', rad2deg(twist)), ...
        'FontSize', 11, 'HorizontalAlignment', 'center', 'Interpreter', 'tex');
end

function drawSideCavity(ax, zc, wallR, len, radialDepth, color, labelText)
    z0 = zc - len/2;
    y0 = wallR;
    if wallR > 0
        pos = [z0, y0, len, radialDepth];
        labelY = y0 + 0.5*radialDepth;
    else
        pos = [z0, y0-radialDepth, len, radialDepth];
        labelY = y0 - 0.5*radialDepth;
    end
    rectangle(ax, 'Position', pos, 'FaceColor', color, 'FaceAlpha', 0.78, ...
        'EdgeColor', max(0, color*0.55), 'LineWidth', 1.2, 'Curvature', 0.08);
    text(ax, zc, labelY, labelText, 'FontSize', 9, 'FontWeight', 'bold', ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
end
