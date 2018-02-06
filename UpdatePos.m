function newpos=UpdatePos(Prey,searchagent,a)

for j=1:size(searchagent.Position,2)
    
    r1=rand();                   % r1 is a random number in [0,1]    
    r2=rand();                   % r2 is a random number in [0,1]
    
    A1=2*a*r1-a;                 % Equation (3.3)
    C1=2*r2;                     % Equation (3.4)
    
    D=abs(C1*Prey.Position(j)-searchagent.Position(j)); % Equation (3.1)
    
    newpos(j)=Prey.Position(j)-A1*D;         % Equation (3.2)
    
end