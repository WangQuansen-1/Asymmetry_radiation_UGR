function cfg = single_sector2_parameters(varargin)
%SINGLE_SECTOR2_PARAMETERS Exact parameters and modal truncation for sector 2.
%
%   cfg = SINGLE_SECTOR2_PARAMETERS()
%   cfg = SINGLE_SECTOR2_PARAMETERS(Name,Value,...)
%
% This file describes one annular-sector side cavity coupled to an otherwise
% uniform circular hard-wall duct.  It contains no mesh and no fitted
% quantities.  The aperture is r=a, 0<=thetaLocal<=beta, 0<=zLocal<=Lz.
%
% Supported truncation overrides (all non-negative integers except the
% quadrature orders):
%   'CavityAngularMax'   maximum s in cos(s*pi*theta/beta), default 8
%   'CavityAxialMax'     maximum t in cos(t*pi*z/Lz),       default 6
%   'DuctAzimuthalMax'   retain -M<=m<=M,                  default 10
%   'DuctRadialCount'    radial branches retained per m,   default 6
%   'ThetaQuadratureOrder' Gauss order on the sector,      default 80
%   'ZQuadratureOrder'     Gauss order along the aperture, default 72
%   'Theta0'             global angular start of sector,   default 0
%
% Duct radial indexing convention:
%   m=0:  n=0 is the plane mode, followed by positive zeros of J_0'.
%   m~=0: n=0 is the first positive zero of J_|m|'.

    cfg = struct();
    cfg.model = 'single annular-sector cavity 2';

    % Exact geometry requested for the one-sector theory model [SI units].
    cfg.a     = 0.100000000000;
    cfg.b     = 0.181458978125;
    cfg.beta  = deg2rad(44.0);
    cfg.Lz    = 0.024679615625;
    cfg.theta0 = 0.0;
    cfg.apertureZStart = 0.0659704015625;

    % The COMSOL TXT is a finite-domain eigenproblem: a 1.2 m physical
    % circular duct terminated by 0.3 m polynomial PMLs at both ends.
    % In an eigenfrequency study the typical wavelength equals the PML
    % width; curvature=1 therefore gives the constant analytic stretch.
    cfg.ductTermination = 'finitePML';
    cfg.ductPhysicalLength = 1.2;
    cfg.pmlLength = 0.3;
    cfg.pmlStretch = 3*(1-1i);
    cfg.probeZ = [-0.5,0.5];

    % Lossless homogeneous air.  No empirical correction is present.
    cfg.c0   = 343.0;
    cfg.rho0 = 1.21;
    cfg.timeConvention = 'exp(+i*omega*t)';

    % Modal (spectral) truncations.  Convergence must be checked by raising
    % these integers; they are not calibration parameters.
    cfg.cavityAngularMax = 8;
    cfg.cavityAxialMax = 6;
    cfg.ductAzimuthalMax = 10;
    cfg.ductRadialCount = 6;
    cfg.thetaQuadratureOrder = 80;
    cfg.zQuadratureOrder = 72;

    cfg = applyNameValueOverrides(cfg, varargin{:});
    validateConfiguration(cfg);

    % Orthonormal aperture basis with surface measure dS=a*dtheta*dz:
    % chi_st = Theta_s(theta)*Z_t(z)/sqrt(a).
    s = (0:cfg.cavityAngularMax).';
    t = (0:cfg.cavityAxialMax).';
    [sGrid,tGrid] = ndgrid(s,t); % s is the fastest-running matrix index.
    cfg.aperture.s = sGrid(:);
    cfg.aperture.t = tGrid(:);
    cfg.aperture.count = numel(sGrid);
    cfg.aperture.angularOrder = (pi/cfg.beta)*s;
    cfg.aperture.axialWavenumber = (pi/cfg.Lz)*t;
    cfg.aperture.indexFormula = 'index = (s+1) + (Smax+1)*t';

    % Gaussian integration is used only for exact modal-overlap operators;
    % it is not a finite-element mesh or a spatial field discretization.
    [xTheta,wTheta] = gaussLegendre(cfg.thetaQuadratureOrder,0,cfg.beta);
    [xZ,wZ] = gaussLegendre(cfg.zQuadratureOrder,0,cfg.Lz);
    thetaBasis = cos(xTheta*(s.'*pi/cfg.beta));
    thetaBasis = thetaBasis .* sqrt((2-(s.'==0))/cfg.beta);
    zBasis = cos(xZ*(t.'*pi/cfg.Lz));
    zBasis = zBasis .* sqrt((2-(t.'==0))/cfg.Lz);

    cfg.quadrature.thetaLocal = xTheta;
    cfg.quadrature.thetaWeight = wTheta;
    cfg.quadrature.zLocal = xZ;
    cfg.quadrature.zWeight = wZ;
    cfg.quadrature.thetaBasis = thetaBasis;
    cfg.quadrature.zBasis = zBasis;

    % Normalized hard-wall circular-duct modes
    % psi_mn = C_mn*J_|m|(alpha_mn*r)*exp(i*m*theta),
    % integral_A |psi_mn|^2 dA = 1 and J_|m|'(alpha_mn*a)=0.
    M = cfg.ductAzimuthalMax;
    Nr = cfg.ductRadialCount;
    modeCount = (2*M+1)*Nr;
    ductM = zeros(modeCount,1);
    ductN = zeros(modeCount,1);
    root = zeros(modeCount,1);
    radialNorm = zeros(modeCount,1);
    wallValue = zeros(modeCount,1);
    cursor = 0;

    for m = -M:M
        ell = abs(m);
        if m == 0
            positiveRoots = neumannBesselRoots(ell,max(Nr-1,0));
            rootsForM = [0; positiveRoots(:)];
        else
            rootsForM = neumannBesselRoots(ell,Nr);
        end

        for nLocal = 0:Nr-1
            cursor = cursor + 1;
            x = rootsForM(nLocal+1);
            if x == 0
                radialIntegral = cfg.a^2/2;
            else
                jm = besselj(ell,x);
                radialIntegral = (cfg.a^2/2) * ...
                    (jm^2-besselj(ell-1,x)*besselj(ell+1,x));
            end
            C = 1/sqrt(2*pi*radialIntegral);

            ductM(cursor) = m;
            ductN(cursor) = nLocal;
            root(cursor) = x;
            radialNorm(cursor) = C;
            wallValue(cursor) = C*besselj(ell,x);
        end
    end

    cfg.duct.m = ductM;
    cfg.duct.n = ductN;
    cfg.duct.neumannRoot = root;
    cfg.duct.alpha = root/cfg.a;
    cfg.duct.radialNormalization = radialNorm;
    cfg.duct.wallValue = wallValue;
    cfg.duct.count = modeCount;
    cfg.duct.normalization = 'integral_A abs(psi_mn)^2 dA = 1';

    % B(s,mn)=sqrt(a)*integral_sector Theta_s(thetaLocal)*
    %                          psi_mn(a,thetaGlobal) dtheta.
    thetaGlobal = cfg.theta0+xTheta;
    psiWall = exp(1i*thetaGlobal*(ductM.')) .* (wallValue.');
    cfg.overlap.angular = sqrt(cfg.a) * ...
        (thetaBasis.' * (wTheta .* psiWall));

    % Fundamental propagating channels requested for radiation readout.
    requestedM = [1,0,-1];
    requestedIndex = zeros(size(requestedM));
    for j = 1:numel(requestedM)
        requestedIndex(j) = find(ductM==requestedM(j) & ductN==0,1,'first');
    end
    cfg.radiation.globalMOrder = requestedM;
    cfg.radiation.ductModeIndex = requestedIndex;
    cfg.radiation.note = [ ...
        'At the lower (-z) port, propagation-referenced m has the ', ...
        'opposite sign to global-coordinate m.'];
end


function cfg = applyNameValueOverrides(cfg,varargin)
    if mod(numel(varargin),2) ~= 0
        error('single_sector2_parameters:NameValue', ...
            'Optional inputs must be Name,Value pairs.');
    end
    valid = fieldnames(cfg);
    for k = 1:2:numel(varargin)
        name = char(string(varargin{k}));
        idx = find(strcmpi(name,valid),1);
        if isempty(idx)
            error('single_sector2_parameters:UnknownOption', ...
                'Unknown option "%s".',name);
        end
        cfg.(valid{idx}) = varargin{k+1};
    end
end


function validateConfiguration(cfg)
    positiveScalars = {'a','b','beta','Lz','c0','rho0'};
    for k = 1:numel(positiveScalars)
        value = cfg.(positiveScalars{k});
        if ~(isnumeric(value) && isscalar(value) && isfinite(value) && value>0)
            error('single_sector2_parameters:InvalidValue', ...
                '%s must be a positive finite scalar.',positiveScalars{k});
        end
    end
    if cfg.b <= cfg.a
        error('single_sector2_parameters:Geometry','b must be greater than a.');
    end
    integerFields = {'cavityAngularMax','cavityAxialMax', ...
        'ductAzimuthalMax','ductRadialCount'};
    for k = 1:numel(integerFields)
        value = cfg.(integerFields{k});
        lower = double(strcmp(integerFields{k},'ductRadialCount'));
        if ~(isnumeric(value) && isscalar(value) && isfinite(value) && ...
                value==fix(value) && value>=lower)
            error('single_sector2_parameters:InvalidTruncation', ...
                '%s has an invalid value.',integerFields{k});
        end
    end
    quadratureFields = {'thetaQuadratureOrder','zQuadratureOrder'};
    for k = 1:numel(quadratureFields)
        value = cfg.(quadratureFields{k});
        if ~(isnumeric(value) && isscalar(value) && value==fix(value) && value>=8)
            error('single_sector2_parameters:InvalidQuadrature', ...
                '%s must be an integer not smaller than 8.',quadratureFields{k});
        end
    end
end


function rootsOut = neumannBesselRoots(order,count)
% Positive zeros of dJ_order(x)/dx, found once during modal preprocessing.
    rootsOut = zeros(count,1);
    if count == 0
        return;
    end

    derivative = @(x) 0.5*(besselj(order-1,x)-besselj(order+1,x));
    step = pi/24;
    xLeft = 1e-7;
    fLeft = derivative(xLeft);
    found = 0;
    iterations = 0;
    maxIterations = 200000;

    while found < count && iterations < maxIterations
        xRight = xLeft+step;
        fRight = derivative(xRight);
        if isfinite(fLeft) && isfinite(fRight) && fLeft*fRight < 0
            candidate = fzero(derivative,[xLeft,xRight]);
            if candidate>1e-6 && ...
                    (found==0 || abs(candidate-rootsOut(found))>1e-7)
                found = found+1;
                rootsOut(found) = candidate;
            end
        end
        xLeft = xRight;
        fLeft = fRight;
        iterations = iterations+1;
    end

    if found ~= count
        error('single_sector2_parameters:BesselRoots', ...
            'Could not find %d positive roots of J_%d''.',count,order);
    end
end


function [x,w] = gaussLegendre(n,a,b)
% Golub-Welsch Gauss-Legendre nodes and weights on [a,b].
    j = (1:n-1).';
    offDiagonal = j./sqrt(4*j.^2-1);
    Jacobi = diag(offDiagonal,1)+diag(offDiagonal,-1);
    [vectors,values] = eig(Jacobi,'vector');
    [nodes,order] = sort(values);
    weights = 2*(vectors(1,order).').^2;
    x = (a+b)/2+(b-a)*nodes/2;
    w = (b-a)*weights/2;
end
