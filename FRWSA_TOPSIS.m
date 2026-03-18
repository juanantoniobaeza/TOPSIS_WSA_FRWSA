% Universitat Autònoma de Barcelona (UAB), GENOCOV.
% Alex Gaona Soler, Albert Guisasola Canudas, Juan Antonio Baeza Labat.
% Comments or updates: JuanAntonio.Baeza@uab.cat
% Last Update (30/07/2025)
% FRWSA_TOPSIS(Matrix_C,MM,Npoints,Alt_Names,W_Names)
% Matrix_C Matrix with each row the criteria values for an alternative
% MM MaxMin vector with 1 if the criterion is maximized and -1 minimized
% Npoints Number of points in the 0-1 interval of weights
% Alt_Names Labels for the alternatives
% W_Names Labels for the criteria

function FRWSA_TOPSIS(Matrix_C,MM,Npoints,Alt_Names,W_Names)
%% Number of alternatives and criteria
[N_Alt, N_Crit] = size(Matrix_C);

%% Possible weights
% Call the function to get the whole combination of weights
Incr = 1/(Npoints-1); % Increment of- weight

%% Selecting the Weight Matrix depending on the number of criteria
functionName = ['Wmatrix_', num2str(N_Crit)];
[Weights_Matrix, repW, numCombinations] = feval(functionName, 1, Npoints); % Function Call.
WMAT = Weights_Matrix(:,1:N_Crit);                                         % According to equation (11). Matrix with all possible combinations of weights. Rows = N. of posible combinations; Columns = N. Criteria
disp(['FRWSA evaluating: ' num2str(numCombinations, '%i ') ' weight combinations']);
%% TOPSIS Fun
[n,~]=size(WMAT);
RankMAT=zeros(N_Alt,n);
for j = 1:length(WMAT(:,1))
    W = WMAT(j,:);
    [ranking,~,~,~] = fun_TOPSIS(Matrix_C,W,MM);   % TOPSIS Function Call.
    RankMAT(:,j) = ranking;                        % According to equation (12). Matrix of all rankings calculated with TOPSIS function. row(1) = TOP 1; row(n) TOP N. Each column of this matrix is a different ranking performed with a combination of weights corresponding to each row of the WMAT matrix.
end

%% PLOTS
%% PIE PLOT:
figure(5)
pie3(histcounts(RankMAT(1,:), [1:N_Alt, inf]));
title('TOPSIS FRWSA Best Alternative');
legend(Alt_Names);

%% HEATMAP
% Initialize frequency matrix
frec = zeros(N_Alt,N_Alt);

% Frequency of each number in each ranking
for j = 1:length(RankMAT(:, 1))
    row = RankMAT(j, :);
    frec(:, j) = histcounts(row, 1:N_Alt+1)./numCombinations.*100;
end

Rank = compose("Rank_%d", 1:N_Alt); % Labels for the x axis (Rank_x)

% Heatmap PLOT
figure(6)
h = heatmap(Rank, Alt_Names, frec,'Colormap',flipud(summer));
xlabel('Ranking');
ylabel('Alternative');
title('TOPSIS FRWSA overall ranking of alternatives')
percentage_format = '%.2f%%';
h.CellLabelFormat = percentage_format;

%% FRWSA PLOT
Rank1row = RankMAT(1, :);             % Top 1 Alternative in each TOPSIS simulation. Each column of the Rank1row corresponds to the simulation performed for the combination of weights for each WMatrix row. Rank1row(:,i) -> WMatrix(i,:)
AllWValues = 0:Incr:Incr*(Npoints-1); % All possible values that a weight can have.

