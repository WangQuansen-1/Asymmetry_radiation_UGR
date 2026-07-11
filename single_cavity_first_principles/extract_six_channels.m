function ch = extract_six_channels(sys,p,frequency)
%EXTRACT_SIX_CHANNELS Reproduce the saved COMSOL four-probe DFT convention.

probe = sys.cfg.probeXYZ;
pressure = complex(zeros(8,1));
for k=1:8
    pressure(k) = nearest_fluid_value(sys,p,probe(k,:));
end

phaseAngles = (0:3).'*pi/2;
lower = pressure(1:4);
upper = pressure(5:8);
aoz1  = mean(lower.*exp(-1i*(+1)*phaseAngles));
aoz0  = mean(lower);
aoz_1 = mean(lower.*exp(-1i*(-1)*phaseAngles));
aof_1 = mean(upper.*exp(-1i*(+1)*phaseAngles));
aof0  = mean(upper);
aof1  = mean(upper.*exp(-1i*(-1)*phaseAngles));

omega = 2*pi*real(frequency);
k0 = omega/sys.cfg.c0;
mu10 = 1.8412;
kz10 = sqrt(complex(k0^2-(mu10/sys.cfg.ductRadius)^2));
kz00 = k0;
C1 = 1/(2*sys.cfg.rho0*omega);
fac1 = real(kz10*pi*sys.cfg.ductRadius^2*(1-mu10^-2))*C1;
fac0 = real(kz00*pi*sys.cfg.ductRadius^2)*C1;

Pz = [abs(aoz1)^2*fac1,abs(aoz0)^2*fac0,abs(aoz_1)^2*fac1];
Pf = [abs(aof1)^2*fac1,abs(aof0)^2*fac0,abs(aof_1)^2*fac1];
Pz = max(real(Pz),0); Pf = max(real(Pf),0);
ch = struct;
ch.pressure = pressure;
ch.Eoz = Pz;
ch.Eof = Pf;
ch.lowerFraction = Pz/max(sum(Pz),realmin);
ch.upperFraction = Pf/max(sum(Pf),realmin);
ch.names = {'Eoz1','Eoz0','Eoz_1','Eof1','Eof0','Eof_1'};
end

function value = nearest_fluid_value(sys,p,xyz)
if isfield(sys,'kind') && strcmp(sys.kind,'fem')
    d2=sum((sys.vertex-xyz(:)).^2,1);
    [~,m]=min(d2);
    value=p(m);
    return
end
ix = find(abs(sys.x-xyz(1)) == min(abs(sys.x-xyz(1))),1);
iy = find(abs(sys.y-xyz(2)) == min(abs(sys.y-xyz(2))),1);
iz = find(abs(sys.z-xyz(3)) == min(abs(sys.z-xyz(3))),1);
r = 2;
xs=max(1,ix-r):min(numel(sys.x),ix+r);
ys=max(1,iy-r):min(numel(sys.y),iy+r);
zs=max(1,iz-r):min(numel(sys.z),iz+r);
[I,J,K]=ndgrid(xs,ys,zs);
valid=sys.mask(xs,ys,zs);
I=I(valid);J=J(valid);K=K(valid);
d2=(sys.x(I)-xyz(1)).^2+(sys.y(J)-xyz(2)).^2+(sys.z(K)-xyz(3)).^2;
[~,m]=min(d2);
value=p(double(sys.id(I(m),J(m),K(m))));
end
