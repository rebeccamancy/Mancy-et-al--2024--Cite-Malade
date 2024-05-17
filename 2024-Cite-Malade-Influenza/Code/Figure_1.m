
clear
clc
close all
Load_Data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Figure 1  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
% plot(Glasgow_Data.Year(1:end),Glasgow_Data.Influenza(1:end),'.-', 'Linewidth', 0.5, 'Color','red', 'Markersize',6  ,'MarkerEdgeColor','red')
% hold on
% plot(EnglandWales_Data.Year(1:end),EnglandWales_Data.InfluenzaMortalityRate(1:end),'.-', 'Linewidth', 0.5, 'Color','black', 'Markersize',6  ,'MarkerEdgeColor','black')
% 
% patch([1921.5,1921.5, 1922.5,1922.5],[0 max(ylim) max(ylim) 0], [0.9 0.9 0.9],'EdgeColor','none')
% patch([1925.5,1925.5, 1926.5,1926.5],[0 max(ylim) max(ylim) 0], [0.9 0.9 0.9],'EdgeColor','none')
% patch([1928.5,1928.5, 1929.5,1929.5],[0 max(ylim) max(ylim) 0], [0.9 0.9 0.9],'EdgeColor','none')
% patch([1931.5,1931.5, 1932.5,1932.5],[0 max(ylim) max(ylim) 0], [0.9 0.9 0.9],'EdgeColor','none')
% patch([1936.5,1936.5, 1937.5,1937.5],[0 max(ylim) max(ylim) 0], [0.9 0.9 0.9],'EdgeColor','none')

aa = plot(Glasgow_Data.Year(1:end),Glasgow_Data.Influenza(1:end),'o:', 'Linewidth', 0.5, 'Color','black', 'Markersize', 3,'MarkerEdgeColor','black')
hold on
bb = plot(EnglandWales_Data.Year(1:end),EnglandWales_Data.InfluenzaMortalityRate(1:end),'.-', 'Linewidth', 0.5, 'Color','black', 'Markersize', 6,'MarkerEdgeColor','black')
% set(gca, 'Layer', 'top')
ylabel('Mortality rate (deaths/million)')
box off
grid on
xlim([1895,1975])

legend([aa,bb],{'Glasgow', 'England & Wales'})
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',8)
aa = get(gca,'YTickLabel');
set(gca,'YTickLabel',aa,'fontsize',8)

h = figure(1);

%set (h, 'Units','centimeters', 'Positioff', [0 0 14.5 14.5]);
h.Units='centimeters';
h.OuterPosition=[0 0 19 10];
exportgraphics(h,'../Figures/Figure_1.pdf','BackgroundColor','none','Resolution', 900)
exportgraphics(h,'../Figures/Figure_1.emf','BackgroundColor','none','Resolution', 900)
exportgraphics(h,'../Figures/Figure_1.eps','BackgroundColor','none','Resolution', 900)
exportgraphics(h,'../Figures/Figure_1.jpg','BackgroundColor','none','Resolution', 900)
exportgraphics(h,'../Figures/Figure_1.png','BackgroundColor','none','Resolution', 900)

