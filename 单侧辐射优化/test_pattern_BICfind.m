% %test
% Z = x0
% mode_r(Z)

clc;clearvars -except model Lambda;close all;
global model
% x1 = [0.102944946289063	0.100015258789063	0.650672531127930
% 0.100000000000000	0.998437500000000	0.998431777954102]; %实例1
% x1 = [0.534593200683594	0.100076293945313	0.150550460815430	0.100003814697266	0.982812500000000	0.834537124633789];  % 修改结构主参数，太长不好激发
% x1 = [0.616616821289063	0.325112915039063	0.650672531127930	0.500000000000000	0.498189544677734	0.494525527954102];
% x1 = [0.631253814697266	0.146878814697266	0.999429321289062	0.338285064697266	0.853906250000000	0.925195312500000];
% x1 = [0.833251317753861	0.915212743368057	0.214288134664155	0.922038270525117	0.669123321602869	0.187786364499469];%正反手性相同
% x1 = [0.599542236328125	0.100003814697266	0.823175048828125	0.976651763916016	0.177819824218750	0.943742370605469];% r方向需要被进一步压缩，前后两个模式相反辐射的可以，讨论扫射性质和对称的性质
% x1 = [0.100000000000000	0.654687500000000	0.788476562500000	0.100000000000000	0.100488281250000	0.363793945312500];
% x1 = [0.618161773681641	0.100003814697266	0.823419189453125	0.821019744873047	0.177819824218750	0.853896713256836];%利用点源辐射进行的优化
% x1 = [0.473046875000000	0.100000000000000	0.100000000000000	0.600061035156250	0.741109466552734	0.100240325927734];
x1 = [0.678125000000000	0.115625000000000	0.816552734375000	0.600000000000000	0.369531250000000	0.111718750000000	0	0.0971679687500000	0.992187500000000	0.929687500000000	0.0468750000000000];%中间管道压缩左右不通手性辐射
x1 = [0.678125000000000	0.100000000000000	0.925927734375000	0.600976562500000	0.650781250000000	0.111718750000000	0.500000000000000	0.597167968750000	0.992187500000000	0.867187500000000	0.0156250000000000];%中间没有管道，腔内点源辐射
x1 = [0.271875000000000	0.131250000000000	0.404111480712891	0.599267578125000	0.998437500000000	0.100000000000000	0	0.983398437500000	0.0332031250000000	0.730712890625000	1];
%% 2026.03.13转移优化目标两侧相同手性
   % opti_mode = mode_test(x1)
% opti_mode = mode_test_radi_s(x1)

global model
tic 
fun1 = @mode_test_BIC_find;
% fun2 = @s;
% fun3 = @effici;
%
rng default
numberOfVariables =1;

% lb = [-10,10];0
% ub = -lb;
th1_min = 10;
th1_max = 180;
b1 = (160-2*th1_min)./(th1_max-th1_min);
A = [];
b = [];
Aeq = [];
beq = [];
lb = [0];%1 3 5 7是阻 2 4 6 8是抗
ub = [1];
nonlcon = [];

% x0 =  [0.534593200683594	0.100076293945313	0.450550460815430	0.100003814697266	0.982812500000000	0.334537124633789];
% x0 = lb + (ub - lb).*rand(1, numberOfVariables);
x0 = (lb+ub)/2;
% x0 = x1;
% x0 = [0.599542236328125	0.500003814697266	0.823175048828125	0.976651763916016	0.177819824218750	0.943742370605469];
% nonlcon = @non;
% options = optimoptions('particleswarm','SwarmSize',10);
% options = optimoptions(options,'PlotFcn',@pswplotbestf);


% options = optimoptions('ga','PlotFcn',@gaplotbestf);
% options = optimoptions(options,'Display','iter');

options = optimoptions('patternsearch','Display','iter','PlotFcn',@psplotbestf);

% 
% options = optimoptions(options,'MaxGenerations',200);%最大迭代次数 100*nvars
% options = optimoptions(options,'PopulationSize',100);%种群个数
% 越大探索的范围越好，但是速度就会受到影响
% options = optimoptions(options,'CrossoverFraction',0.8);%交叉概率
% options = optimoptions(options,'MigrationFraction',0.2);%突变概率
% options = optimoptions(options,'SelectionFcn',@selectiontournament);%交叉突变的方式
% options = optimoptions(options,'HybridFcn',{@fgoalattain});%交叉突变的方式
% 在遗传算法结束后继续优化

% options = optimoptions(options,'UseVectorized',false);
% options = optimoptions(options, 'UseParallel', true, 'UseVectorized', false);
% options.HybridFcn = @fmincon;


% options = optimoptions(options,'PlotFcn',@pswplotbestf);
% options = optimoptions(options,'Display','iter');
% options.HybridFcn = @fmincon;
%  [x,fval,exitflag] = particleswarm(fun1,numberOfVariables,lb,ub,options)

%[x1,fval1,exitflag1,output1,population1,scores1] = ga(fun1,numberOfVariables,A,b,Aeq,beq,lb,ub,nonlcon,[],options);

% [x2,fval2,exitflag2,output2,population2,scores2] = ga(fun2,numberOfVariables,A,b,Aeq,beq,lb,ub,nonlcon,[],options);
% [x3,fval3,exitflag3,output3,population3,scores3] = ga(fun3,numberOfVariables,A,b,Aeq,beq,lb,ub,nonlcon,[],options);
[x,fval] = patternsearch(fun1,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);

% options = optimoptions('fmincon','Display','iter','Algorithm','sqp','PlotFcn','optimplotx');
% % options = optimoptions('fmincon','SpecifyObjectiveGradient',true);
% [x,fval] = fmincon(fun1,x0,A,b,Aeq,beq,lb,ub,nonlcon,options) 


% opts = optimoptions(@fmincon,'Algorithm','sqp');
% problem = createOptimProblem('fmincon','x0',ones(1,8),...
%     'objective',mode_r,'lb',ones(1,8),'ub',ones(1,8));
% gs = GlobalSearch;
% [x,f] = run(gs,problem)


