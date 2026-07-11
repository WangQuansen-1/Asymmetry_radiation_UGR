function opti_mode = mode_test_radi_s(x)

global model
% 
model.param('par5').set('th1_n', num2str(x(1)));
model.param('par5').set('th2_n', num2str(x(2)));
model.param('par5').set('r1n', num2str(x(3)));
model.param('par5').set('r2n', num2str(x(4)));
model.param('par5').set('z1_n', num2str(x(5)));
model.param('par5').set('z2_n', num2str(x(6)));

model.param('par5').set('zi_n', num2str(x(7)));

model.param("par5").set("dis_c2_x2n",  num2str(x(8)));
model.param("par5").set("dis_c2_x1n",  num2str(x(9)));
model.param("par5").set("dis_c2_x3n",  num2str(x(10)));
model.param("par5").set("dis_c2_x4n",  num2str(x(11)));



% model.geom('geom1').feature('rot5').active(false);
% model.study("std3").run();% 点源辐射优化


% model.study("std1").run();
unit = 100*1e-3;

R = 1/2*unit;
L = 30*unit;

cu = 1;

mic_anglur_num = 4;
mic_z_num = 1;

mic_num = mic_anglur_num*mic_z_num;

D = 100;
z = 20;
z_t = 0/2;

% sol = 1;
% dset = 'dset1';%特征频率
dset = {'dset3','dset5','dset6'};%点源
freq = 3000;
f2 = 3096;
% f1 = mphglobal(model,'freq','dataset',dset);
% freq = real (f1);

z1 = 0.45;
z2 = -0.45;

    % 
    %% 辐射
%     % 透射端
%     [mg_t1,ph_t1] = comsol_tiqu(mic_anglur_num,z1,mic_z_num,R,dset{1});
%     [mg_t2,ph_t2] = comsol_tiqu(mic_anglur_num,z2,mic_z_num,R,dset{1});
% 
% 
% 
%         out1 = mode_mn_t_r(mg_t1,ph_t1, ...
%             freq,mic_anglur_num,mic_num,mic_z_num,D,z,z_t,z1);
% 
%         out2= mode_mn_t_r(mg_t2,ph_t2, ...
%             freq,mic_anglur_num,mic_num,mic_z_num,D,z,z_t,z1);
% model.sol('sol3').clearSolutionData;

%% 散射
% model.geom('geom1').feature('rot5').active(true);

model.study("std5").run();

[mg_t_1,ph_t_1] = comsol_tiqu2(mic_anglur_num,0.45,mic_z_num*2,R,dset{2});

model.sol('sol5').clearSolutionData;
model.study("std6").run();

[mg_t_2,ph_t_2] = comsol_tiqu2(mic_anglur_num,0.45,mic_z_num*2,R,dset{3});

model.sol('sol6').clearSolutionData;
 % out_in = mode_mn_t_r(mg_i(index,:).',ph_i(index,:).',freq(index),mic_anglur_num,mic_num,mic_z_num,D,z,z_t);
 % In = out_in{1,1}(10,1);
 In = 0.0809;
  % In = out_in{1,1}(13,1)+out_in{1,1}(9,1);

 % Rn(:,index) = out_in{1,2}(10:12,1)./In;
  % Rn(:,index) = out_in{1,2}(9:13,1)./In;
 out_t1   = mode_mn_t1_r(mg_t_1.',ph_t_1.',f2,mic_anglur_num,mic_num*2,mic_z_num*2,D,z,z_t);
 out_t2   = mode_mn_t1_r(mg_t_2.',ph_t_2.',f2,mic_anglur_num,mic_num*2,mic_z_num*2,D,z,z_t);
 T_1 = out_t1{1,1}(12,1)./In;
 % T_2 = (out_t2{1,1}(12,1))./In;
 T_22 = sum(sum(out_t2{1,1}(10:12,1)))./In;
% den = abs(T_1) + abs(T_2) ;   % 防止分母为0
% opti1 = (abs(T_1) - abs(T_2))./den;
    %%
    % err = (abs(out1)-1).^2 + (abs(out2)-1).^2+(abs(opti1)-1).^2+(abs(T_1)-1).^2;
    %
% opti_mode = (abs(out1)-1)^2 + (abs(out2)-1)^2  + (abs(T_1)-1)^2+ (abs(T_22)-0)^2;
opti_mode =  (abs(T_1)-1)^2+ (abs(T_22)-0)^2;

end