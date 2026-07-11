function [mg,ph] = comsol_tiqu2(mic_anglar_num,z_start,mic_z_num,R,dset)
global model
%mic_num一圈的mic数

% unit = 100*1e-3;
% mic_num = 8;

% R = 0.75*unit;
% L = 30*unit;
cu =1;%环绕的圈数
% pitch=1;
th1 = 2*pi/mic_anglar_num;
t = 0:th1:2*pi*cu-th1;
% t = t-100*pi/180;
% s = t/pitch;
xl = R.*cos(t);
yl = R.*sin(t);

% COMSOL 数据提取
% 透射端
for i = 1:mic_z_num
    zl(i,:) = ones(1,mic_anglar_num)* z_start+(i-1)*0.02;
end
% zl = [ones(1,mic_num)* z_start;ones(1,mic_num)* z_start+0.02;ones(1,mic_num)*z_start+0.04;ones(1,mic_num)*z_start+0.06;ones(1,mic_num)*z_start+0.08]; %直接的差是相邻两点之间间距zm=1的话相邻间距是1m,+后面是对其实点修正
% zl = (t/2/pi/cu*1)+0; % 可等价于取点的总数，不要最后一个点，因为最后一个点与起始点是不同的Z
delta_z = zl(2)-zl(1);

type = 'acpr.Lp_t';
type2 = 'arg(acpr.p_t)*180/pi';

mg = [];
ph = [];
for uu = 1:mic_z_num
coord1 = [xl;yl;zl(uu,:)];
% coord2 = [xl;yl;zl(2,:)];
% coord3 = [xl;yl;zl(3,:)];
% coord4 = [xl;yl;zl(4,:)];
% coord5 = [xl;yl;zl(5,:)];
% coord6 = [xl;yl;zl(6,:)];



% 
Lp1 = (mphinterp(model,type,'coord',coord1,'dataset',dset));%[x;y;z]%先按角向取,行是声压，列是频率
% Lp2 = (mphinterp(model,type,'coord',coord2,'dataset',dset)).';%[x;y;z]
% Lp3 = (mphinterp(model,type,'coord',coord3,'dataset',dset))';%[x;y;z]
% Lp4 = (mphinterp(model,type,'coord',coord4,'dataset',dset))';%[x;y;z]
% Lp5 = (mphinterp(model,type,'coord',coord5,'dataset',dset))';%[x;y;z]
% Lp6 = (mphinterp(model,type,'coord',coord6,'dataset',dset))';%[x;y;z]
% mg = [Lp1.';Lp2.'];%Lp3.';Lp4.'];%Lp5.';Lp6.'];
if uu == 1
mg = Lp1;
else
    mg = [mg,Lp1];
end

% mg = [Lp1;Lp2];%Lp3.';Lp4.'];%Lp5.';Lp6.'];


% 
ph1 = (mphinterp(model,type2,'coord',coord1,'dataset',dset));%[x;y;z]%先按角向取
% ph2 = (mphinterp(model,type2,'coord',coord2,'dataset',dset)).';%[x;y;z]
% ph3 = (mphinterp(model,type2,'coord',coord3,'dataset',dset))';%[x;y;z]
% ph4 = (mphinterp(model,type2,'coord',coord4,'dataset',dset))';%[x;y;z]
% ph5 = (mphinterp(model,type2,'coord',coord5,'dataset',dset))';%[x;y;z]
% ph6 = (mphinterp(model,type2,'coord',coord6,'dataset',dset))';%[x;y;z]
% ph = [ph1.';ph2.'];%ph3.';ph4.'];%ph5.';ph6.'];
% ph = [ph1;ph2];%ph3.';ph4.'];%ph5.';ph6.'];

if uu == 1
ph = ph1;
else
    ph = [ph,ph1];
end


end
end