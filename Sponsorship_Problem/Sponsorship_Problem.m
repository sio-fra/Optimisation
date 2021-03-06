
% the rank that each sponsor gives to each competitor
R_s_to_c=[5    3    2    0    4    3    1    1    3    3;
        2    0    4    0    5    3    4    1    6    1;
        2    5    1    2    4    3    2    5    4    1;
        5    0    3    4    5    4    3    3    4    5;
        1    2    5    3    4    0    0    5    2    4;
        3    3    1    4    1    2    1    3    3    4;
        3    3    4    0    3    1    2    1    1    3;
        1    3    1    0    4    2    2    0    0    4];
    
    
  % the rank that each competitor gives to each sponsor 
  R_c_to_s=[3    3    5    0    1    1    5    4    5    2;
            3    0    5    2    3    4    2    3    5    1;
            3    0    0    1    5    0    3    1    2    3;
            0    1    1    2    4    3    1    1    4    1;
            0    0    5    2    0    3    4    2    4    4;
            3    2    2    2    2    1    2    0    3    0;
            5    5    2    5    5    5    5    0    1    2;
            0    4    1    2    1    2    5    0    0    2];
        
%construct consensus matrix c and reshape it to form a vector that can be
%fed into the intlinprog module
C= R_s_to_c.*R_c_to_s;
C=-(reshape(C', [1,8*10]));


%construct a matrix Ar such that each sponsor can have at most 4
%competitors
ones_r=ones(1, 10);
zeros_r=zeros(1, 10);

Ar=[ones_r zeros_r zeros_r zeros_r zeros_r zeros_r zeros_r zeros_r;
    zeros_r ones_r zeros_r zeros_r zeros_r zeros_r zeros_r zeros_r;
    zeros_r zeros_r ones_r zeros_r zeros_r zeros_r zeros_r zeros_r;
    zeros_r zeros_r zeros_r ones_r zeros_r zeros_r zeros_r zeros_r;
    zeros_r zeros_r zeros_r zeros_r ones_r zeros_r zeros_r zeros_r;
    zeros_r zeros_r zeros_r zeros_r zeros_r ones_r zeros_r zeros_r;
    zeros_r zeros_r zeros_r zeros_r zeros_r zeros_r ones_r zeros_r;
    zeros_r zeros_r zeros_r zeros_r zeros_r zeros_r zeros_r ones_r;];

br=[4; 4; 4; 4; 4; 4; 4; 4];


%construct a matrix Ac such that each competitor can have at most 5
%sponsors

I=eye(10);
    
Ac=[I I I I I I I I];

bc=[5; 5; 5; 5; 5; 5; 5; 5; 5; 5];

A=[Ar;Ac];

b=[br;bc];

%all variables must be integer values
intcon=1:length(C); 

%all variables must be boolean
lb=zeros(10*8, 1);
ub=ones(10*8, 1);

[xopt,pval,exitflag,output] = intlinprog(C',intcon,A,b,[],[],lb,ub);
pval=-pval %revert back to maximisation
xopt=reshape(xopt, [10, 8]);
xopt=xopt';
xopt