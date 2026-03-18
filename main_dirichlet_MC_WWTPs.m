% Universitat Autònoma de Barcelona (UAB), GENOCOV
% Alex Gaona Soler, Albert Guisasola Canudas, Juan Antonio Baeza Labat.
% Comments or updates: JuanAntonio.Baeza@uab.cat
% Last Update (08/09/2025)


clear
close all
tic
%% MAIN TOPSIS MC (dirichlet)
%% CONSTRUCTION OF THE INITIAL DECISION MATRIX (C)
% DECISION MATRIX (C) 

C = [152.0	2.7	 86.2	76.7	77.1	63.4	33.1	7.7	 1.8	9.9
     164.6	2.7	 86.1	77.0	82.3	63.8	32.9	4.2	 1.6	9.9
     194.6	12.7 85.9	50.5	70.5	86.0	49.0	6.4	 1.4	18.1
     269.4	3.2	 85.8	72.0	86.5	87.3	35.6	4.2	 1.3	10.9];


%% Weight vector (W) - Relative importance of each criterion
[N_Alt,N_Crit] = size(C);
W = ones(1,N_Crit)/N_Crit; %Same weight for all the criteria

%% MaxMin vector (MM) - Direction of impact for each criterion (1 to maximize, -1 to minimize)
% In other words, here it is important if it is more favorable that the studied value is larger (1) or smaller (-1).
MM = [-1	-1	1	1	1	-1	-1	-1	-1	-1];


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

%% MC (dirichlet)
Alt_Names = {'A2/O-S','A2/O-D','BARDENPHO','UCT'};
Crit_Names = {'CAPEX','OPEX','COD_{REM}','N_{REM}','P_{REM}','COD_{AVG}','N_{T-AVG}','P_{T-AVG}','P_{ROB}','N_{ROB}'};

Nsim = 1e5; % Number of MC (dirichlet) simulations
Npoints=21; % Number of points in the 0-1 interval of weights  %Choose 21 for obtaining the paper results

alpha = 0.1;

dirichlet_MC(C, MM,Npoints, alpha, Nsim, Alt_Names, Crit_Names)
toc