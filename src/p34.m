%% Optimal Decision Making Group Project
% Distributionally Robust Optimization
% function y = p34(train, test, rho)
% Input: 
% - train: training samples
% - test: testing samples
% - rho: Wasserstein radius
% Output:
% - y: utility achieved by the optimal decision

% Fill in the sections marked by '...'
function y = p34(train, test, rho)
%% Utility function, Wasserstein radius and norm for the Wasserstein ball
a1 = 4; b1 = 0;
a2 = 1; b2 = 0;

%% Number of assets and training periods
K = length(train(1,:));
N = length(train(:,1));

%% Decision Variables
x = sdpvar(K,1);
l = sdpvar(1);
m = sdpvar(N,1);
j = sdpvar(N,1);
P = 1/N*ones(N,1);
%% Objective
obj = -l*rho-m'*P;

%% Constraints
c = pdist2(train, train, 'squaredeuclidean');

con = [l>=0,sum(x)==1,l*c+ones(N,1)*j'+m*ones(N,1)'>=0,x>=0];
for i = 1:N
    con = [con, j(i)<=a1*train(i,:)*x+b1,j(i)<=a2*train(i,:)*x+b2];
end
    
%% Optimization Settings
ops = sdpsettings('solver','Gurobi','verbose',0);
diag = optimize(con,-obj,ops);

%% Retrieve portfolio weights 
x = value(x);
%% Evaluate portfolio
u1 = a1*test*x+b1;
u2 = a2*test*x+b2;
y = mean(min(u1,u2));

end