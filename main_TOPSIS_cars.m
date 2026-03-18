% Universitat Autònoma de Barcelona (UAB), GENOCOV.
% Alex Gaona Soler, Albert Guisasola Canudas, Juan Antonio Baeza Labat.
% Comments or updates: JuanAntonio.Baeza@uab.cat
% Last Update (30/08/2024)

clear
close all
tic
%% MAIN TOPSIS + WSA + FRWSA
%% CONSTRUCTION OF THE INITIAL DECISION MATRIX (C)
% DECISION MATRIX (C) 

% Comparison of five cars and seven criteria
 %Trunk(L) MaxSp(km/h) Power(hp) L/100km Cost  N.Seats  Combust.   
C = [500      180       306      1     51750    7         2;   % CAR 1
     510      180       110     4.8    24540    5         5;   % CAR 2
     470      160       220      0     43488    5         1;   % CAR 3
     395      196       120     5.5    29800    4         4;   % CAR 4
     377      170       122     5.3    29700    5         3];  % CAR 5

%% Weight vector (W) - Relative importance of each criterion
[N_Alt,N_Crit] = size(C);
W = ones(1,N_Crit)/N_Crit; %Same weight for all the criteria
% wi = 1 / 7; % 
% W = [wi wi wi wi wi wi wi]; Other way to define the W vector

%% MaxMin vector (MM) - Direction of impact for each criterion (1 to maximize, -1 to minimize)
% In other words, here it is important if it is more favorable that the studied value is larger (1) or smaller (-1).
MM = [1 1 1 -1 -1 1 -1];

%% TOPSIS calculation
[ranking,CC,D_positive,D_negative] = fun_TOPSIS(C,W,MM)
figure(1)
[N_Alt,~] = size(C);
bar(CC)
axis([0 N_Alt+1 0 1]);
xlabel('Alternative')
ylabel('Closeness coefficient')
title('TOPSIS ranking (higher better)')
figure(2)
bar(D_positive,'red')
xlabel('Alternative')
ylabel('Distance to best solution')
title('TOPSIS Alternative distance to PIS (lower better)')
figure(3)
bar(D_negative,'cyan')
xlabel('Alternative')
ylabel('Distance to worst solution')
title('TOPSIS Alternative distance to NIS (higher better)')

%% WSA
WSA_TOPSIS(C,W,MM)


%% FRWSA
Alt_Names = {'CAR 1','CAR 2 ','CAR 3','CAR 4','CAR 5'};
Crit_Names = {'Trunk','MaxSp','Power','L/100km', 'Cost','N.Seats','Combust.'};
Npoints=21; % Number of points in the 0-1 interval of weights 

FRWSA_TOPSIS(C,MM,Npoints,Alt_Names,Crit_Names)
toc