for k = 1:N_Alt
    columnRank1 = Rank1row == k;        % Col looks at the Rank1row vector to see when an alternative has been placed in the TOP 1 and in which position of the vector it has been placed in the TOP 1. This way we can know with which combination of weights this alternative has been placed TOP 1.
    WRank1Altk = WMAT(columnRank1, :);  % According to equation (13). WRank1Altx contains all the combinations of weights with which it has been TOP 1. This matrix will have as many rows as the number of times that alternative has been TOP 1.

    frc = zeros(Npoints, N_Crit); % Inizialisation of the 'f' matrix. This matrix will contain the frequency of each of the values that can have a weight that has been TOP 1 in that alternative.
    figsize=get(0, 'ScreenSize');
    figure(k+10);
    set(k+10,'Position',[figsize(1)+5 figsize(2)+50 figsize(3)-10 figsize(4)-135]);

    for j = 1:N_Crit
        for i = 1:length(AllWValues)
            Count = sum(abs(WRank1Altk(:, j) - AllWValues(i)) <= 0.0001);    % Calculates the absolute difference between each element of WRank1Altx and AllWValues, to see how many times a value appears in each criterion studied (resulting in that alternative TOP 1).
            frc(i, j) = Count ./ repW(i);                                    % According to equation (14). frc (j,i,k), where i = N. of criteria; j = Different W values (from 0-1); k = Alternative.
        end

        % FRWSA Subplots
        subplot(ceil(N_Crit/2), 2, j);
        bar(AllWValues, frc(:, j));
        xlabel('Weight values');
        ylabel('\it frc');
        ylim([0 (Incr*(Npoints-1))])
        xticks(AllWValues)

        title(W_Names(j))
    end

    sgtitle(Alt_Names(k))
end

end
%% Combinations for 2 criteria

function [Wmatrix,rep,numCombinations] = Wmatrix_2(maxW, nW)

% ALL POSSIBLE COMBINATIONS
num = 2;
numCombinations = nchoosek(nW+num-2,nW-1);
Wmatrix = zeros(numCombinations, 3);
Weights = 0:maxW/(nW-1):maxW;
idx = 1;

% CONSTRUCTION OF THE n-DIMENSIONAL MATRIX
for W1 = 1:nW
    W2 = maxW - Weights(W1);
    Wmatrix(idx, 1:2) = [Weights(W1) W2];
    Wmatrix(idx,3)=sum(Wmatrix(idx,:));
    idx = idx + 1;
end

% CALCULATION OF HOW MANY TIMES A SPECIFIC WEIGHT APPEARS IN THE MATRIX
rep=zeros(nW,1);
for i=1:nW
    rep(i)=nchoosek(nW+num-2-i,num-2);
end
end

%% Combinations for 3 criteria

function [Wmatrix,rep,numCombinations] = Wmatrix_3(maxW, nW)

% ALL POSSIBLE COMBINATIONS
num = 3;
numCombinations = nchoosek(nW+num-2,nW-1);
Wmatrix = zeros(numCombinations, 4);
Weights = 0:maxW/(nW-1):maxW;
idx = 1;

% CONSTRUCTION OF THE n-DIMENSIONAL MATRIX
for W1 = 1:nW
    for W2 = 1:nW-W1+1
        W3 = maxW - Weights(W1) - Weights(W2);
        Wmatrix(idx, 1:3) = [Weights(W1) Weights(W2) W3];
        Wmatrix(idx,4)=sum(Wmatrix(idx,:));
        idx = idx + 1;
    end
end

% CALCULATION OF HOW MANY TIMES A SPECIFIC WEIGHT APPEARS IN THE MATRIX
rep=zeros(nW,1);
for i=1:nW
    rep(i)=nchoosek(nW+num-2-i,num-2);
end
end

%% Combinations for 4 criteria
function [Wmatrix,rep,numCombinations] = Wmatrix_4(maxW, nW)

% ALL POSSIBLE COMBINATIONS
num = 4;
numCombinations = nchoosek(nW+num-2,nW-1);
Wmatrix = zeros(numCombinations, 5);
Weights = 0:maxW/(nW-1):maxW;
idx = 1;

% CONSTRUCTION OF THE n-DIMENSIONAL MATRIX
for W1 = 1:nW
    for W2 = 1:nW-W1+1
        for W3 = 1:nW-W1-W2+2
            W4 = maxW - Weights(W1) - Weights(W2) - Weights(W3);
            Wmatrix(idx, 1:4) = [Weights(W1) Weights(W2) Weights(W3) W4];
            Wmatrix(idx,5)=sum(Wmatrix(idx,:));
            idx = idx + 1;
        end
    end
end

% CALCULATION OF HOW MANY TIMES A SPECIFIC WEIGHT APPEARS IN THE MATRIX
rep=zeros(nW,1);
for i=1:nW
    rep(i)=nchoosek(nW+num-2-i,num-2);
end
end

%% Combinations for 5 criteria
function [Wmatrix,rep,numCombinations] = Wmatrix_5(maxW, nW)

% ALL POSSIBLE COMBINATIONS
num = 5;
numCombinations = nchoosek(nW+num-2,nW-1);
Wmatrix = zeros(numCombinations, 6);
Weights = 0:maxW/(nW-1):maxW;
idx = 1;

