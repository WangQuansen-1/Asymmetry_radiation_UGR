% function modez = mode_mn_t_r(mg1,ph1,freq,mic_anglur_num,mic_num,mic_z_num,D,z,z_t)
% function m_output = mode_mn_t_r(mg1,ph1,freq,mic_anglur_num,mic_num,mic_z_num,D,z,z_t)
% function [out,phz] = mode_mn_tt_radti(mg1,ph1,freq,mic_anglur_num,mic_num,mic_z_num,D,z,z_t)
function out = mode_mn_tt_radti(mg1,ph1,freq,mic_anglur_num,mic_num,mic_z_num,D,z,z_t)
global name_s

% %%In10:10系数，10Energy 10T_e,R也相同
% figure_name = fullfile(pwd, strcat(type0,'-Input-port-cot-',num2str(cotton_num),'-Excited-mode-',input_mode,"图片")); % 获取当前工作目录并与文件夹名称组合成完整路径
% 
% if ~exist(figure_name, 'dir') % 判断该路径下是否已存在同名文件夹
%     mkdir(figure_name); % 若不存在则创建文件夹
% end
% disp("输出图片");
% addpath(figure_name);



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
% lambda = c/f;

k0 = 2*pi*f/c;
% k0 = 2*pi*f/c+1i*1.94*10^-2*sqrt(f)/c/(D*unit);
% D=150;
R =D/2*unit;

kmn = xmn_t./R;
fmn = kmn*c/2/pi;

f_x = f;
% f_x= 8000;
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


% th0 = 0:2*pi/6:pi-2*pi/6;
% th00 = pi:2*pi/6:2*pi-2*pi/6;
% th2 = [th0,th00];



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
% mg1_angular = reshape(mg1,mic_anglur_num*mic_z_num/2,l1/(mic_anglur_num*mic_z_num/2));%第一列是入射端；第二列是透射端
% ph1_angular = reshape(ph1,mic_anglur_num*mic_z_num/2,l1/(mic_anglur_num*mic_z_num/2));
% mg1_angular = reshape(mg1,mic_anglur_num,mic_z_num);%第一列是入射端；第二列是透射端
% ph1_angular = reshape(ph1,mic_anglur_num,mic_z_num);
% 用于表示每一圈mic
SPL_mic= mg1;
p_mic = 10.^(SPL_mic/20)*2*1e-5*sqrt(2);
phase_mic =ph1*pi/180;



%% 模式计算
% 
% SPL= mg1_angular;
% p = 10.^(SPL/20)*2*1e-5*sqrt(2);
% phase=ph1_angular*pi/180;
% In_p=p(:,1);
% Out_p=p(:,2);


% In_phase=phase(:,1);
% Out_phase=phase(:,2);
% 
% Pin = (In_p.*exp(1i.*In_phase));
% Pout = (Out_p.*exp(1i.*Out_phase));

