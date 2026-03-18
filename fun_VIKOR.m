% Universitat Autònoma de Barcelona (UAB), GENOCOV.
% Alex Gaona Soler, Albert Guisasola Canudas, Juan Antonio Baeza Labat.
% Comments or updates: JuanAntonio.Baeza@uab.cat
% Last Update (08/9/2025)
% % Inputs:
% C: Decision matrix, each row an alternative, each column a criterion
% W: Weights to be used by TOPSIS
% MM: MaxMin vector defining a criterion minimisation (-1) or maximisation (+1)
% v: Strategy parameter in [0,1]. v→1 emphasizes group utility (S); v --> 0 emphasizes the worst criterion or "individual regret" (R). (Typical: v = 0.5)
% % Output:
% ranking: VIKOR ranking
% Q: VIKOR compromise index for each alternative (lower is better).
% S: Group utility measure: sum of weighted normalized distances to the ideal solution.
% R: Individual regret measure: maximum of the weighted normalized distances to the ideal solution.

function [ranking, Q, S, R] = fun_VIKOR(C, W, MM, v)
%% STEP 1: DEFINITION OF CRITERIA, WEIGHTS, AND MAXMIN VECTOR.
[m, n] = size(C);

%To ensure that the user has set as inputs as many weights as there are criteria in the study, and the MaxMin vector has the same size as the criteria.
if length(W) ~= n || length(MM) ~= n
    disp('The weights (W) and the MaxMin vector do not correspond to the number of criteria to be studied.')
else

end

% m: number of alternatives to evaluate; n: number of criteria;
% C(i,j): for the alternative i, value for criterion j

%% STEP 2:  f* AND f- BASED ON BENEFIT OR COST
f_star  = zeros(1,n);
f_min = zeros(1,n);

for j = 1:n
    if MM(j) == 1 
        f_star(j)  = max(C(:,j));
        f_min(j) = min(C(:,j));
    else    
        f_star(j)  = min(C(:,j));
        f_min(j) = max(C(:,j));
    end
end

%% STEP 3: S AND R CALCULATION
S = zeros(m,1);
R = zeros(m,1);

for i = 1:m
    S(i) = sum(W .*((f_star - C(i,:)) ./ (f_star - f_min)));               
    R(i) = max(W .*((f_star - C(i,:)) ./ (f_star - f_min)));              
end

%% STEP 4: Calculation of the commitment index  CALCULATION OF THE COMMITMENT INDEX (Q) OF EACH ALTERNATIVE AND VIKOR RANKING

S_min = min(S); S_max = max(S);
R_min = min(R); R_max = max(R);

S_term = (S - S_min) / (S_max - S_min);
R_term = (R - R_min) / (R_max - R_min);

Q = v * S_term + (1 - v) * R_term;

[~, ranking] = sort(Q, 'ascend'); % Ordering Q results for TOPSIS rank
end
