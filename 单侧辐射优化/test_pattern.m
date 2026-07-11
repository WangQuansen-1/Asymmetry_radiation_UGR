% %test
% Z = x0
% mode_r(Z)

clc;clearvars -except model Lambda;close all;
global model

%% 2026.03.13转移优化目标两侧相同手性
x = [0.2,0.2,0.45,0.99687,0.89922,0.20391,0,10/179,1];
   % opti_mode = mode_test(x)
% opti_mode = mode_test_radi_s(x1)
% opti_mode = mode_test2()
global model
tic 
fun1 = @mode_test;
% fun2 = @s;
% fun3 = @effici;
%
rng default
numberOfVariables = length(x);

% lb = [-10,10];0
% ub = -lb;
th1_min = 10;
th1_max = 180;
b1 = (160-2*th1_min)./(th1_max-th1_min);
A = [1,1,zeros(1,numberOfVariables-2)];
b = [b1];
% A = [1,0];
% b = [0.25];
Aeq = [];
beq = [];
lb = [ones(1,numberOfVariables)*0.1];%1 3 5 7是阻 2 4 6 8是抗
ub = [ones(1,numberOfVariables)*1];
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