% p=[Pin;Pout];
p=(p_mic.*exp(1i.*phase_mic));
[line2,~] = size(zl);
% 正向
xmn1 =@(z_dis) exp(1i.*kz.'.*z_dis);%正向+,为什么取-的时候会更好一点 在comsol系统中正向传播是+，m的地方是-。
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

    % 
    % XX(mic_deg*i+j+1,:) = xmn1(zl_loc2(i+1)).*xmn2(th2(j+1));
    % XXf(mic_deg*i+j+1,:) = (xmn1(zl_loc2(i+1)).^-1).*((xmn2(th2(j+1))).^-1);
    
    % 
    end
end
XXt = [XX,XXf];
% XXt = [XX];


% mm = abs(pinv(XX)*p).^2;
An =lsqminnorm(XXt,p);
% A1 = lsqminnorm(XX(1:16,:),p_1);
% At =lsqminnorm(XXt,pt);
% An = XXt\p;
% An = lsqlin(XXt,p);
% At = XXt\pt;
Anz = An(1:length(An)/2);
Anf = An(length(An)/2+1:end);

%t
%
% Antz = At(1:length(At)/2);
% Antf = At(length(At)/2+1:end);

% pm  = besselj(abs(m_mode_s),kmn_s.*R);
% mode = abs(An./pm./xmn1.'./xmn2.').^1;%做了整体修改


pm  = besselj(abs(m_mode_s),kmn_s.*R);
% Azz = Anz./pm./xmn1(1).'./xmn2.';
% mode = abs(A1./pm./xmn1(1).'./xmn2.').^1;
modez = abs(Anz./pm./xmn1(1).'./xmn2.').^1;%做了整体修改
modef = abs(Anf./pm./(xmn1(1).^(-1)).'./(xmn2.^(-1)).').^1;%做了整体修改
% a1 = modef./modez(1);
% ph = 180*(angle(a1))./pi;
% modez = abs(Anz./pm./xmn1(1).'./xmn2(1).').^1;%做了整体修改
% modef = abs(Anf./pm./(xmn1(1).^(-1)).'./(xmn2(1).^(-1)).').^1;%做了整体修改

phz = 180*(angle(Anz./pm./xmn1(1).'./xmn2.'))./pi;
phf = 180*angle(Anf./pm./(xmn1(1).^(-1)).'./(xmn2.^(-1)).')./pi;


% modetz = abs(Antz./pm./xmn1.'./xmn2.').^1;%做了整体修改
% modetf = abs(Antf./pm./(xmn1.^(-1)).'./(xmn2.^(-1)).').^1;%做了整体修改









%%

%% 两圈t
% [linet,~] = size(zt);
% XXtrans = zeros(length(pt),length(m_mode_s));
% for i=0:linet-1%纵向
%     for j = 0:length(p1t)-1%角向
% 
%     XXtrans(mic_num*i+j+1,:) = xmn1.^i.*xmn2.^j;
% 
% 
%     end
% end
% 
% At =lsqminnorm(XXtrans,pt);
% modet = abs(At./pm./xmn1.'./xmn2.').^1;%做了整体修改

% figure
% 
% plot(mode/sum(mode));
[u,v] = size(name);
% out = zeros(u,v);
% Ein2 = out;
Inz = zeros(u,v);
r_mode = zeros(u,v);
% t_mode = zeros(u,v);
% tz_mode = zeros(u,v);
% tf_mode = zeros(u,v);
for i=1:u
    for j=1:v
        
        for mm=1:length(name_s)
            if strcmp(name{i,j},name_s{mm})
                % out(i,j) = mode(mm);
                Inz(i,j) = modez(mm);
                r_mode(i,j) = modef(mm);
                % t_mode(i,j) = modet(mm);
                % tz_mode(i,j) = modetz(mm);
                % tf_mode(i,j) = modetf(mm);
            end
        end
    end
    
    
end
% out1 = Inz./sum(sum(Inz));
xVals = [0:lie1-1];
yVals = [-line1+1:line1-1];


% out1 = Inz./max(max(Inz));
% name_tiqu = name(1:11,:);
% m0 = 10:-1:0;
% [~,index1] = max(out1(1:11,1));
% m_output = m0(index1);
% 
% % % test
% modezz = Inz./sum(sum(Inz));

% f2=figure;
% 
% % subplot(121)
% h = bar3(yVals,Inz);
% Xdat=get(h,'XData');
% 
% axis tight
% for ii=1:length(Xdat)
%     Xdat{ii}=Xdat{ii}+(min(xVals(:))-1)*ones(size(Xdat{ii}));
%     set(h(ii),'XData',Xdat{ii});
% end
% for k = 1:length(h)
%     zdata = h(k).ZData;
%     h(k).CData = zdata;
%    h(k).FaceColor = 'interp';
% end
% 
% 
% axis([(min(xVals(:))-0.5) (max(xVals(:))+0.5) min(yVals(:))-0.5, max(yVals(:))+0.5]) 
% xlabel('n');
% ylabel('m');
% zlabel('Mode');
% title("In (入射端)");
% xlim([-1 2]);
% ylim([-5 5]);
% % 
% subplot(122)
% h = bar3(yVals,r_mode);
% Xdat=get(h,'XData');
% 
% axis tight
% for ii=1:length(Xdat)
%     Xdat{ii}=Xdat{ii}+(min(xVals(:))-1)*ones(size(Xdat{ii}));
%     set(h(ii),'XData',Xdat{ii});
% end
% for k = 1:length(h)
%     zdata = h(k).ZData;
%     h(k).CData = zdata;
%    h(k).FaceColor = 'interp';
% end
% 
% 
% axis([(min(xVals(:))-0.5) (max(xVals(:))+0.5) min(yVals(:))-0.5, max(yVals(:))+0.5]) 
% xlabel('n');
% ylabel('m');
% zlabel('Mode');
% title("r (入射端)");
% xlim([-1 2]);
% ylim([-5 5]);

% set(gcf,'OuterPosition', [-7	33	1936	1056]);
% 
% file_name2 = strcat(figure_name,'\','Mode-cot-',num2str(cotton_num),'-Excited-mode-',input_mode,'-f-',num2str(f),'.png');
% saveas(f2, file_name2);
% close;

% 
% figure
% plot(modez)
% figure
% plot(modef)
% subplot(223)
% h = bar3(yVals,tz_mode);
% Xdat=get(h,'XData');
% 
% axis tight
% for ii=1:length(Xdat)
%     Xdat{ii}=Xdat{ii}+(min(xVals(:))-1)*ones(size(Xdat{ii}));
%     set(h(ii),'XData',Xdat{ii});
% end
% for k = 1:length(h)
%     zdata = h(k).ZData;
%     h(k).CData = zdata;
%    h(k).FaceColor = 'interp';
% end
% 
% 
% axis([(min(xVals(:))-0.5) (max(xVals(:))+0.5) min(yVals(:))-0.5, max(yVals(:))+0.5]) 
% xlabel('n');
% ylabel('m');
% zlabel('Mode');
% title("t (透射端)");
% 
% subplot(224)
% h = bar3(yVals,tf_mode);
% Xdat=get(h,'XData');
% 
% axis tight
% for ii=1:length(Xdat)
%     Xdat{ii}=Xdat{ii}+(min(xVals(:))-1)*ones(size(Xdat{ii}));
%     set(h(ii),'XData',Xdat{ii});
% end
% for k = 1:length(h)
%     zdata = h(k).ZData;
%     h(k).CData = zdata;
%    h(k).FaceColor = 'interp';
% end
% 
% 
% axis([(min(xVals(:))-0.5) (max(xVals(:))+0.5) min(yVals(:))-0.5, max(yVals(:))+0.5]) 
% xlabel('n');
% ylabel('m');
% zlabel('Mode');
% title("r (透射端)");
%% Energy
Am_in = abs(modez).^2;
Am_r = abs(modef).^2;
% % Am_t = abs(modet).^2;
% % Am_tz = abs(modetz).^2;
% % Am_tf = abs(modetf).^2;
% 
In = (Am_in.*kz).'; %将列转变成行
ER = (Am_r.*kz).'; %将列转变成行
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
Er = (real(phi1.*ER)).';


% %%% 利用所有能量的总和做归一化





In_e_mode = Ein./sum(Ein);
R_e_mode = Er./sum(Ein);


Ein2 = zeros(u,v);
Er2 = zeros(u,v);
Etz2 = zeros(u,v);
Etf2 = zeros(u,v);
In_e_mode2 = zeros(u,v);
R_e_mode2 = zeros(u,v);
% T_e_mode2 = zeros(u,v);
T_z_mode2 = zeros(u,v);
T_f_mode2 = zeros(u,v);
for i=1:u
    for j=1:v

        for mm=1:length(name_s)
            if strcmp(name{i,j},name_s{mm})
               Ein2(i,j) = Ein(mm);
               Er2(i,j) = Er(mm);
               % Etz2(i,j) = Etz(mm);
               % Etf2(i,j) = Etf(mm);
               R_e_mode2(i,j) = R_e_mode(mm);
               In_e_mode2(i,j) = In_e_mode(mm);
               % T_z_mode2(i,j) = T_z_mode(mm);
               % T_f_mode2(i,j) = T_f_mode(mm);
            end
        end
    end


end
% 
% 
 Ein2_g = Ein2;
  % out = [{Ein2},{Er2}];
  out = Ein2_g(10:12,1);
% 
% 
% % opti1=strcmp(name,'p10');
% % [line10,lie10] = find(opti1==1);
% % Ein2_g(line10,lie10);
% 
% 
% % 
% f3=figure;
% % % subplot(221)
% h = bar3(yVals, Ein2_g);
% Xdat=get(h,'XData');
% 
% axis tight
% for ii=1:length(Xdat)
%     Xdat{ii}=Xdat{ii}+(min(xVals(:))-1)*ones(size(Xdat{ii}));
%     set(h(ii),'XData',Xdat{ii});
% end
% for k = 1:length(h)
%     zdata = h(k).ZData;
%     h(k).CData = zdata;
%    h(k).FaceColor = 'interp';
% end
% 
% 
% axis([(min(xVals(:))-0.5) (max(xVals(:))+0.5) min(yVals(:))-0.5, max(yVals(:))+0.5]) 
% xlabel('n');
% ylabel('m');
% zlabel('E');
% title(strcat('Incident Energy (入射端)','f=',num2str(freq)));
% xlim([-1 3]);
% ylim([-6 6]);
% zlim([-0.01 1.01]);
% 
% 
% subplot(222)
% h = bar3(yVals,Er2);
% Xdat=get(h,'XData');
% 
% axis tight
% for ii=1:length(Xdat)
%     Xdat{ii}=Xdat{ii}+(min(xVals(:))-1)*ones(size(Xdat{ii}));
%     set(h(ii),'XData',Xdat{ii});
% end
% for k = 1:length(h)
%     zdata = h(k).ZData;
%     h(k).CData = zdata;
%    h(k).FaceColor = 'interp';
% end
% 
% 
% axis([(min(xVals(:))-0.5) (max(xVals(:))+0.5) min(yVals(:))-0.5, max(yVals(:))+0.5]) 
% xlabel('n');
% ylabel('m');
% zlabel('E');
% title(strcat('Reflected Energy ','f=',num2str(freq)));
% xlim([-1 3]);
% ylim([-5 5]);
% 
% subplot(223)
% h = bar3(yVals,In_e_mode2);
% Xdat=get(h,'XData');
% 
% axis tight
% for ii=1:length(Xdat)
%     Xdat{ii}=Xdat{ii}+(min(xVals(:))-1)*ones(size(Xdat{ii}));
%     set(h(ii),'XData',Xdat{ii});
% end
% for k = 1:length(h)
%     zdata = h(k).ZData;
%     h(k).CData = zdata;
%    h(k).FaceColor = 'interp';
% end
% 
% 
% axis([(min(xVals(:))-0.5) (max(xVals(:))+0.5) min(yVals(:))-0.5, max(yVals(:))+0.5]) 
% zlim([0,1])
% xlabel('n');
% ylabel('m');
% zlabel('E (Ratio)');
% title(strcat('Transmitted Energy (Ratio)','f=',num2str(freq)));
% xlim([-1 3]);
% ylim([-5 5]);
% 
% subplot(224)
% h = bar3(yVals,R_e_mode2);
% Xdat=get(h,'XData');
% 
% axis tight
% for ii=1:length(Xdat)
%     Xdat{ii}=Xdat{ii}+(min(xVals(:))-1)*ones(size(Xdat{ii}));
%     set(h(ii),'XData',Xdat{ii});
% end
% for k = 1:length(h)
%     zdata = h(k).ZData;
%     h(k).CData = zdata;
%    h(k).FaceColor = 'interp';
% end
% 
% zlim([0,1])
% axis([(min(xVals(:))-0.5) (max(xVals(:))+0.5) min(yVals(:))-0.5, max(yVals(:))+0.5]) 
% xlabel('n');
% ylabel('m');
% zlabel('E (Ratio)');
% title(strcat('Reflected Energy (Ratio)','f=',num2str(freq)));
% xlim([-1 3]);
% ylim([-5 5]);

% set(gcf,'OuterPosition', [-7	33	1936	1056]);
% 
% file_name3 = strcat(figure_name,'\','E-cot-',num2str(cotton_num),'-Excited-mode-',input_mode,'-f-',num2str(f),'.png');
% saveas(f3, file_name3);
% close;
%%
% figure
% subplot(131)
% h = bar3(yVals,R_e_mode2);
% Xdat=get(h,'XData');
% 
% axis tight
% for ii=1:length(Xdat)
%     Xdat{ii}=Xdat{ii}+(min(xVals(:))-1)*ones(size(Xdat{ii}));
%     set(h(ii),'XData',Xdat{ii});
% end
% for k = 1:length(h)
%     zdata = h(k).ZData;
%     h(k).CData = zdata;
%    h(k).FaceColor = 'interp';
% end
% 
% 
% axis([(min(xVals(:))-0.5) (max(xVals(:))+0.5) min(yVals(:))-0.5, max(yVals(:))+0.5]) 
% xlabel('n');
% ylabel('m');
% zlabel('Ratio');
% title('Reflectance (入射端)');
% 
% subplot(132)
% h = bar3(yVals,T_z_mode2);
% Xdat=get(h,'XData');
% 
% axis tight
% for ii=1:length(Xdat)
%     Xdat{ii}=Xdat{ii}+(min(xVals(:))-1)*ones(size(Xdat{ii}));
%     set(h(ii),'XData',Xdat{ii});
% end
% for k = 1:length(h)
%     zdata = h(k).ZData;
%     h(k).CData = zdata;
%    h(k).FaceColor = 'interp';
% end
% 
% 
% axis([(min(xVals(:))-0.5) (max(xVals(:))+0.5) min(yVals(:))-0.5, max(yVals(:))+0.5]) 
% xlabel('n');
% ylabel('m');
% zlabel('Ratio');
% title('Transmissivity (透射端)');
% 
% subplot(133)
% h = bar3(yVals,T_f_mode2);
% Xdat=get(h,'XData');
% 
% axis tight
% for ii=1:length(Xdat)
%     Xdat{ii}=Xdat{ii}+(min(xVals(:))-1)*ones(size(Xdat{ii}));
%     set(h(ii),'XData',Xdat{ii});
% end
% for k = 1:length(h)
%     zdata = h(k).ZData;
%     h(k).CData = zdata;
%    h(k).FaceColor = 'interp';
% end
% 
% 
% axis([(min(xVals(:))-0.5) (max(xVals(:))+0.5) min(yVals(:))-0.5, max(yVals(:))+0.5]) 
% xlabel('n');
% ylabel('m');
% zlabel('Ratio');
% title('Reflectance (透射端)');


% % 生成5个随机数
% random_nums = rand(1, 5);
% 
% % 将随机数归一化，使其和为1
% normalized_nums = random_nums / sum(random_nums);

% f4 = figure;
% subplot(131)
% plot(Ein,'-o')
% title(strcat("In Energy f=",num2str(f)))
% subplot(132)
% plot(Er,'-o')
% title("R")
% subplot(133)
% plot(Er./sum(Ein),'-o')
% title("R/sum(In)")
% set(gcf,'OuterPosition', [-7	33	1936	1056]);
% file_name4 = strcat(figure_name,'\','E-Line-cot-',num2str(cotton_num),'-Excited-mode-',input_mode,'-f-',num2str(f),'.png');
% saveas(f4, file_name4);
% close;

%% 模式能量提取
% In
% 10 mode
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