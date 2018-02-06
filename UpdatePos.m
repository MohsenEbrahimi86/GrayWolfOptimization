function newpos = UpdatePos(Prey,searchagent, C, A)

n = size(searchagent.Position,2);
newpos = zeros(2,n);
newpos(2,:) = searchagent.Position(2,:);
% D_alpha = zeros(1,n);
for j = 1:n
    D_alpha = abs(C(1)*Prey.Position(j)-searchagent.Position(j)); % Equation (3.1)
    D_beta  = abs(C(2)*Prey.Position(j)-searchagent.Position(j)); % Equation (3.1)
    D_delta = abs(C(3)*Prey.Position(j)-searchagent.Position(j)); % Equation (3.1)
    
    X1 = Prey.Position(j) - A(1)*D_alpha;         % Equation (3.2)
    X2 = Prey.Position(j) - A(2)*D_beta;          % Equation (3.2)
    X3 = Prey.Position(j) - A(3)*D_delta;         % Equation (3.2)
     
     newpos(j) = (X1 + X2 + X3)/3;
end
end