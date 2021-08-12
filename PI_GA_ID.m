function [X,FVAL,REASON,OUTPUT,POPULATION,SCORES]=PI_GA_ID(Pop,Gen, EC, Tol)
% Use POP0=[],SCORE0=[] for the first run

%% Problem Set-up

% Experiment data
% tic
[v, y]=DataT;
M_Data=struct('v',v,'y',y);

% Training input/output data
t_train= [0:10:7720]';
t =t_train;
V_train = v;
y_train = y;
io_data_train=struct('t',t_train,'V',V_train,'y',y_train);

% Validation input/output data

%% GA Implementation

% Fitness function
fitnessFunction = @(x)ga_fit_sim(x,io_data_train);

% Number of Variables
nvars = 11;

% Linear inequality constraints
Aineq = [];
Bineq = [];
% Linear equality constraints
Aeq = [];
Beq = [];
% Bounds
LB =[]; 
UB =[];

% Nonlinear constraints
% nonlconFunction = @(x)Cneq(x);
nonlconFunction = [];

% Start with default options
options = gaoptimset;

% Modify some parameters (see help gaoptimset for a list of tunable options)
options = gaoptimset(options,'PopulationType' ,'doubleVector');
options = gaoptimset(options,'PopulationSize' ,Pop);
options = gaoptimset(options,'InitialPopulation',[],'InitialScore',[]);
options = gaoptimset(options,'EliteCount' ,EC);
options = gaoptimset(options,'CrossoverFraction' ,0.8);
options = gaoptimset(options,'CrossoverFcn' , @crossoverscattered);
options = gaoptimset(options,'MigrationDirection' ,'forward');
options = gaoptimset(options,'MigrationInterval' ,20);
options = gaoptimset(options,'MigrationFraction' ,0.2);
options = gaoptimset(options,'InitialPenalty' ,10);
options = gaoptimset(options,'PenaltyFactor' ,100);
options = gaoptimset(options,'TolFun' ,Tol);
options = gaoptimset(options,'PopInitRange' ,[LB;UB]);
options = gaoptimset(options,'Generations' ,Gen);
options = gaoptimset(options,'FitnessLimit' ,0);
options = gaoptimset(options,'StallGenLimit' ,50);
options = gaoptimset(options,'StallTimeLimit' ,inf);
options = gaoptimset(options,'SelectionFcn' ,@selectionroulette);
options = gaoptimset(options,'FitnessLimit' ,-Inf);
options = gaoptimset(options,'FitnessScalingFcn',@fitscalingprop); 
options = gaoptimset(options,'SelectionFcn' ,@selectionstochunif);
options = gaoptimset(options,'MutationFcn' , @mutationadaptfeasible); 
options = gaoptimset(options,'Display' ,'off');
options = gaoptimset(options,'PlotFcns' ,{ @gaplotbestf });
options = gaoptimset(options,'CreationFcn' ,  @gacreationlinearfeasible );
options = gaoptimset(options,'FitnessScalingFcn' ,{  @fitscalingrank });

options1 = optimset;
options1 = optimset(options1,'Display', 'off');
options1 = optimset(options1,'MaxIter', 1000);
options1 = optimset(options1,'TolFun', Tol);
options1 = optimset(options1,'TolX', Tol);
% options1 = optimset(options1,'PlotFcns', { @optimplotfval });
options = gaoptimset(options,'HybridFcn',   {@fminunc, options1} );

% Run GA
[X,FVAL,REASON,OUTPUT,POPULATION,SCORES] = ga(fitnessFunction,nvars,Aineq,Bineq,Aeq,Beq,LB,UB,nonlconFunction,options);
% [X,FVAL] = pso_Trelea_vectorized(fitnessFunction,nvars);

% Performance over training data
y_sim1=sim_output(X,io_data_train);
% figure,plot(t_train,y_train,'k:',t_train,y_sim1,'r')
% legend('Truth','Identified'),title('Performance over training data')

% Performance over validation data

function f=ga_fit_sim(x,io_data)
%   x: vector of real numbers (parameter values)
%   f: is the fitness function

% optimization variables x
x=x(:);

% input/output data
t_data=io_data.t;
V_data=io_data.V;
y_data=io_data.y;

% fitness evaluation
y_sim = [PI11(x)];
f=norm(y_sim-y_data,2);

function y_sim=sim_output(x,io_data)
%   x: vector of real numbers (parameter values)
%   y_sim: is the simulation output

% optimization variables x
x=x(:);

% input/output data
t_data=io_data.t;
V_data=io_data.V;
y_data=io_data.y;

y_sim = PI11(x);
% toc