% CONSTRUCTION OF THE n-DIMENSIONAL MATRIX
for W1 = 1:nW
    for W2 = 1:nW-W1+1
        for W3 = 1:nW-W1-W2+2
            for W4 = 1:nW-W1-W2-W3+3
                W5 = maxW - Weights(W1) - Weights(W2) - Weights(W3) - Weights(W4);
                Wmatrix(idx, 1:5) = [Weights(W1) Weights(W2) Weights(W3) Weights(W4) W5];
                Wmatrix(idx,6)=sum(Wmatrix(idx,:));
                idx = idx + 1;
            end
        end
    end
end

% CALCULATION OF HOW MANY TIMES A SPECIFIC WEIGHT APPEARS IN THE MATRIX
rep=zeros(nW,1);
for i=1:nW
    rep(i)=nchoosek(nW+num-2-i,num-2);
end
end

%% Combinations for 6 criteria
function [Wmatrix,rep,numCombinations] = Wmatrix_6(maxW, nW)

% ALL POSSIBLE COMBINATIONS
num = 6;
numCombinations = nchoosek(nW+num-2,nW-1);
Wmatrix = zeros(numCombinations, 7);
Weights = 0:maxW/(nW-1):maxW;
idx = 1;

% CONSTRUCTION OF THE n-DIMENSIONAL MATRIX
for W1 = 1:nW
    for W2 = 1:nW-W1+1
        for W3 = 1:nW-W1-W2+2
            for W4 = 1:nW-W1-W2-W3+3
                for W5 = 1:nW-W1-W2-W3-W4+4
                    W6 = maxW - Weights(W1) - Weights(W2) - Weights(W3) - Weights(W4) - Weights(W5);
                    Wmatrix(idx, 1:6) = [Weights(W1) Weights(W2) Weights(W3) Weights(W4) Weights(W5) W6];
                    Wmatrix(idx,7)=sum(Wmatrix(idx,:));
                    idx = idx + 1;
                end
            end
        end
    end
end

% CALCULATION OF HOW MANY TIMES A SPECIFIC WEIGHT APPEARS IN THE MATRIX
rep=zeros(nW,1);
for i=1:nW
    rep(i)=nchoosek(nW+num-2-i,num-2);
end
end

%% Combinations for 7 criteria
function [Wmatrix,rep,numCombinations] = Wmatrix_7(maxW, nW)

% ALL POSSIBLE COMBINATIONS
num = 7;
numCombinations = nchoosek(nW+num-2,nW-1);
Wmatrix = zeros(numCombinations, 8);
Weights = 0:maxW/(nW-1):maxW;
idx = 1;

% CONSTRUCTION OF THE n-DIMENSIONAL MATRIX
for W1 = 1:nW
    for W2 = 1:nW-W1+1
        for W3 = 1:nW-W1-W2+2
            for W4 = 1:nW-W1-W2-W3+3
                for W5 = 1:nW-W1-W2-W3-W4+4
                    for W6 = 1:nW-W1-W2-W3-W4-W5+5
                        W7 = maxW - Weights(W1) - Weights(W2) - Weights(W3) - Weights(W4) - Weights(W5) - Weights(W6);
                        Wmatrix(idx, 1:7) = [Weights(W1) Weights(W2) Weights(W3) Weights(W4) Weights(W5) Weights(W6) W7];
                        Wmatrix(idx,8)=sum(Wmatrix(idx,:));
                        idx = idx + 1;
                    end
                end
            end
        end
    end
end

% CALCULATION OF HOW MANY TIMES A SPECIFIC WEIGHT APPEARS IN THE MATRIX
rep=zeros(nW,1);
for i=1:nW
    rep(i)=nchoosek(nW+num-2-i,num-2);
end
end

%% Combinations for 8 criteria
function [Wmatrix,rep,numCombinations] = Wmatrix_8(maxW, nW)

% ALL POSSIBLE COMBINATIONS
num = 8;
numCombinations = nchoosek(nW+num-2,nW-1);
Wmatrix = zeros(numCombinations, 9);
Weights = 0:maxW/(nW-1):maxW;
idx = 1;

