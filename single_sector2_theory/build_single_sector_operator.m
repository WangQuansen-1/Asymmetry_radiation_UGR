function [A,Ycav,Gduct,pre] = build_single_sector_operator(omega,cfg)
%BUILD_SINGLE_SECTOR_OPERATOR Analytic mode-matching operator for sector 2.
%
% [A,Ycav,Gduct,pre] = BUILD_SINGLE_SECTOR_OPERATOR(omega,cfg)
%
% omega is one angular frequency [rad/s], possibly complex, and cfg is
% returned by SINGLE_SECTOR2_PARAMETERS.  With exp(+i*omega*t), q denotes
% coefficients of aperture pressure and v=Ycav*q denotes radial (+r)
% particle-velocity coefficients.  The outgoing circular-duct Green
% operator gives q=Gduct*v, hence an eigenfrequency satisfies
%
%                    A(omega)*q = 0,
%        A = I - Gduct*Ycav.
%
% This is a spectral mode-matching calculation, not FEM and not TCMT.
% No loss, fitting coefficient, frequency correction, or PML is used.
%
% Radiation example after finding a right null vector q:
%   v = Ycav*q;
%   pu = pre.radiation.upperGlobalM.velocityMap*v;
%   Eu = pre.radiation.upperGlobalM.powerWeight.*abs(pu).^2;
%   upperFractions = Eu/sum(Eu); % order m=[+1,0,-1]
% The analogous lowerGlobalM fields give the lower-port result.  If m is
% defined looking along each outgoing propagation direction, use the
% upperPropagationM/lowerPropagationM fields instead.

    if nargin < 2 || isempty(cfg)
        cfg = single_sector2_parameters();
    end
    if ~(isnumeric(omega) && isscalar(omega) && isfinite(real(omega)) && ...
            isfinite(imag(omega)) && omega~=0)
        error('build_single_sector_operator:Omega', ...
            'omega must be one finite, nonzero angular frequency.');
    end
    required = {'a','b','beta','Lz','c0','rho0','aperture', ...
        'quadrature','duct','overlap','radiation'};
    for j = 1:numel(required)
        if ~isfield(cfg,required{j})
            error('build_single_sector_operator:Configuration', ...
                'cfg is missing field %s; call single_sector2_parameters.', ...
                required{j});
        end
    end

    k = omega/cfg.c0;
    apertureCount = cfg.aperture.count;
    sIndex = cfg.aperture.s;
    tIndex = cfg.aperture.t;

    % Exact separated annular-sector cavity DtN.  For each (s,t), radial
    % order nu=s*pi/beta and kappa^2=k^2-(t*pi/Lz)^2.  The radial Bessel
    % combination obeys dR/dr=0 at the hard outer wall r=b and R(a)=1.
    radialDerivative = complex(zeros(apertureCount,1));
    for j = 1:apertureCount
        nu = sIndex(j)*pi/cfg.beta;
        axialNumber = tIndex(j)*pi/cfg.Lz;
        kappa = sqrt(k^2-axialNumber^2);
        radialDerivative(j) = annularSectorDtN( ...
            nu,kappa,cfg.a,cfg.b);
    end

    % exp(+i*omega*t): v = -grad(p)/(i*rho*omega).
    Ycav = diag(-radialDerivative/(1i*cfg.rho0*omega));

    % Outgoing hard-wall circular-duct Green operator.  The axial kernel is
    % exp(-i*kz*abs(z-z')) and kz uses the outgoing sheet: positive real for
    % open modes and negative imaginary for closed modes.
    alpha = cfg.duct.alpha;
    ductCount = cfg.duct.count;
    kz = complex(zeros(ductCount,1));
    Gduct = complex(zeros(apertureCount));
    B = cfg.overlap.angular;
    zLocal = cfg.quadrature.zLocal;
    z = cfg.apertureZStart+zLocal;
    wz = cfg.quadrature.zWeight;
    Z = cfg.quadrature.zBasis;
    weightedZ = wz.*Z;

    for d = 1:ductCount
        kz(d) = outgoingAxialWavenumber(k,alpha(d));
        if abs(kz(d))*cfg.a < 1e-11
            error('build_single_sector_operator:Cutoff', ...
                ['omega lies at a retained circular-duct cutoff.  The ', ...
                 'lossless Green operator has a true branch singularity.']);
        end
        if strcmpi(cfg.ductTermination,'finitePML')
            zLeft=-cfg.ductPhysicalLength/2-cfg.pmlStretch*cfg.pmlLength;
            zRight=cfg.ductPhysicalLength/2+cfg.pmlStretch*cfg.pmlLength;
            zMin=min(z,z.');zMax=max(z,z.');
            denom=kz(d)*sin(kz(d)*(zRight-zLeft));
            green=cos(kz(d)*(zMin-zLeft)).*cos(kz(d)*(zRight-zMax))/denom;
            axialKernel=weightedZ.'*(1i*cfg.rho0*omega*green)*weightedZ;
            coefficient=1;
        else
            phase = exp(-1i*kz(d)*abs(z-z.'));
            axialKernel = weightedZ.'*phase*weightedZ;
            coefficient = -cfg.rho0*omega/(2*kz(d));
        end
        angularKernel = B(:,d)*B(:,d)';
        Gduct = Gduct + coefficient*kron(axialKernel,angularKernel);
    end
    A = eye(apertureCount)-Gduct*Ycav;

    % Maps from aperture velocity to every outgoing normalized duct-mode
    % pressure amplitude, evaluated at z=0 (lower) and z=Lz (upper).
    lowerMap = complex(zeros(ductCount,apertureCount));
    upperMap = complex(zeros(ductCount,apertureCount));
    for d = 1:ductCount
        if strcmpi(cfg.ductTermination,'finitePML')
            zLeft=-cfg.ductPhysicalLength/2-cfg.pmlStretch*cfg.pmlLength;
            zRight=cfg.ductPhysicalLength/2+cfg.pmlStretch*cfg.pmlLength;
            lowerGreen=finiteAxialGreen(cfg.probeZ(1),z,kz(d),zLeft,zRight);
            upperGreen=finiteAxialGreen(cfg.probeZ(2),z,kz(d),zLeft,zRight);
            lowerAxial=Z.'*(wz.*lowerGreen);
            upperAxial=Z.'*(wz.*upperGreen);
            coefficient=1i*cfg.rho0*omega;
        else
            lowerAxial = Z.'*(wz.*exp(-1i*kz(d)*zLocal));
            upperAxial = Z.'*(wz.*exp(-1i*kz(d)*(cfg.Lz-zLocal)));
            coefficient = -cfg.rho0*omega/(2*kz(d));
        end
        sourceAngular = conj(B(:,d)).';
        lowerMap(d,:) = coefficient*kron(lowerAxial.',sourceAngular);
        upperMap(d,:) = coefficient*kron(upperAxial.',sourceAngular);
    end

    % Time-averaged outward power for a normalized propagating duct mode is
    % Re(kz)/(2*rho0*omega)*|P_mn|^2 at the real oscillation frequency.
    omegaPower = abs(real(omega));
    powerWeight = zeros(ductCount,1);
    if omegaPower > 0
        openValue = (omegaPower/cfg.c0)^2-alpha.^2;
        open = openValue>0;
        powerWeight(open) = sqrt(openValue(open))/(2*cfg.rho0*omegaPower);
    end

    globalOrder = cfg.radiation.globalMOrder; % [+1,0,-1]
    globalRows = cfg.radiation.ductModeIndex;
    propagationLowerOrder = -globalOrder;
    propagationLowerRows = zeros(size(globalRows));
    for j = 1:numel(globalRows)
        propagationLowerRows(j) = find(cfg.duct.m==propagationLowerOrder(j) ...
            & cfg.duct.n==0,1,'first');
    end

    pre = struct();
    pre.omega = omega;
    pre.frequency = omega/(2*pi);
    pre.wavenumber = k;
    pre.aperture.s = sIndex;
    pre.aperture.t = tIndex;
    pre.aperture.indexFormula = cfg.aperture.indexFormula;
    pre.cavity.radialDtN = radialDerivative;
    pre.cavity.definition = 'dp/dr at r=a = radialDtN .* aperture pressure';
    pre.duct.m = cfg.duct.m;
    pre.duct.n = cfg.duct.n;
    pre.duct.alpha = alpha;
    pre.duct.kz = kz;
    pre.duct.angularOverlap = B;
    pre.duct.lowerVelocityMapAllModes = lowerMap;
    pre.duct.upperVelocityMapAllModes = upperMap;
    pre.duct.powerWeightAllModes = powerWeight;
    pre.duct.termination = cfg.ductTermination;

    pre.radiation.channelOrder = globalOrder;
    pre.radiation.upperGlobalM = radiationBlock( ...
        globalOrder,globalRows,upperMap,Ycav,powerWeight);
    pre.radiation.lowerGlobalM = radiationBlock( ...
        globalOrder,globalRows,lowerMap,Ycav,powerWeight);
    pre.radiation.upperPropagationM = pre.radiation.upperGlobalM;
    pre.radiation.lowerPropagationM = radiationBlock( ...
        globalOrder,propagationLowerRows,lowerMap,Ycav,powerWeight);
    pre.radiation.convention = [ ...
        'Global m uses exp(i*m*theta). Propagation-referenced lower-port ', ...
        'm reverses the global-m sign.'];
end

function g=finiteAxialGreen(zObs,zSource,kz,zLeft,zRight)
    zMin=min(zObs,zSource);zMax=max(zObs,zSource);
    g=cos(kz*(zMin-zLeft)).*cos(kz*(zRight-zMax)) ./ ...
        (kz*sin(kz*(zRight-zLeft)));
end


function block = radiationBlock(labels,rows,velocityMap,Y,powerWeight)
    block.m = labels;
    block.ductModeIndex = rows;
    block.velocityMap = velocityMap(rows,:);
    block.aperturePressureMap = block.velocityMap*Y;
    block.powerWeight = powerWeight(rows);
end


function dtn = annularSectorDtN(nu,kappa,a,b)
% R=J_nu(kappa*r)Y_nu'(kappa*b)-Y_nu(kappa*r)J_nu'(kappa*b).
    if abs(kappa*b) < 1e-7
        if nu == 0
            dtn = 0;
        else
            ratio = (a/b)^(2*nu);
            dtn = (nu/a)*(ratio-1)/(ratio+1);
        end
        return;
    end

    % The axial harmonics t>=1 are strongly radially evanescent in the
    % frequency range of interest.  The equivalent I/K representation
    % avoids the branch cancellation of Y_nu at imaginary arguments.
    if real(kappa^2) < 0
        eta = sqrt(-kappa^2);
        xa = eta*a;
        xb = eta*b;
        Ipa = besselDerivativeI(nu,xa);
        Ipb = besselDerivativeI(nu,xb);
        Kpa = besselDerivativeK(nu,xa);
        Kpb = besselDerivativeK(nu,xb);
        denominator = besseli(nu,xa)*Kpb-besselk(nu,xa)*Ipb;
        numerator = eta*(Ipa*Kpb-Kpa*Ipb);
        dtn = numerator/denominator;
        return;
    end

    xa = kappa*a;
    xb = kappa*b;
    Jpa = besselDerivativeJ(nu,xa);
    Jpb = besselDerivativeJ(nu,xb);
    Ypa = besselDerivativeY(nu,xa);
    Ypb = besselDerivativeY(nu,xb);
    denominator = besselj(nu,xa)*Ypb-bessely(nu,xa)*Jpb;
    numerator = kappa*(Jpa*Ypb-Ypa*Jpb);
    dtn = numerator/denominator;
end


function value = besselDerivativeJ(nu,x)
    value = 0.5*(besselj(nu-1,x)-besselj(nu+1,x));
end


function value = besselDerivativeY(nu,x)
    value = 0.5*(bessely(nu-1,x)-bessely(nu+1,x));
end


function value = besselDerivativeI(nu,x)
    value = 0.5*(besseli(nu-1,x)+besseli(nu+1,x));
end


function value = besselDerivativeK(nu,x)
    value = -0.5*(besselk(nu-1,x)+besselk(nu+1,x));
end


function kz = outgoingAxialWavenumber(k,alpha)
    argument = k^2-alpha^2;
    kz = sqrt(argument);
    scale = max([1,abs(k)^2,alpha^2]);
    if real(argument) >= -64*eps(scale)
        if real(kz) < 0
            kz = -kz;
        end
    else
        if imag(kz) > 0
            kz = -kz;
        end
    end
end
