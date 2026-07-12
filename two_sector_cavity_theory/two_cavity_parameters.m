function cfg = two_cavity_parameters(varargin)
%TWO_CAVITY_PARAMETERS Analytic modal data for first-layer C1 and C2.
% No mesh, fitted pole, FEM matrix, or TCMT coefficient is used.

cfg.model = 'selected negative-z C1+C2 annular-sector cavities';
cfg.a = 0.1;
cfg.c0 = 343.0;
cfg.rho0 = 1.21;
cfg.timeConvention = 'exp(+i*omega*t)';
cfg.ductTermination = 'finitePML';
cfg.ductPhysicalLength = 1.2;
cfg.pmlLength = 0.3;
cfg.pmlStretch = 3*(1-1i);
cfg.probeZ = [-0.5,0.5];

cfg.cavityAngularMax = 6;
cfg.cavityAxialMax = 2;
cfg.ductAzimuthalMax = 7;
cfg.ductRadialCount = 5;
cfg.thetaQuadratureOrder = 56;
cfg.zQuadratureOrder = 44;
cfg.ductAxialMax = 45;
cfg.includeOppositeCopies = false;

% Domain mapping from the TXT-generating COMSOL solve:
% acoustic domains 1 and 3 are the mirrored, opposite C1/C2 pair at -z.
cfg.cavity(1) = struct('name','C1','b',0.145171875, ...
    'beta',deg2rad(44),'Lz',0.05662041875, ...
    'theta0',deg2rad(180),'z0',-0.10662041875);
cfg.cavity(2) = struct('name','C2','b',0.181458978125, ...
    'beta',deg2rad(44),'Lz',0.024679615625, ...
    'theta0',deg2rad(234),'z0',-0.0906500171875);

cfg = apply_overrides(cfg,varargin{:});
if cfg.includeOppositeCopies
    c1=cfg.cavity(1);c2=cfg.cavity(2);
    c1.name='C1_opposite';c1.theta0=c1.theta0+pi;
    c2.name='C2_opposite';c2.theta0=c2.theta0+pi;
    cfg.cavity(3)=c1;cfg.cavity(4)=c2;
end
validate_cfg(cfg);

Smax = cfg.cavityAngularMax;
Tmax = cfg.cavityAxialMax;
s = (0:Smax).'; t = (0:Tmax).';
[sg,tg] = ndgrid(s,t);
offset = 0;
for ic = 1:numel(cfg.cavity)
    cav = cfg.cavity(ic);
    [th,wth] = gauss_legendre(cfg.thetaQuadratureOrder,0,cav.beta);
    [zz,wz] = gauss_legendre(cfg.zQuadratureOrder,0,cav.Lz);
    Th = cos(th*(s.'*pi/cav.beta)).*sqrt((2-(s.'==0))/cav.beta);
    Z = cos(zz*(t.'*pi/cav.Lz)).*sqrt((2-(t.'==0))/cav.Lz);
    n = numel(sg);
    cfg.cavity(ic).aperture = struct('s',sg(:),'t',tg(:),'count',n, ...
        'indices',(offset+(1:n)).','angularOrder',(pi/cav.beta)*s, ...
        'axialWavenumber',(pi/cav.Lz)*t);
    cfg.cavity(ic).quadrature = struct('thetaLocal',th,'thetaWeight',wth, ...
        'zLocal',zz,'zWeight',wz,'thetaBasis',Th,'zBasis',Z);
    offset = offset+n;
end
cfg.aperture.count = offset;
cfg.aperture.indexFormula = 'cavity blocks; within each block s is fastest';

% Orthonormal hard-wall circular-duct modes.
M = cfg.ductAzimuthalMax; Nr = cfg.ductRadialCount;
N = (2*M+1)*Nr;
dm=zeros(N,1); dn=zeros(N,1); root=zeros(N,1); wall=zeros(N,1);
cursor=0;
for m=-M:M
    ell=abs(m);
    if m==0
        roots=[0; neumann_bessel_roots(ell,max(Nr-1,0))];
    else
        roots=neumann_bessel_roots(ell,Nr);
    end
    for nl=0:Nr-1
        cursor=cursor+1; x=roots(nl+1);
        if x==0
            ri=cfg.a^2/2;
        else
            jm=besselj(ell,x);
            ri=(cfg.a^2/2)*(jm^2-besselj(ell-1,x)*besselj(ell+1,x));
        end
        C=1/sqrt(2*pi*ri);
        dm(cursor)=m; dn(cursor)=nl; root(cursor)=x;
        wall(cursor)=C*besselj(ell,x);
    end
end
cfg.duct=struct('m',dm,'n',dn,'neumannRoot',root, ...
    'alpha',root/cfg.a,'wallValue',wall,'count',N);

% Exact aperture/circular-mode angular overlaps for each cavity.
for ic=1:numel(cfg.cavity)
    q=cfg.cavity(ic).quadrature;
    thetaGlobal=cfg.cavity(ic).theta0+q.thetaLocal;
    psi=exp(1i*thetaGlobal*(dm.')).*(wall.');
    cfg.cavity(ic).overlapAngular=sqrt(cfg.a)*(q.thetaBasis.'*(q.thetaWeight.*psi));
end

requested=[1,0,-1]; rows=zeros(size(requested));
for j=1:numel(requested)
    rows(j)=find(dm==requested(j)&dn==0,1,'first');
end
cfg.radiation=struct('globalMOrder',requested,'ductModeIndex',rows, ...
    'note','Eoz is lower -z; Eof is upper +z; lower propagation m reverses global m.');
cfg.operatorBuilder = @build_two_cavity_operator;
end

function cfg=apply_overrides(cfg,varargin)
if mod(numel(varargin),2)~=0,error('Overrides must be Name,Value pairs.');end
for k=1:2:numel(varargin)
    name=char(string(varargin{k}));
    if ~isfield(cfg,name),error('Unknown option %s.',name);end
    cfg.(name)=varargin{k+1};
end
end

function validate_cfg(cfg)
assert(cfg.a>0&&cfg.c0>0&&cfg.rho0>0);
assert(cfg.ductRadialCount>=1&&cfg.ductAzimuthalMax>=1);
for ic=1:numel(cfg.cavity)
    c=cfg.cavity(ic);
    assert(c.b>cfg.a&&c.beta>0&&c.Lz>0);
end
end

function rootsOut=neumann_bessel_roots(order,count)
rootsOut=zeros(count,1); if count==0,return;end
fun=@(x)0.5*(besselj(order-1,x)-besselj(order+1,x));
step=pi/24; xl=1e-7; fl=fun(xl); found=0;
for it=1:200000
    xr=xl+step; fr=fun(xr);
    if isfinite(fl)&&isfinite(fr)&&fl*fr<0
        x=fzero(fun,[xl xr]);
        if x>1e-6&&(found==0||abs(x-rootsOut(found))>1e-7)
            found=found+1; rootsOut(found)=x;
            if found==count,return;end
        end
    end
    xl=xr;fl=fr;
end
error('Could not find requested Neumann-Bessel roots.');
end

function [x,w]=gauss_legendre(n,a,b)
j=(1:n-1).';off=j./sqrt(4*j.^2-1);
[V,D]=eig(diag(off,1)+diag(off,-1),'vector');
[nodes,ord]=sort(D);weights=2*(V(1,ord).').^2;
x=(a+b)/2+(b-a)*nodes/2;w=(b-a)*weights/2;
end
