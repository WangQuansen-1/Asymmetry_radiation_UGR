% function modez = mode_mn_t_r(mg1,ph1,freq,mic_anglur_num,mic_num,mic_z_num,D,z,z_t)
function out = mode_mn_t_r(mg1,ph1,freq,mic_anglur_num,mic_num,mic_z_num,D,z,z_t,zii)
global name_s





mic_deg = mic_anglur_num;
xmn = [0,3.83,7.02,10.17,13.47;
    1.84,5.33,8.54,11.71,14.86;
    3.05,6.71,9.97,13.17,16.35;
    4.20,8.02,11.35,14.59,20.97;
    5.31755,9.2824,12.6819,15.9641,19.196;
    6.41562,10.5199,13.9872,17.3128,20.5755;
    7.50127,11.7349,15.2682,18.6374,21.9317;
    8.57784,12.9324,16.5294,19.9419,23.2681;
    9.64742,14.1155,17.774,21.2291,24.5872;
    10.7114,15.2867,19.0046,20.5014,25.8913;
    11.7709,16.4479,20.223,23.7607,27.0182];
[line1,lie1] = size(xmn);
xmn_f = flipud(xmn(2:end,:));
xmn_t = [xmn_f;xmn];
[line,lie] = size(xmn_t);

%%

unit = 1*1e-3;
f =freq;
c = 343;


k0 = 2*pi*f/c;

R =D/2*unit;

kmn = xmn_t./R;
fmn = kmn*c/2/pi;

f_x = f;

fmn(fmn>f_x)=1000;
name = cell(line,lie);
m_mode = ones(line,lie)*1000;
for i=1:line
    for j=1:lie
        if fmn(i,j)~=1000
            if i-line1<0
            name{i,j} = strcat('p_',num2str(abs(i-line1)),num2str(j-1));
            else
               name{i,j} = strcat('p',num2str(abs(i-line1)),num2str(j-1)); 
            end
            m_mode(i,j) = i-line1;

        end
    end
end


