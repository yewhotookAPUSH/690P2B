clear all
[hay_stats,not_hay_stats] = detect2('IMG_0038.png');
close all
%% Part 2
haymat = [];
not_haymat = [];
for i=1:1:length(hay_stats)
    imstat = hay_stats(i);
    haymat(i,:) =  [imstat.Phi1, imstat.Phi2, imstat.Phi3, imstat.Phi4, imstat.mean, imstat.std;];
end
for i=1:1:length(not_hay_stats)
    imstat = not_hay_stats(i);
    not_haymat(i,:) =  [imstat.Phi1, imstat.Phi2, imstat.Phi3, imstat.Phi4, imstat.mean, imstat.std;];
end
Crossplot(haymat,not_haymat);
hay_cov = cov(haymat);
not_hay_cov = cov(not_haymat);
hay_mean = mean(haymat);
not_hay_mean = mean(not_haymat);
%% Mahalanobis Part
d0_0 = MahalanobisDist(haymat',hay_cov,hay_mean');
d0_1 = MahalanobisDist(haymat',not_hay_cov,not_hay_mean');
d1_1 = MahalanobisDist(not_haymat',not_hay_cov,not_hay_mean');
d1_0 = MahalanobisDist(not_haymat',hay_cov, hay_mean');
figure(2)
set(2, 'units', 'normalized','outerposition', [0 0 1 1] );
plot( d0_0, d0_1, 'b*', d1_0, d1_1, 'rd' );
hold on
plot( [0 10], [0 10], 'g' );
grid on
title( 'Mahalanobis Distance To Two Distributions');
set(findall(2,'type','text'),'fontSize',14);
legend( 'Points from Hay Bales', 'Points from Not Hay Bales' );
xlabel( 'Distance from Distribution 1' );
ylabel( 'Distance from Distribution 2' );
axis('equal')
ylim([0 10]);
xlim([0 10]);
