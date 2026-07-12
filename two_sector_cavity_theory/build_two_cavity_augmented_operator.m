function [A,Ycav,Gevan,pre]=build_two_cavity_augmented_operator(omega,cfg)
%BUILD_TWO_CAVITY_AUGMENTED_OPERATOR Finite-PML analytic duct+cavity system.
% Propagating transverse duct branches m=+1,0,-1 are retained with an
% explicit finite-complex-length cosine basis.  This preserves the
% homogeneous PML/duct eigenmodes that a Green-function elimination misses.
% All higher transverse branches remain exactly eliminated through their
% closed-form modal Green functions.  There is no spatial mesh.

if isfield(cfg,'explicitDuctRows')&&~isempty(cfg.explicitDuctRows)
    explicitRows=cfg.explicitDuctRows(:).';
else
    explicitRows=cfg.radiation.ductModeIndex;
end
tmp=cfg;tmp.excludeGreenRows=explicitRows;
[~,Ycav,Gevan,base]=build_two_cavity_operator(omega,tmp);

k=omega/cfg.c0;ndx=numel(explicitRows);na=cfg.ductAxialMax+1;
nAmp=ndx*na;N=cfg.aperture.count;
zLeft=-cfg.ductPhysicalLength/2-cfg.pmlStretch*cfg.pmlLength;
zRight=cfg.ductPhysicalLength/2+cfg.pmlStretch*cfg.pmlLength;
Leff=zRight-zLeft;n=(0:cfg.ductAxialMax).';qn=n*pi/Leff;
normz=(Leff/2)*ones(na,1);normz(1)=Leff;

D=complex(zeros(nAmp));H=complex(zeros(N,nAmp));S=complex(zeros(nAmp,N));
for jd=1:ndx
    d=explicitRows(jd);cols=(jd-1)*na+(1:na);
    kz2=k^2-cfg.duct.alpha(d)^2;
    D(cols,cols)=diag(normz.*(kz2-qn.^2));
    for ic=1:numel(cfg.cavity)
        c=cfg.cavity(ic);q=c.quadrature;rows=c.aperture.indices;
        z=c.z0+q.zLocal;
        phi=cos((z-zLeft)*qn.'); % z quadrature x axial mode
        target=q.zBasis.'*(q.zWeight.*phi); % t x n
        source=phi.'*(q.zWeight.*q.zBasis); % n x t, no conjugation
        B=c.overlapAngular(:,d);
        H(rows,cols)=kron(target,B);
        S(cols,rows)=kron(source,conj(B).');
    end
end

A=[D,-1i*cfg.rho0*omega*S*Ycav; ...
   -H,eye(N)-Gevan*Ycav];

% Pressure amplitudes of requested m channels at the two physical probes.
Plo=complex(zeros(3,nAmp));Pup=complex(zeros(3,nAmp));
for jout=1:3
    upperRow=cfg.radiation.ductModeIndex(jout);
    globalLower=-cfg.radiation.globalMOrder(jout);
    lowerRow=find(cfg.duct.m==globalLower&cfg.duct.n==0,1,'first');
    ju=find(explicitRows==upperRow,1);
    jl=find(explicitRows==lowerRow,1);
    if isempty(ju)||isempty(jl)
        error('Explicit duct rows must contain all requested m=+1,0,-1 n=0 rows.');
    end
    cu=(ju-1)*na+(1:na);cl=(jl-1)*na+(1:na);
    Pup(jout,cu)=cos(qn.'*(cfg.probeZ(2)-zLeft));
    Plo(jout,cl)=cos(qn.'*(cfg.probeZ(1)-zLeft));
end
weight=zeros(3,1);omegaPower=abs(real(omega));
for j=1:3
    d=cfg.radiation.ductModeIndex(j);
    val=(omegaPower/cfg.c0)^2-cfg.duct.alpha(d)^2;
    if val>0,weight(j)=sqrt(val)/(2*cfg.rho0*omegaPower);end
end

pre=base;pre.augmented=true;pre.apertureIndices=nAmp+(1:N);
pre.explicit=struct('ductRows',explicitRows,'axialOrder',n,'qn',qn, ...
    'effectiveLength',Leff,'amplitudeCount',nAmp, ...
    'lowerPropagationPressureMap',Plo,'upperPropagationPressureMap',Pup, ...
    'powerWeight',weight);
pre.valid=all(isfinite(A),'all');
end
