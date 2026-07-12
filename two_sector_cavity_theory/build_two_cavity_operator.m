function [A,Ycav,Gduct,pre]=build_two_cavity_operator(omega,cfg)
%BUILD_TWO_CAVITY_OPERATOR First-principles spectral mode matching.
% A=I-Gduct*Ycav. Diagonal blocks are exact sector-cavity DtN maps;
% off-diagonal Green blocks contain all C1-C2 multiple scattering.

k=omega/cfg.c0; nc=numel(cfg.cavity); N=cfg.aperture.count;
Ycav=complex(zeros(N)); radialDtN=cell(nc,1);
for ic=1:nc
    c=cfg.cavity(ic); ap=c.aperture; dtn=complex(zeros(ap.count,1));
    for j=1:ap.count
        nu=ap.s(j)*pi/c.beta; kz0=ap.t(j)*pi/c.Lz;
        dtn(j)=sector_dtn(nu,sqrt(k^2-kz0^2),cfg.a,c.b);
    end
    idx=ap.indices;
    Ycav(idx,idx)=diag(-dtn/(1i*cfg.rho0*omega));
    radialDtN{ic}=dtn;
end

alpha=cfg.duct.alpha; nd=cfg.duct.count;
kz=complex(zeros(nd,1));Gduct=complex(zeros(N));
zLeft=-cfg.ductPhysicalLength/2-cfg.pmlStretch*cfg.pmlLength;
zRight=cfg.ductPhysicalLength/2+cfg.pmlStretch*cfg.pmlLength;
lowerMap=complex(zeros(nd,N));upperMap=complex(zeros(nd,N));

