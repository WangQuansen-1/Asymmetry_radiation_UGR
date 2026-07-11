function rad = solve_point_source_radiation(sys,frequency)
%SOLVE_POINT_SOURCE_RADIATION Direct forced Helmholtz solve.

if nargin<2, frequency=sys.cfg.driveFrequency; end
k=2*pi*frequency/sys.cfg.c0;
if isfield(sys,'kind') && strcmp(sys.kind,'fem')
    kz=sqrt(complex(k^2-(1.8412/sys.cfg.ductRadius)^2));
    A=sys.Kbase+1i*kz*sys.B-k^2*sys.M;
else
    A=sys.K-k^2*sys.M;
end
src=nearest_active_index(sys,sys.cfg.source.xyz);
b=complex(zeros(sys.n,1));
if isfield(sys,'kind') && strcmp(sys.kind,'fem')
    b(src)=exp(1i*sys.cfg.source.phase);
else
    b(src)=exp(1i*sys.cfg.source.phase)/sys.h^3;
end
p=A\b;
ch=extract_six_channels(sys,p,frequency);
rad=struct('frequency',frequency,'pressure',p,'sourceIndex',src,'channels',ch);
end

function idx=nearest_active_index(sys,xyz)
if isfield(sys,'kind') && strcmp(sys.kind,'fem')
    d2=sum((sys.vertex-xyz(:)).^2,1);
    [~,idx]=min(d2);
    return
end
active=find(sys.mask);
dx=sys.X(active)-xyz(1);dy=sys.Y(active)-xyz(2);dz=sys.Z(active)-xyz(3);
[~,k]=min(dx.^2+dy.^2+dz.^2);
idx=double(sys.id(active(k)));
end
