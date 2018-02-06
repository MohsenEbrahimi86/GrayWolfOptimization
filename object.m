function  searchagent = object(searchagent)

x = searchagent.Position;

global NFE;
if isempty(NFE)
    NFE=0;
end

NFE=NFE+1;

t=1000;

S=length(x);

Alfa=[2.33e-05, 1.45e-05, 0.541e-05, 8.05e-05, 1.95e-05];
Beta=[1.5, 1.5, 1.5, 1.5, 1.5];
WVV=[1 2 3 4 2];
W=[7 8 8 6 9];

Wmax=200;
Cmax=175;
Vmax=110;

Reliability=zeros(1,S);
n=zeros(1,S);
r=zeros(1,S);

for i=1:S
    
    landa=x(1,i);
    n(1,i)=x(2,i);
    
    if landa<.00001
        Reliability(i)=-10000;
        break;
    end
    
    r(1,i)=exp(-landa*t);
    
    if r(1,i)<0.50|| r(1,i)==0
        Reliability(i)=-10000;
        break;
    end
    
    Reliability(i)=1-((1-r(1,i))^n(i));
end

S1=1.1;
S2=1.05;
S3=1.1;


penalty1=S1*(max(sum(WVV().*(n().^2))-Vmax,0));
penalty2=S2*(max(sum(Alfa().*((-1000./log(r())).^Beta()).*(n()+exp(0.25*n())))-Cmax,0));
penalty3=S3*(max(sum(W().*n().*exp(0.25*n()))-Wmax,0));

searchagent.SubReli=Reliability();
searchagent.ri= r();
searchagent.slack=[(max(Vmax-sum(WVV().*(n().^2)),0)), (max(Cmax-sum(Alfa().*((-1000./log(r())).^Beta()).*(n()+exp(0.25*n()))),0)),(max(Wmax-sum(W().*n().*exp(0.25*n())),0))];


Reli = prod(Reliability);
searchagent.Reli = 1 - Reli + penalty1 + penalty2 + penalty3;

if sum(searchagent.SubReli())<0
    searchagent.Reli=1000;
end

end
