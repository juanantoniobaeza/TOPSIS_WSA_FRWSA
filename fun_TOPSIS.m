% Universitat Autònoma de Barcelona (UAB), GENOCOV.
% Alex Gaona Soler, Albert Guisasola Canudas, Juan Antonio Baeza Labat.
% Comments or updates: JuanAntonio.Baeza@uab.cat
% Last Update (30/07/2025)
% % Inputs:
% C: Decision matrix, each row an alternative, each column a criterion
% W: Weights to be used by TOPSIS
% MM: MaxMin vector defining a criterion minimisation (-1) or maximisation (+1)
% % Output:
% ranking: TOPSIS ranking
% CC: closeness coefficient
% D_positive: distance to the positive ideal solution
% D_negative: distance to the negative ideal solution

function [ranking,CC,D_positive,D_negative] = fun_TOPSIS(C,W,MM)
%% STEP 1: DEFINITION OF CRITERIA, WEIGHTS, AND MAXMIN VECTOR.
[m, n] = size(C);

%To ensure that the user has set as inputs as many weights as there are criteria in the study, and the MaxMin vector has the same size as the criteria.
if length(W) ~= n || length(MM) ~= n
    disp('The weights (W) and the MaxMin vector do not correspond to the number of criteria to be studied.')
else
    
end

% m: number of alternatives to evaluate; n: number of criteria;
% C(i,j): for the alternative i, value for criterion j

%% STEP 2: NORMALIZATION OF THE DECISION MATRIX (C)
R = zeros(m, n); %#ok<PREALL>
R = C ./ vecnorm(C); %Calculates R matrix of equations (2)-(3)

% We change sign if the criterion is of the type minimization
R(:, MM ~= 1) = -R(:, MM ~= 1);

% Other alternative code for step 2
% for i = 1:n
%     R(:, i) = C(:, i) / norm(C(:, i));
%     if I(i) ~= 1
%         R(:,i)=-R(:,i);
%     end
% end

%% STEP 3: Matrix weighting
% The weighted normalized matrix (F) is a matrix representing the weighted normalized criterion values of each alternative
F = R .* W;  %Calculates F matrix according to equations (4) and (5)

%% STEP 4: DETERMINATION OF G= + IDEAL SOLUTION & B= - IDEAL SOLUTION
PIS = max(F); % According to equations (6) and (7)
NIS = min(F); % According to equations (6) and (8)

%Alternative code
% for j = 1:n
%         PIS(j) = max(F(:, j));
%         NIS(j) = min(F(:, j));
% end

%% STEP 5: CALCULATION OF THE DISTANCES TO THE + & - IDEAL SOLUTIONS
D_positive = sqrt(sum((F - PIS).^2, 2)); % According to equation (9+)
D_negative = sqrt(sum((F - NIS).^2, 2)); % According to equation (9-)

%% STEP 6: CALCULATION OF THE CLOSENESS COEFICIENT (CC) OF EACH ALTERNATIVE AND TOPSIS RANKING
CC = D_negative ./ (D_positive + D_negative); % According to equation (10)
[~, ranking] = sort(CC, 'descend'); % Ordering CC results for TOPSIS rank

end