% Universitat Autònoma de Barcelona (UAB), GENOCOV
% Alex Gaona Soler, Albert Guisasola Canudas, Juan Antonio Baeza Labat.
% Comments or updates: JuanAntonio.Baeza@uab.cat
% Last Update (08/09/2025)
% dirichlet_MC(Matrix_C, MM,Npoints, alpha, Nsim, Alt_Names, W_Names)
% % Inputs:
% Matrix_C: Matrix with each row the criteria values for an alternative
% MM: MaxMin vector with 1 if the criterion is maximized and -1 minimized
% Npoints: Number of points in the 0-1 interval of weights
% alpha: dirichlet parrameter for gamrnd() function
% Nsim: Number of Monte Carlo simulations (number of weight vectors to generate). Each row of WMAT is one vector of wi.
% Alt_Names: Labels for the alternatives
% Crit_Names: Cell array of strings or string array of size nW with the names of the criteria for tables and figure axes.

% The Dirichlet distribution is used because it generates vectors of probabilities 
% that sum to 1 (i.e., distributions on a simplex). This is useful in Monte Carlo 
% when random samples of probability distributions are needed.

% The alpha parameter controls the "distribution":
%   - alpha > 1: samples tend to be more uniform.
%   - alpha = 1: uniform distribution over the simplex (sum wi = 1).
%   - alpha < 1: samples are more sparse, favoring extreme values.

% The choice of alpha directly affects the variability of the 
% probabilities generated and must be established according to the behavior
% to be simulated!

% IMPORTANT: The Statistics and Machine Learning Toolbox are needed because of the function gamrnd().

function dirichlet_MC(Matrix_C, MM,Npoints, alpha, Nsim, Alt_Names, Crit_Names)
%% Number of alternatives and criteria
[N_Alt, N_Crit] = size(Matrix_C);
alpha_W = ones(1,N_Crit)*alpha;

%% Selecting the Weight Matrix depending on the number of criteria
G = zeros(Nsim, N_Crit);
for j = 1:N_Crit
    G(:, j) = gamrnd(alpha_W(j), 1, [Nsim, 1]);
end
S = sum(G, 2);
WMAT = G ./ S;

%% Maximum and minimum values assigned to each weight using the Monte Carlo (dirichlet) method
MinW = min(WMAT,[],1);
MaxW = max(WMAT,[],1);
T = table(Crit_Names(:), MinW(:), MaxW(:), 'VariableNames', {'Criterion','Min','Max'});
disp(T);

%% TOPSIS Fun
RankMAT = zeros(N_Alt, Nsim);
for s = 1:Nsim
    W = WMAT(s, :);
    [ranking, ~, ~, ~] = fun_TOPSIS(Matrix_C, W, MM);  % TOPSIS Function Call.
    RankMAT(:, s) = ranking;                           % According to equation (12). Matrix of all rankings calculated with TOPSIS function. row(1) = TOP 1; row(n) TOP N. Each column of this matrix is a different ranking performed with a combination of weights corresponding to each row of the WMAT matrix.
end
%% PLOTS
%% %% MONTE CARLO WEIGHT DISTRIBUTION PLOT
figure(4);
hold on;

for k = 1:N_Crit
    xvals = k + 0.3 * (rand(Nsim, 1) - 0.5); % Jitter for x-axis
    scatter(xvals, WMAT(:, k), 5, 'b', 'filled', 'MarkerFaceAlpha', 0.2);
end

hold off;
xlim([0.5, N_Crit + 0.5]);
ylim([0, 1]);
set(gca, 'XTick', 1:N_Crit, 'XTickLabel', Crit_Names);
xtickangle(30);
ylabel('W Value');
title(sprintf('Monte Carlo (Dirichlet alpha = %s)', num2str(alpha,'%.3g'))); 
legend ('Weight values assigned by MC Method')
grid on;

%% PIE PLOT:
figure(5)
pie3(histcounts(RankMAT(1,:), [1:N_Alt, inf]));
title('MC Best Alternative');
legend(Alt_Names);

%% HEATMAP
% Initialize frequency matrix
frec = zeros(N_Alt,N_Alt);

% Frequency of each number in each ranking
for j = 1:length(RankMAT(:, 1))
    row = RankMAT(j, :);
    frec(:, j) = histcounts(row, 1:N_Alt+1)./Nsim.*100;
end

Rank = compose("Rank_%d", 1:N_Alt); % Labels for the x axis (Rank_x)

% Heatmap PLOT
figure(6)
h = heatmap(Rank, Alt_Names, frec,'Colormap',flipud(summer));
xlabel('Ranking');
ylabel('Alternative');
title('MC overall ranking of alternatives')
percentage_format = '%.2f%%';
h.CellLabelFormat = percentage_format;

%% FRWSA PLOT
Incr = 1/(Npoints-1); % Increment of- weight
AllWValues = 0:Incr:Incr*(Npoints-1); 
edges      = [AllWValues - Incr/2, 1 + Incr/2]; 


repW_MC = zeros(length(AllWValues), N_Crit);
for j = 1:N_Crit
    repW_MC(:, j) = histcounts(WMAT(:, j), edges).';
end

Rank1row = RankMAT(1, :);              % Top 1 Alternative in each TOPSIS simulation. Each column of the Rank1row corresponds to the simulation performed for the combination of weights for each WMatrix row. Rank1row(:,i) -> WMatrix(i,:)

for k = 1:N_Alt
    columnRank1 = Rank1row == k;        % Col looks at the Rank1row vector to see when an alternative has been placed in the TOP 1 and in which position of the vector it has been placed in the TOP 1. This way we can know with which combination of weights this alternative has been placed TOP 1.
    WRank1Altk  = WMAT(columnRank1, :); % pesos de esas simulaciones

   
    WRank1AltkD = round(WRank1Altk ./ Incr) * Incr;
    WRank1AltkD = min(max(WRank1AltkD, 0), 1); 

    frc = zeros(Npoints, N_Crit);  % Inizialisation of the 'f' matrix. This matrix will contain the frequency of each of the values that can have a weight that has been TOP 1 in that alternative.
    figsize=get(0, 'ScreenSize');
    figure(k+10);
    set(k+10,'Position',[figsize(1)+5 figsize(2)+50 figsize(3)-10 figsize(4)-135]);

    for j = 1:N_Crit
        for i = 1:length(AllWValues)
            Count = sum(abs(WRank1AltkD(:, j) - AllWValues(i)) <= 1e-10);  % Calculates the absolute difference between each element of WRank1Altx and AllWValues, to see how many times a value appears in each criterion studied (resulting in that alternative TOP 1).
            denom = max(repW_MC(i, j), 1);  
            frc(i, j) = Count ./ denom;                                    % According to equation (14). frc (j,i,k), where i = N. of criteria; j = Different W values (from 0-1); k = Alternative.
        end

        % FRWSA Subplots
        subplot(ceil(N_Crit/2), 2, j);
        bar(AllWValues, frc(:, j));
        xlabel('Weight values');
        ylabel('\it frc');
        ylim([0 (Incr*(Npoints-1))])
        xlim([AllWValues(1)-Incr/2, AllWValues(end)+Incr/2]);
        xticks(AllWValues)
        title(Crit_Names(j))
    end

    sgtitle(Alt_Names(k))
end
end