function opti_mode = mode_test2(x)
% function opti_mode = mode_test2()
global model
% 
% model.param('par5').set('th1_n', num2str(x(1)));
model.param('par5').set('th2_n', num2str(x(1)));
% model.param('par5').set('r1n', num2str(x(3)));
model.param('par5').set('r2n', num2str(x(2)));
% model.param('par5').set('z1_n', num2str(x(5)));
% model.param('par5').set('z2_n', num2str(x(6)));

% model.param('par5').set('zi_n', num2str(x(7)));
% 
% model.param("par5").set("dis_c2_x2n",  num2str(x(8)));
% model.param("par5").set("dis_c2_x1n",  num2str(x(9)));
% model.param("par5").set("dis_c2_x3n",  num2str(x(10)));
% model.param("par5").set("dis_c2_x4n",  num2str(x(11)));





% model.study("std1").run();
unit = 100*1e-3;

R = 1/2*unit;
L = 30*unit;

cu = 1;

mic_anglur_num = 4;
mic_z_num = 2;

mic_num = mic_anglur_num*mic_z_num;

D = 100;
z = 20;
z_t = 0/2;

% sol = 1;
% dset = 'dset1';%特征频率
dset = {'dset3'};%点源
sol = {'sol3'};
std = {'std3'};
freq =[ 2602.6];
% f1 = mphglobal(model,'freq','dataset',dset);
% freq = real (f1);
index = 1;
z1 = 0.2;
z2 = -0.2;
zii = [1,-1];
% for u=1:2
u=1;
model.study(std{u}).run();% 点源辐射优化
% 透射端
[mg_t1,ph_t1] = comsol_tiqu(mic_anglur_num,z1,mic_z_num,R,dset{u});
[mg_t2,ph_t2] = comsol_tiqu(mic_anglur_num,z2,mic_z_num,R,dset{u});
model.sol(sol{u}).clearSolutionData;

% for index = 1:length(freq)
index = 1;

    % out1(index,:) = mode_mn_t_r(mg_t1(index,:),ph_t1(index,:), ...
         % freq(index),mic_anglur_num,mic_num,mic_z_num,D,z,z_t,z1);
    % 
    % out2(index,:) = mode_mn_t_r(mg_t2(index,:),ph_t2(index,:), ...
    %     freq(index),mic_anglur_num,mic_num,mic_z_num,D,z,z_t,z1);

        % out1 = mode_mn_t_r(mg_t1(index,:),ph_t1(index,:), ...
        % freq(u),mic_anglur_num,mic_num,mic_z_num,D,z,z_t,zii(1));


    % out2 = mode_mn_t_r(mg_t2(index,:),ph_t2(index,:), ...
    %     freq(u),mic_anglur_num,mic_num,mic_z_num,D,z,z_t,zii(2));
       out1(index,:)   = mode_mn_t_radti(mg_t1(index,:).',ph_t1(index,:).', ...
        freq(index),mic_anglur_num,mic_num,mic_z_num,D,z,z_t);

                out2(index,:)   = mode_mn_tt_radti(mg_t2(index,:).',ph_t2(index,:).', ...
        freq(index),mic_anglur_num,mic_num,mic_z_num,D,z,z_t);


% end
%%
% -------------------------
% 新的优化目标 特征频率优化 
% -------------------------

% 
% freq_low = 2400;
% freq_high = 3200;
% 
% freq_range = find(freq >= freq_low & freq <= freq_high);
% 
% err = (abs(out1(freq_range))-1).^2 + (abs(out2(freq_range))-1).^2;
% opti_mode1 = min(err(:));
% [id,~] = find(err==opti_mode1);
% fu = imag(f1(id));
% opti2 = abs(fu-0.06)^2;
% opti_mode = opti_mode1+opti2;
% end

%%
err = abs(abs(out1)-1).^1 + abs(abs(out2)-1).^1;
% err = abs(abs(out1(1,:))-1).^2 + abs(abs(out2(1,:))-1).^2 + abs(abs(out2(2,:))-1).^2 + abs(abs(out1(2,:))-1).^2;
% 
opti_mode = min(err(:));


end