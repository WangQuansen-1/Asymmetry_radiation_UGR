clc;clearvars -except model Lambda;close all;
global model

% mode test

unit = 100*1e-3;

R = 1/2*unit;
L = 30*unit;

cu = 1;

mic_anglur_num = 4;
mic_z_num = 2;

mic_num = mic_anglur_num*mic_z_num;

D = 100;
z = 20;
z_t = 20;

sol = 1;
dset = 'dset1';

% freq = real(mphglobal(model,'freq','dataset',dset));
% freq = 2602.6-50:2602.6+50;
% freq = 2672.7-10:0.1:2672.7+100;
freq = [2771.5,2772.5];
% freq = 2602.6;
tu = 1;
z1 = 0.2;
z2 = -0.2;

% 透射端
[mg_t1,ph_t1] = comsol_tiqu2(mic_anglur_num,z1,mic_z_num,R,dset);
% [mg_t2,ph_t2] = comsol_tiqu(mic_anglur_num,z2,mic_z_num,R,dset);

for index = 7:8%length(freq)

    out1(:,index) = mode_mn_t_r1(mg_t1(index,:),ph_t1(index,:), ...
        freq(index-6),mic_anglur_num,mic_num,mic_z_num,D,z,z_t,tu);

    % out2(index,:) = mode_mn_t_r1(mg_t2(index,:),ph_t2(index,:), ...
    %     freq(index),mic_anglur_num,mic_num,mic_z_num,D,z,z_t,z2);

end

figure
plot(freq,out1(1,:));
hold on
plot(freq,out1(2,:));
plot(freq,out1(3,:));
xlabel("Freq");
ylabel("E_mode");
legend("-1","0","+1")

% -------------------------
% 新的优化目标
% -------------------------


freq_low = 2400;
freq_high = 3100;

freq_range = find(freq >= freq_low & freq <= freq_high);

err = (abs(out1(freq_range))-1).^2 + (abs(out2(freq_range))-1).^2;

opti_mode = min(err(:));