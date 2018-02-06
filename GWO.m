clc;
clear;
close all;
format long;

%% problem definition

Relifunction=@object;          % Reliability function

tstart=tic();

global NFE;
NFE=0;

dim=10;                        % number of decision variables
dim_size=[2,5];                % solution_style

%% Lowerbound & Upperbound of variables
% variables are: landa(i)-n(i)

lb=[0,0,0,0,0;1,1,1,1,1]; % lower bound of variables
ub=[0.00069314,0.00069314,0.00069314,0.00069314,0.00069314;5,5,5,5,5]; % upper bound of variables

%% GWO Parameters

Num_Of_Wolves = 30;             % Number of search agents
Num_Of_Iterations = 500;               % Maximum number of generation

%% initialization

empty_individual.Position=[];
empty_individual.Reli=[];
empty_individual.SubReli=[];
empty_individual.ri=[];
empty_individual.slack=[];

searchagent = repmat(empty_individual,[Num_Of_Wolves,1]);

%% Initialize position

lambda = 69314;
m1 = 100000000;
for i=1:Num_Of_Wolves
    
    r_i_s = (rand(1,5)*lambda)/m1;   %first row of position-landa(i)
    n_i_s = randi([1,5],1,5);             %second row of position-n(i)
    
    searchagent(i).Position=cat(1, r_i_s, n_i_s);
    
    %Evaluation
    searchagent(i) = object(searchagent(i));
end

% sort searchagents_Reliabilities

Reliabilities=[searchagent.Reli];
[Reliabilities,sortorder]=sort(Reliabilities);
searchagent=searchagent(sortorder);

% find Alpha, Beta & Delta

Alpha = searchagent(1);           %Alpha means best solution
Beta  = searchagent(2);           %Beta means second best solution
Delta = searchagent(3);           %Delta means third best solution

% store best position

bestpos=zeros(1,Num_Of_Iterations);          %best position

convergence_curve=zeros(1,Num_Of_Iterations);

%Define prey position
Prey.Position = (Alpha.Position+Beta.Position+Delta.Position)/3;     %location of prey/optimum/
a = 2;
A = 4;
C = 2*rand();

%% Main loop

for l = 1:Num_Of_Iterations
    
    for it=1:Num_Of_Iterations
        
        %Update the position of searchagents
        for i = 1:Num_Of_Wolves
            searchagent(i).Position = UpdatePos(Prey,searchagent(i,:),a);
        end
        
        a = 2 - it*(2 / Num_Of_Iterations);       %a decrease linearly from 2 to 0
        
        %Check boundaries
        for i = 1:Num_Of_Wolves
            searchagent(i).Position = max(searchagent(i).Position,lb);
            searchagent(i).Position = min(searchagent(i).Position,ub);
        end
        %Evaluate Fitness
        for i = 1:Num_Of_Wolves
            searchagent(i) = object(searchagent(i));
        end
        Reliabilities = [searchagent.Reli];
        [Reliabilities, sortorder] = sort(Reliabilities);
        searchagent = searchagent(sortorder);
        
        Alpha = searchagent(1);
        Beta  = searchagent(2);
        Delta = searchagent(3);
        
        %Update Alpha, Beta & Delta solution
        
        disp(['in iteration= ' num2str(it) ' Best Reliability=' num2str(Alpha.Reli)]);
    end
    convergence_curve(l)=Alpha.Reli;
end

%% Results

toc(tstart);

disp(['best fitness =  ' num2str(Alpha.Reli)]);disp(' ');
disp('best position=  ');disp(Alpha.Position);

figure;
plot(convergence_curve, 'linewidth',2);
xlabel('Iteration');
ylabel('Reliability');


