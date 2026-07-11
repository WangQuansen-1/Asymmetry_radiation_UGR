function cfg = prototype_parameters(resolution)
%PROTOTYPE_PARAMETERS Fixed parameters extracted once from 原型.mph.
% This file has no COMSOL dependency. All values are SI unless noted.

    if nargin < 1
        resolution = 'standard';
    end

    % PDE material values at 293.15 K (Air, from_mat in the saved model).
    cfg.c0 = 343.2035820928282;
    cfg.rho0 = 1.204317574535839;
    % The model's custom Ez/Ef definitions deliberately use these global
    % constants instead of the material values.
    cfg.outputC0 = 343;
    cfg.outputRho0 = 1.21;
    cfg.gammaAir = 1.4;
    cfg.dynamicViscosity = 1.813968630733944e-5; % Pa*s
    cfg.thermalConductivity = 0.02576818523619658; % W/(m*K)
    cfg.Cp = 1005.422071127131;          % J/(kg*K)
    cfg.temperature = 293.15;            % K, fixed model input
    cfg.thermalExpansion = 0.003411222923418045; % 1/K

    cfg.D = 0.100;
    cfg.a = cfg.D/2;
    cfg.L = 0.600;
    cfg.pml = 0.150;                     %#ok<STRNU> comparison metadata
    cfg.freq = (2582.5:1:2622.5).';
    cfg.sourcePower = 1e-4;              % free-space reference RMS power [W]

    % Active annular-sector geometry.
    cfg.geom.r1 = 0.0248017583333333;
    cfg.geom.theta1 = deg2rad(113.7323);
    cfg.geom.z1 = 0.0110187320833333;
    cfg.geom.r2 = 0.0242167289583333;
    cfg.geom.theta2 = deg2rad(20.10412);
    cfg.geom.z2 = 0.0254521720833333;
    cfg.geom.deltaTheta = deg2rad(10);
    cfg.geom.twist = deg2rad(10);
    cfg.geom.zi = 0.050;

    % Point source selected by mps2, entity point 7.
    cfg.source.xyz = [-0.0599178049503, 0.0437947429176, -0.0682354520833];
    cfg.source.r = hypot(cfg.source.xyz(1),cfg.source.xyz(2));
    cfg.source.theta = atan2(cfg.source.xyz(2),cfg.source.xyz(1));
    cfg.source.z = cfg.source.xyz(3);
    cfg.source.phase = 0;

    % The exact point-probe coordinates from the model. Rows 1:4 are Ez,
    % rows 5:8 are Ef. The DFT uses the model's probe ordering separately.
    cfg.probes.xyz = [ ...
        -0.05, 0, -0.25; 0, 0.05, -0.25; 0.05, 0, -0.25; 0,-0.05,-0.25; ...
        -0.05, 0,  0.25; 0, 0.05,  0.25; 0.05, 0,  0.25; 0,-0.05, 0.25];
    cfg.zLower = -0.25;
    cfg.zUpper = 0.25;
    cfg.probeActualTheta = [pi, pi/2, 0, -pi/2];
    cfg.probeModelTheta = [0, pi/2, pi, 3*pi/2];

    cfg.outputDir = fullfile(fileparts(mfilename('fullpath')),'output');
    cfg.matrixRegularization = 1e-10;
    cfg.useParallel = true;
    cfg.parallelWorkers = 8;

    switch lower(char(resolution))
        case 'quick'
            cfg.resolution = 'quick';
            cfg.num.quadTheta = 6;
            cfg.num.quadZ = 4;
            cfg.num.apertureAngularMax = 2;
            cfg.num.apertureAxialMax = 1;
            cfg.num.cavityAngularMax = 4;
            cfg.num.cavityAxialMax = 3;
            cfg.num.cavityRadialMax = 5;
            cfg.num.cavityQuadRadial = 14;
            cfg.num.ductM = 5;
            cfg.num.ductRadialRoots = 4;
        case 'standard'
            cfg.resolution = 'standard';
            cfg.num.quadTheta = 20;
            cfg.num.quadZ = 14;
            cfg.num.apertureAngularMax = 5;
            cfg.num.apertureAxialMax = 4;
            cfg.num.cavityAngularMax = 6;
            cfg.num.cavityAxialMax = 4;
            cfg.num.cavityRadialMax = 9;
            cfg.num.cavityQuadRadial = 24;
            cfg.num.ductM = 12;
            cfg.num.ductRadialRoots = 12;
        case 'high'
            cfg.resolution = 'high';
            cfg.num.quadTheta = 16;
            cfg.num.quadZ = 12;
            cfg.num.apertureAngularMax = 4;
            cfg.num.apertureAxialMax = 3;
            cfg.num.cavityAngularMax = 8;
            cfg.num.cavityAxialMax = 6;
            cfg.num.cavityRadialMax = 12;
            cfg.num.cavityQuadRadial = 28;
            cfg.num.ductM = 20;
            cfg.num.ductRadialRoots = 20;
        otherwise
            error('Unknown resolution: %s',resolution);
    end
end
