function cfg = single_cavity_parameters(varargin)
%SINGLE_CAVITY_PARAMETERS Fixed SI parameters of the independent model.
% No COMSOL object, exported mesh, fitted pole, or TCMT coefficient is used.

cfg.c0 = 343;
cfg.rho0 = 1.21;
cfg.mu = 1.81397e-5;
cfg.gamma = 1.4;
cfg.Cp = 1005.4;
cfg.kappa = 0.02577;

cfg.ductRadius = 0.100;
cfg.ductLength = 1.200;
cfg.pmlLength = 0.300;

% Two annular sectors form one two-layer cavity motif.  The positive-z
% motif is rotated by +10 degrees; its mirror at negative z is not.
cfg.cavity.zCenter = 0.050 + 0.05662041875/2;
cfg.cavity.r1 = 0.045171875;
cfg.cavity.theta1 = 0.767944870877505;
cfg.cavity.height1 = 0.05662041875;
cfg.cavity.r2 = 0.081458978125;
cfg.cavity.theta2 = 0.767944870877505;
cfg.cavity.height2 = 0.024679615625;
cfg.cavity.gapAngle = deg2rad(10);
cfg.cavity.topRotation = deg2rad(10);

cfg.source.xyz = [-0.145171875, 0, -0.10662041875];
cfg.source.powerRMS = 1e-4;
cfg.source.phase = pi;
cfg.probeRadius = cfg.ductRadius;
cfg.probeZ = [-0.5, 0.5];
cfg.probeXYZ = [ ...
    -0.1, 0, -0.5; 0, 0.1, -0.5; 0.1, 0, -0.5; 0,-0.1,-0.5; ...
    -0.1, 0,  0.5; 0, 0.1,  0.5; 0.1, 0,  0.5; 0,-0.1, 0.5];

cfg.targetEigenfrequency = 1479.18182971742;
cfg.driveFrequency = 1479.2;
cfg.numEigenmodes = 10;
cfg.backend = 'fem';
cfg.femOrder = 2;
cfg.useFinitePML = false;
cfg.pmlStretch = 3*(1-1i);
cfg.pmlAxialRefinement = 1;
cfg.pmlOrder = 1;
cfg.useThermoviscous = false;
cfg.tvbLinearizationFrequency = 1500;

cfg.wallLoss = 'none';
cfg.wallLossScale = 1.0;
cfg.outputDir = fullfile(fileparts(mfilename('fullpath')), 'output');
end
