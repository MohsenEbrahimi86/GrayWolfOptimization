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

searchagents_no=30;             % Number of search agents
max_iteration=500;               % Maximum number of generation

%% initialization

empty_individual.Position=[];
empty_individual.Reli=[];
empty_individual.SubReli=[];
empty_individual.ri=[];
empty_individual.slack=[];

searchagent=repmat(empty_individual,[searchagents_no,1]);

%% Initialize position

for i=1:searchagents_no
    
    firstRow=(rand(1,5)*69314)/100000000;   %first row of position-landa(i)
    secondRow=randi([1,5],1,5);             %second row of position-n(i) 
    
    searchagent(i).Position=cat(1,firstRow,secondRow);
    
    %Evaluation
    
    searchagent(i)=object(searchagent(i));
end

% sort searchagents_Reliabilities

Reliabilities=[searchagent.Reli];
[Reliabilities,sortorder]=sort(Reliabilities);
searchagent=searchagent(sortorder);

% find Alpha, Beta & Delta

Alpha=searchagent(1);           %Alpha means best solution
Beta=searchagent(2);            %Beta means second best solution
Delta=searchagent(3);           %Delta means third best solution

% store best position 

bestpos=zeros(1,max_iteration);          %best position

convergence_curve=zeros(1,max_iteration);

l=0;                             %loop counter

%% Main loop

while l<max_iteration
    
        for it=1:max_iteration
        a=2-it*((2)/max_iteration);       %a decrease linearly from 2 to 0
        
        %Define prey position
        
        Prey.Position=(Alpha.Position+Beta.Position+Delta.Position)./3;     %location of prey/optimum/
        
        %Update the position of searchagents
        
        for i=1:searchagents_no
        
        %Update the position of Alpha & Beta & Delta
        
            newposAlpha=UpdatePos(Prey,searchagent(i,:),a);
            newposBeta=UpdatePos(Prey,searchagent(i,:),a);
            newposDelta=UpdatePos(Prey,searchagent(i,:),a);
            
            %Update the position of other searchagents
            
            searchagent(i).position=(newposAlpha+newposBeta+newposDelta)./3;
            
        end
            
            %Check boundaries
            
            searchagent(i).Position=max(searchagent(i).position,lb);
            searchagent(i).Position=min(searchagent(i).position,ub);
            
            %Evaluate
            
            searchagent(i)=object(searchagent(i));
            
            %Update Alpha, Beta & Delta solution
            
            if searchagent(i).Reli>Alpha.Reli
                Alpha=searchagent(i);
                
            elseif searchagent(i).Reli<Alpha.Reli && searchagent(i).Reli>Beta.Reli
                Beta=searchagent(i);
                
            elseif searchagent(i).Reli<Alpha.Reli && searchagent(i).Reli<Beta.Reli && searchagent(i).Reli>Delta.Reli
                Delta=searchagent(i);
                
            end           
                                   
            disp(['in iteration= ' num2str(it) 'Best Reliability=' num2str(Alpha.Reli)]);
        end
        
        l=l+1;
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