for d=1:nd
    kz(d)=outgoing_kz(k,alpha(d));
    if abs(kz(d))*cfg.a<1e-11,error('Retained duct mode is at cutoff.');end
    excludeGreen=isfield(cfg,'excludeGreenRows')&&ismember(d,cfg.excludeGreenRows);
    for io=1:nc
        co=cfg.cavity(io); qo=co.quadrature; ioidx=co.aperture.indices;
        zo=co.z0+qo.zLocal; Wo=qo.zWeight.*qo.zBasis;
        for is=1:nc
            cs=cfg.cavity(is); qs=cs.quadrature; isidx=cs.aperture.indices;
            zs=cs.z0+qs.zLocal; Ws=qs.zWeight.*qs.zBasis;
            if strcmpi(cfg.ductTermination,'finitePML')
                denom=kz(d)*sin(kz(d)*(zRight-zLeft));
                zmin=min(zo,zs.');zmax=max(zo,zs.');
                green=cos(kz(d)*(zmin-zLeft)).*cos(kz(d)*(zRight-zmax))/denom;
                axial=Wo.'*(1i*cfg.rho0*omega*green)*Ws;
            else
                green=exp(-1i*kz(d)*abs(zo-zs.'));
                axial=Wo.'*green*Ws;
                axial=(-cfg.rho0*omega/(2*kz(d)))*axial;
            end
            angular=co.overlapAngular(:,d)*cs.overlapAngular(:,d)';
            if ~excludeGreen
                Gduct(ioidx,isidx)=Gduct(ioidx,isidx)+kron(axial,angular);
            end
        end
        % Each cavity contributes to the pressure at the two probe planes.
        if strcmpi(cfg.ductTermination,'finitePML')
            gl=finite_green(cfg.probeZ(1),zo,kz(d),zLeft,zRight);
            gu=finite_green(cfg.probeZ(2),zo,kz(d),zLeft,zRight);
            factor=1i*cfg.rho0*omega;
        else
            gl=exp(-1i*kz(d)*abs(cfg.probeZ(1)-zo));
            gu=exp(-1i*kz(d)*abs(cfg.probeZ(2)-zo));
            factor=-cfg.rho0*omega/(2*kz(d));
        end
        al=qo.zBasis.'*(qo.zWeight.*gl);
        au=qo.zBasis.'*(qo.zWeight.*gu);
        sourceAngular=conj(co.overlapAngular(:,d)).';
        lowerMap(d,ioidx)=factor*kron(al.',sourceAngular);
        upperMap(d,ioidx)=factor*kron(au.',sourceAngular);
    end
end
A=eye(N)-Gduct*Ycav;

omegaPower=abs(real(omega));weight=zeros(nd,1);
if omegaPower>0
    open=(omegaPower/cfg.c0)^2-alpha.^2>0;
    weight(open)=sqrt((omegaPower/cfg.c0)^2-alpha(open).^2)/(2*cfg.rho0*omegaPower);
end
orders=cfg.radiation.globalMOrder; rows=cfg.radiation.ductModeIndex;
lowerRows=zeros(size(rows));
for j=1:numel(rows)
    lowerRows(j)=find(cfg.duct.m==-orders(j)&cfg.duct.n==0,1,'first');
end
pre=struct('omega',omega,'frequency',omega/(2*pi),'wavenumber',k);
pre.cavity.radialDtN=radialDtN;pre.cavity.names={cfg.cavity.name};
pre.duct=struct('m',cfg.duct.m,'n',cfg.duct.n,'alpha',alpha,'kz',kz, ...
    'lowerVelocityMapAllModes',lowerMap,'upperVelocityMapAllModes',upperMap, ...
    'powerWeightAllModes',weight,'termination',cfg.ductTermination);
pre.radiation.channelOrder=orders;
pre.radiation.upperPropagationM=radblock(orders,rows,upperMap,Ycav,weight);
pre.radiation.lowerPropagationM=radblock(orders,lowerRows,lowerMap,Ycav,weight);
pre.radiation.upperGlobalM=radblock(orders,rows,upperMap,Ycav,weight);
pre.radiation.lowerGlobalM=radblock(orders,rows,lowerMap,Ycav,weight);
end

function g=finite_green(zobs,zsrc,kz,zl,zr)
g=cos(kz*(min(zobs,zsrc)-zl)).*cos(kz*(zr-max(zobs,zsrc)))./(kz*sin(kz*(zr-zl)));
end

function b=radblock(labels,rows,map,Y,w)
b=struct('m',labels,'ductModeIndex',rows,'velocityMap',map(rows,:), ...
    'aperturePressureMap',map(rows,:)*Y,'powerWeight',w(rows));
end

function dtn=sector_dtn(nu,kappa,a,b)
if abs(kappa*b)<1e-7
    if nu==0,dtn=0;else,r=(a/b)^(2*nu);dtn=(nu/a)*(r-1)/(r+1);end
    return
end
if real(kappa^2)<0
    eta=sqrt(-kappa^2);xa=eta*a;xb=eta*b;
    Ipa=dI(nu,xa);Ipb=dI(nu,xb);Kpa=dK(nu,xa);Kpb=dK(nu,xb);
    dtn=eta*(Ipa*Kpb-Kpa*Ipb)/(besseli(nu,xa)*Kpb-besselk(nu,xa)*Ipb);
else
    xa=kappa*a;xb=kappa*b;
    Jpa=dJ(nu,xa);Jpb=dJ(nu,xb);Ypa=dY(nu,xa);Ypb=dY(nu,xb);
    dtn=kappa*(Jpa*Ypb-Ypa*Jpb)/(besselj(nu,xa)*Ypb-bessely(nu,xa)*Jpb);
end
end
function v=dJ(n,x),v=.5*(besselj(n-1,x)-besselj(n+1,x));end
function v=dY(n,x),v=.5*(bessely(n-1,x)-bessely(n+1,x));end
function v=dI(n,x),v=.5*(besseli(n-1,x)+besseli(n+1,x));end
function v=dK(n,x),v=-.5*(besselk(n-1,x)+besselk(n+1,x));end
function kz=outgoing_kz(k,alpha)
kz=sqrt(k^2-alpha^2);
if real(k^2-alpha^2)>=0
    if real(kz)<0,kz=-kz;end
else
    if imag(kz)>0,kz=-kz;end
end
end
