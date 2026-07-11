
clc;clearvars -except model Lambda;close all; 
global model
unit = 100*1e-3;

 
R = 1/2*unit;
L = 30*unit;

cu =1;%环绕的圈数
% mic_num = 8;

mic_anglur_num = 8;

mic_z_num = 1;
mic_num = mic_anglur_num*mic_z_num  ;
D = 100;
z = 20;
z_t = 0/2;
sol = 1;
dset = 'dset1';
freq = real(mphglobal(model,'freq','dataset',dset));

freq_i = freq>3300;
freq(freq>3300) = [];
indx_i = find(freq_i ==1);

z1 = 0.2;
z2 = -0.2;

% 透射端
[mg_t1,ph_t1] = comsol_tiqu(mic_anglur_num,z1,mic_z_num,R,dset); % 0.2 +; -0.2 -;
[mg_t2,ph_t2] = comsol_tiqu(mic_anglur_num,z2,mic_z_num,R,dset); % 0.2 +; -0.2 -;

mg_t1(indx_i,:) = []; ph_t1(indx_i,:) = [];
mg_t2(indx_i,:) = []; ph_t2(indx_i,:) = [];

for index=7:length(freq)

% model.result().dataset(dset).set("solution", strcat("sol",num2str(sol(index))));


 out1(index,:) = mode_mn_t_r(mg_t1(index,:),ph_t1(index,:),freq(index),mic_anglur_num,mic_num,mic_z_num,D,z,z_t,z1);
 out2(index,:) = mode_mn_t_r(mg_t2(index,:),ph_t2(index,:),freq(index),mic_anglur_num,mic_num,mic_z_num,D,z,z_t,z2);
end






