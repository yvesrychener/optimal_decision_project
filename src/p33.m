%% Optimal Decision Making Group Project
% Sample Average Approximation
% function y = p33(train,test)
% Input: 
% - train: training samples
% - test: testing samples
% Output:
% - y: utility achieved by the optimal decision

% For Exercise 3.3., the input arguments train and test are the same !!!
% Run this function with the matlab variable 'test' obtained by loading
% the file test.mat 
% Fill in the sections marked by '...'
function [y_test, y_train] = p33(train,test)
%% Utility function
a1 = 4; b1 = 0;
a2 = 1; b2 = 0;

%% Number of assets and training periods
K = length(train(1,:));
N = length(train(:,1));

%% Decision Variables
L = N;
u = sdpvar(L,1);
x = sdpvar(K,1);

%% Objective
obj = sum(u);

%% Constraints

con = [x>=0, sum(x)==1];
for i=1:L
    con = [con,u(i)<=a1*train(i,:)*x+b1,u(i)<=a2*train(i,:)*x+b2];
end

%% Optimization Settings
ops = sdpsettings('solver','Gurobi','verbose',0);
diag = optimize(con,-obj,ops);

%% Retrieve portfolio weights 
x = value(x);
%% Evaluate portfolio
u1 = a1*test*x+b1;
u2 = a2*test*x+b2;
u1_t = a1*train*x+b1;
u2_t = a2*train*x+b2;
y_test = mean(min(u1,u2));
y_train = mean(min(u1_t,u2_t));

end