% CONSTRUCTION OF THE n-DIMENSIONAL MATRIX
for W1 = 1:nW
    for W2 = 1:nW-W1+1
        for W3 = 1:nW-W1-W2+2
            for W4 = 1:nW-W1-W2-W3+3
                for W5 = 1:nW-W1-W2-W3-W4+4
                    for W6 = 1:nW-W1-W2-W3-W4-W5+5
                        for W7 = 1:nW-W1-W2-W3-W4-W5-W6+6
                            W8 = maxW - Weights(W1) - Weights(W2) - Weights(W3) - Weights(W4) - Weights(W5) - Weights(W6) - Weights(W7);
                            Wmatrix(idx, 1:8) = [Weights(W1) Weights(W2) Weights(W3) Weights(W4) Weights(W5) Weights(W6) Weights(W7) W8];
                            Wmatrix(idx,9)=sum(Wmatrix(idx,:));
                            idx = idx + 1;
                        end
                    end
                end
            end
        end
    end
end

% CALCULATION OF HOW MANY TIMES A SPECIFIC WEIGHT APPEARS IN THE MATRIX
rep=zeros(nW,1);
for i=1:nW
    rep(i)=nchoosek(nW+num-2-i,num-2);
end
end

%% Combinations for 9 criteria
function [Wmatrix,rep,numCombinations] = Wmatrix_9(maxW, nW)

% ALL POSSIBLE COMBINATIONS
num = 9;
numCombinations = nchoosek(nW+num-2,nW-1);
Wmatrix = zeros(numCombinations, 10);
Weights = 0:maxW/(nW-1):maxW;
idx = 1;

% CONSTRUCTION OF THE n-DIMENSIONAL MATRIX
for W1 = 1:nW
    for W2 = 1:nW-W1+1
        for W3 = 1:nW-W1-W2+2
            for W4 = 1:nW-W1-W2-W3+3
                for W5 = 1:nW-W1-W2-W3-W4+4
                    for W6 = 1:nW-W1-W2-W3-W4-W5+5
                        for W7 = 1:nW-W1-W2-W3-W4-W5-W6+6
                            for W8 = 1:nW-W1-W2-W3-W4-W5-W6-W7+7
                                W9 = maxW - Weights(W1) - Weights(W2) - Weights(W3) - Weights(W4) - Weights(W5) - Weights(W6) - Weights(W7) - Weights(W8);
                                Wmatrix(idx, 1:9) = [Weights(W1) Weights(W2) Weights(W3) Weights(W4) Weights(W5) Weights(W6) Weights(W7) Weights(W8) W9];
                                Wmatrix(idx,10)=sum(Wmatrix(idx,:));
                                idx = idx + 1;
                            end
                        end
                    end
                end
            end
        end
    end
end

% CALCULATION OF HOW MANY TIMES A SPECIFIC WEIGHT APPEARS IN THE MATRIX
rep=zeros(nW,1);
for i=1:nW
    rep(i)=nchoosek(nW+num-2-i,num-2);
end

end

%% Combinations for 10 criteria
function [Wmatrix,rep,numCombinations] = Wmatrix_10(maxW, nW)

% ALL POSSIBLE COMBINATIONS
num=10;
numCombinations = nchoosek(nW+num-2,nW-1);
Wmatrix = zeros(numCombinations, 11);
Weights = 0:maxW/(nW-1):maxW;
idx = 1;

% CONSTRUCTION OF THE n-DIMENSIONAL MATRIX
for W1 = 1:nW
    for W2 = 1:nW-W1+1
        for W3 = 1:nW-W1-W2+2
            for W4 = 1:nW-W1-W2-W3+3
                for W5 = 1:nW-W1-W2-W3-W4+4
                    for W6 = 1:nW-W1-W2-W3-W4-W5+5
                        for W7 = 1:nW-W1-W2-W3-W4-W5-W6+6
                            for W8 = 1:nW-W1-W2-W3-W4-W5-W6-W7+7
                                for W9 = 1:nW-W1-W2-W3-W4-W5-W6-W7-W8+8
                                    W10 = maxW - Weights(W1) - Weights(W2) - Weights(W3) - Weights(W4) - Weights(W5) - Weights(W6) - Weights(W7) - Weights(W8) - Weights(W9);
                                    Wmatrix(idx, 1:10) = [Weights(W1) Weights(W2) Weights(W3) Weights(W4) Weights(W5) Weights(W6) Weights(W7) Weights(W8) Weights(W9) W10];
                                    Wmatrix(idx,11)=sum(Wmatrix(idx,:));
                                    idx = idx + 1;
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

% CALCULATION OF HOW MANY TIMES A SPECIFIC WEIGHT APPEARS IN THE MATRIX
rep=zeros(nW,1);
for i=1:nW
    rep(i)=nchoosek(nW+num-2-i,num-2);
end
end