m_mode_s = reshape(m_mode.',line*lie,1);
m_mode_s=  m_mode_s(m_mode_s~=1000);

name_s = reshape(name.',line*lie,1);
name_s(cellfun(@isempty,name_s))=[];

fmn_res = reshape(fmn.',line*lie,1);
fmn_s=  fmn_res(fmn_res~=1000);

kmn_s = 1.*(fmn_s*2*pi/c);
xmn_s = kmn_s.*R;
kz = sqrt(k0.^2-(kmn_s).^2);



% 绘制螺旋线的轨迹 即 采点

th1 = 2*pi/mic_deg;


% relfection
delta_z = z*unit ;
strat_point_r = 0;
strat_point_r2 = z_t*unit;%第二个mic到第一个mic的距离
% zl = [ones(1,mic_deg)*strat_point_r;ones(1,mic_deg)*strat_point_r+delta_z;];%...
    % ones(1,mic_deg)*strat_point_r2+delta_z*0;ones(1,mic_deg)*strat_point_r2+delta_z*1];
zl = [];
for uu = 1:mic_z_num
    zl0 = [ones(1,mic_deg)*strat_point_r+delta_z*(uu-1)];
    if uu==1

        zl = zl0;
    else

        zl = [zl;zl0];
    end

end

zl_loc = (zl(:,1)).';
for zi=1:length(zl_loc)
    zl_loc2(zi) =zl_loc(zi)-zl_loc(1); 
end




% 计算

mg_mic = mg1;
ph_mic = ph1;
mg1 = reshape(mg1.',mic_num,1);
ph1 = reshape(ph1.',mic_num,1);
%用于模式计算的
l1 = length(mg1);

% 用于表示每一圈mic
SPL_mic= mg1;
p_mic = 10.^(SPL_mic/20)*2*1e-5*sqrt(2);
phase_mic =ph1*pi/180;


p=(p_mic.*exp(1i.*phase_mic));
[line2,~] = size(zl);
% 正向
xmn1 =@(z_dis) exp(-1i.*kz.'.*z_dis);%正向+,为什么取-的时候会更好一点 在comsol系统中正向传播是+，m的地方是-。
% xmn2 =@(th1) exp(-1i.*m_mode_s.'.*th1);  %注意在这个位置校准的符号，它好像是与轴向的传播函数是相反的
xmn2 = exp(-1i.*m_mode_s.'.*th1); 
%反向 反向手性发生翻转 对正向-1次方
% xfmn1 = exp(-1i.*kz.'.*delta_z);%正向+,为什么取-的时候会更好一点 在comsol系统中正向传播是+，m的地方是-。
% xfmn2 = exp(+1i.*m_mode_s.'.*th1);

XX = zeros(length(p),length(m_mode_s));
XXf = XX;
for i=0:line2-1%纵向
    for j = 0:mic_deg-1%角向

    XX(mic_deg*i+j+1,:) = xmn1(zl_loc2(i+1)).*xmn2.^j;
    XXf(mic_deg*i+j+1,:) = (xmn1(zl_loc2(i+1)).^-1).*((xmn2).^-1).^j;


    end
end
% XXt = [XX,XXf];
XXt = [XX];


% mm = abs(pinv(XX)*p).^2;
An =lsqminnorm(XXt,p);
% A1 = lsqminnorm(XX(1:16,:),p_1);
% At =lsqminnorm(XXt,pt);
% An = XXt\p;
% An = lsqlin(XXt,p);
% At = XXt\pt;
% Anz = An(1:length(An)/2);
% Anf = An(length(An)/2+1:end);
Anz = An;




pm  = besselj(abs(m_mode_s),kmn_s.*R);
% Azz = Anz./pm./xmn1(1).'./xmn2.';
% mode = abs(A1./pm./xmn1(1).'./xmn2.').^1;
modez = abs(Anz./pm./xmn1(1).'./xmn2.').^1;%做了整体修改
% modef = abs(Anf./pm./(xmn1(1).^(-1)).'./(xmn2.^(-1)).').^1;%做了整体修改


phz = 180*(angle(Anz./pm./xmn1(1).'./xmn2.'))./pi;
% phf = 180*angle(Anf./pm./(xmn1(1).^(-1)).'./(xmn2.^(-1)).')./pi;

%% 特征频率优化

% 
% if zii>0
    % out = modez(3,:)./sum(modez);
% else
%     out = modez(3,:)./sum(modez);
      % out = modez(1,:)./sum(modez);
% end
%%



%%

%% 两圈t

[u,v] = size(name);
% out = zeros(u,v);
% % Ein2 = out;
Inz = zeros(u,v);
% r_mode = zeros(u,v);
% t_mode = zeros(u,v);
% tz_mode = zeros(u,v);
% tf_mode = zeros(u,v);
for i=1:u
    for j=1:v

        for mm=1:length(name_s)
            if strcmp(name{i,j},name_s{mm})
                % out(i,j) = mode(mm);
                Inz(i,j) = modez(mm);
                % r_mode(i,j) = modef(mm);
                % t_mode(i,j) = modet(mm);
                % tz_mode(i,j) = modetz(mm);
                % tf_mode(i,j) = modetf(mm);
            end
        end
    end
% 
% 
% end
% % out1 = Inz./sum(sum(Inz));
% xVals = [0:lie1-1];
% yVals = [-line1+1:line1-1];

% mode_cof = modef./modez(1);

% out1 = Inz./max(max(Inz));
% name_tiqu = name(1:11,:);
% m0 = 10:-1:0;
% [~,index1] = max(out1(1:11,1));
% m_output = m0(index1);
% 
% % % test
% modezz = Inz./sum(sum(Inz));


%% Energy
Am_in = abs(modez).^2;
% Am_r = abs(modef).^2;
% % Am_t = abs(modet).^2;
% % Am_tz = abs(modetz).^2;
% % Am_tf = abs(modetf).^2;
% 
In = (Am_in.*kz).'; %将列转变成行
% ER = (Am_r.*kz).'; %将列转变成行
% % ET = (Am_t.*kz).'; %将列转变成行
% % ETz = (Am_tz.*kz).'; %将列转变成行
% % ETf = (Am_tf.*kz).'; %将列转变成行
% 
fun1 = pi*R.^2;
fun2 = @(m,u) fun1.*(1-m^2/u^2)*(besselj(abs(m),u))^2;
phi1 = zeros(1,length(kz));

for e = 1:length(xmn_s)
    if xmn_s(e)~=0
        phi1(e) = fun2(m_mode_s(e),xmn_s(e));
    else
        phi1(e) = fun1;
    end

end
Ein = (real(phi1.*In)).';
% Er = (real(phi1.*ER)).';
% 
% %%% 利用所有能量的总和做归一化
% totl_E = sum(Ein+Er);
% 
% % Et = (real(phi1.*ET)).';
% % Etz = (real(phi1.*ETz)).';
% % Etf = (real(phi1.*ETf)).';
% 
% % R_e_t = sum(Er)./sum(Ein)
% % T_tz = sum(Etz)./sum(Ein)
% % R_tf = sum(Etf)./sum(Ein)
% 
% % In_e_mode = Ein./sum(totl_E);
In_e_mode = Ein./sum(Ein);
if zii>0
out = In_e_mode(1,:);
else
  out = In_e_mode(3,:); 
end
% R_e_mode = Er./sum(Ein);
% % T_e_mode = Et./sum(Ein);
% % T_z_mode = Etz./sum(Ein);
% % T_f_mode = Etf./sum(Ein);
% 
% Ein2 = zeros(u,v);
% Er2 = zeros(u,v);
% Etz2 = zeros(u,v);
% Etf2 = zeros(u,v);
% In_e_mode2 = zeros(u,v);
% R_e_mode2 = zeros(u,v);
% % T_e_mode2 = zeros(u,v);
% T_z_mode2 = zeros(u,v);
% T_f_mode2 = zeros(u,v);
% for i=1:u
%     for j=1:v
% 
%         for mm=1:length(name_s)
%             if strcmp(name{i,j},name_s{mm})
%                Ein2(i,j) = Ein(mm);
%                Er2(i,j) = Er(mm);
%                % Etz2(i,j) = Etz(mm);
%                % Etf2(i,j) = Etf(mm);
%                R_e_mode2(i,j) = R_e_mode(mm);
%                In_e_mode2(i,j) = In_e_mode(mm);
%                % T_z_mode2(i,j) = T_z_mode(mm);
%                % T_f_mode2(i,j) = T_f_mode(mm);
%             end
%         end
%     end
% 
% 
% end
% 
% 
%  Ein2_g = Ein2./sum(sum(Ein2));
% 
% 
% % opti1=strcmp(name,'p10');
% % [line10,lie10] = find(opti1==1);
% % Ein2_g(line10,lie10);


%% 模式能量提取
% % In
% % 10 mode
% mode10 = strcat("p",input_mode);
% m10 = strcmp(mode10,name_s);
% [L10,~]=find(m10==1);
% 
% if strcmp('00',input_mode)
% mode10_r = strcat("p",input_mode);
% 
% else
% mode10_r = strcat("p_",input_mode);
% 
% end
% 
% m10_r = strcmp(mode10_r,name_s);
% [L10_r,~]=find(m10_r==1);
% 
% coff10_in = modez(L10,:);
% coff10_r = modef(L10_r,:);
% 
% E10_in = Ein(L10,:);
% E10_r = Er(L10_r,:);
% 
% Ein_t = sum(sum(Ein));
% Er_t = sum(sum(Er)); 
% 
% 
% In10 = [coff10_in,E10_in,coff10_r,E10_r,Ein_t];
% 
% 
% 
% %aim
% mode_aim = strcat("p",aim_mode);
% m_aim = strcmp(mode_aim,name_s);
% 
% [L_aim,~]=find(m_aim==1);
% 
% if strcmp('00',input_mode)
%     mode_aim_r = strcat("p",aim_mode);
% else
%     mode_aim_r = strcat("p_",aim_mode);
% end
% m_aim_r = strcmp(mode_aim_r,name_s);
% 
% [L_aim_r,~]=find(m_aim_r==1);
% 
% coff_aim = modez(L_aim,:);
% E_aim = Ein(L_aim,:);
% 
% coff_aim_r = modef(L_aim_r,:);
% E_aim_r = Er(L_aim_r,:);
% Aim = [coff_aim,E_aim,coff_aim_r,E_aim_r,Er_t];
% 
% out = [In10;Aim];
% name_str = string(name_s);
%  total = strcat(name_str,num2str([Ein,Er,In_e_mode,R_e_mode]));
%  save(strcat('C:\Users\94365\Desktop\Quansen Wang\32通道声源与测试DAQ机箱\32通道校准20231216\16通道校准20231216\16通道校准\实验结果\result-r-t-',num2str(freq),'.mat'),'total');

end