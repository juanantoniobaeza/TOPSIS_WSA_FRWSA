% Universitat Autònoma de Barcelona (UAB), GENOCOV
% Alex Gaona Soler, Albert Guisasola Canudas, Juan Antonio Baeza Labat.
% Comments or updates: JuanAntonio.Baeza@uab.cat
% Last Update (30/07/2025)
% % Inputs:
% C: Decision matrix, each row an alternative, each column a criterion
% W: Weights to be used by TOPSIS
% MM: MaxMin vector defining a criterion minimisation (-1) or maximisation (+1)

function WSA_TOPSIS(C,W,MM)

Tol = 1e-5;
MaxIt = 100;

[resUP]=half_TOPSIS(C,W,MM,1,Tol,MaxIt,0);
[resDOWN]=half_TOPSIS(C,W,MM,0,Tol,MaxIt,0);

% RESULTS
disp("Sensitivity Analysis of Weights (W)");
disp(['Max:    ' num2str(resUP, '%.3f ')]);
disp(['Default:' num2str(W, '%.3f ')]);
disp(['Min:    ' num2str(resDOWN, '%.3f ')]);
figure(4);
[~, N_Crit] = size(C);
x=1:N_Crit;
plot(x,W, 'x',x, resUP, 'vr', x, resDOWN, '^b');
hold on
for j=1:N_Crit
    plot([j, j], [resUP(j) resDOWN(j)],'-k')
end
axis([0 N_Crit+1 0 1]);
legend('Default weight', 'Max weight', 'Min weight','Possible values', 'Location','Northwest')
xlabel('Criterion')
ylabel('Weight')
title('Weight sensitivity analysis of the best alternative')


    function res = half_TOPSIS(C, W, I, lim, eps, it, stats)
        if nargin == 7
            if    (stats ~= 1)
                stats = 0;
            end
        else
            stats = 0;
        end
        res = zeros(size(W));

        [rankingINI,~,~,~] = fun_TOPSIS(C,W,I);  % call to the TOPSIS function, to see the initial ranking.
        for i = 1:length(W)
            iter = 0;

            % Determine interval limits
            a = min(W(i),lim);
            b = max(W(i),lim);
            L = b - a;

            Wm = W;

            if (stats)  %shows each itneration if stats is defined 1
                fprintf('Iter   a      b    Top\n');
                fprintf('%d\t%4.3f\t%4.3f\t%d\n', 0, a, b, rankingINI(1));
            end

            while (L > eps && iter < it)
                xm = (a + b) / 2;  % calculation of midpoint
                Wm(i) = xm; % rescale the other weigths to add a total of 1
                Rem = 1 - xm;
                Rest = sum(Wm) - xm;
                Wm = Wm * Rem / Rest;
                Wm(i) = xm;

                [rankingm,~,~,~] = fun_TOPSIS(C,Wm,I);
                if rankingINI(1) == rankingm(1)
                    if lim==1 %Case increase
                        a = xm;
                    else %Case decrease
                        b = xm;
                    end
                else
                    if lim==1 %Case increase
                        b = xm;
                    else %Case decrease
                        a = xm;
                    end
                end

                L = b - a;
                iter = iter + 1;
                if (stats)
                    fprintf('%d\t%4.3f\t%4.3f\t%d\n', iter, a, b, rankingm(1));
                end
            end
            if (stats)
                fprintf('\n');
            end
            res(i) = xm;
        end

    end

end

