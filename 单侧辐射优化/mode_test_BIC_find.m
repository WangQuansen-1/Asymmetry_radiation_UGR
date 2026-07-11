function opti_mode = mode_test_BIC_find(x)

global model
% 
% model.param('par5').set('th1_n', num2str(x(1)));
% model.param('par5').set('th2_n', num2str(x(2)));
% model.param('par5').set('r1n', num2str(x(3)));
% model.param('par5').set('r2n', num2str(x(4)));
% model.param('par5').set('z1_n', num2str(x(5)));
% model.param('par5').set('z2_n', num2str(x(6)));

model.param('par6').set('disz1_n', num2str(x(1)));

% model.param("par5").set("dis_c2_x2n",  num2str(x(8)));
% model.param("par5").set("dis_c2_x1n",  num2str(x(9)));
% model.param("par5").set("dis_c2_x3n",  num2str(x(10)));
% model.param("par5").set("dis_c2_x4n",  num2str(x(11)));




% model.study("std3").run();% 点源辐射优化

model.study("std1").run();
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
dset = 'dset1';%点源
% freq = 3096;
f1 = mphglobal(model,'freq','dataset',dset);
freq = real(f1);
f_imag = imag(f1);
Q = log10(freq./(2*f_imag));


model.sol('sol1').clearSolutionData;

freq_low = 280;
freq_high = 3200;
% 
freq_range = find(freq >= freq_low & freq <= freq_high);
err = abs(Q(freq_range)-8).^2;
% 
% err = (abs(out1(freq_range))-1).^2 + (abs(out2(freq_range))-1).^2;
% opti_mode1 = min(err(:));
% 
% 
% [id,~] = find(err==opti_mode1);
% f_imag1 = (f_imag(id));
% % opti2 = abs(fu-0.06)^2;
% opti_mode = opti_mode1+f_imag1;
opti_mode = min(err(:));

%%
% err = (abs(out1)-1).^2 + (abs(out2)-1).^2;
% % 
% opti_mode = min(err(:));

end