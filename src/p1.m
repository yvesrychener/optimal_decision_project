%%%%%%%%%%%%%%%%%%%%%% MGT-483 Optimal Decision Making %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Project / Question 1 %%%%%%%%%%%%%%%%%%%%%%%%%%
%%          Wasserstein Distance           %%

%% Prepare the workspace
clear
clc
close all
%% Distributions

P = [1/2, 1/3, 1/6];
Q = [2/5, 3/5];
loc_s = [1, 2, 3];
loc_d = [1, 2];
%% Compute cost function
dist = pdist2(loc_s', loc_d', 'squaredeuclidean');

%% Optimization problem
% decision variables
trans_map = sdpvar(size(P,2), size(Q,2), 'full');      
% constraints
con = [trans_map>=0, sum(trans_map,2)==P', sum(trans_map,1)==Q];

% objective
obj = sum(sum(dist.*trans_map));

% solution
ops = sdpsettings('solver','gurobi','verbose',0);
diag = optimize(con, obj, ops)

% read optimal objective
wass_dist = value(obj); 
