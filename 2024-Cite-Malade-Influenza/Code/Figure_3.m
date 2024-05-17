clear
clc
close all
Load_Data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Figure 3  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1)
set(figure(1),'defaultAxesColorOrder',[[0 0 0];[0 0 0]]);
yyaxis left

plot(MSM_Glasgow_Influenza.Year,exp(MSM_Glasgow_Influenza.log_influenza),'LineWidth',0.5)
ylabel('Mortality rate (deaths/million)')

hold on
yyaxis right
plot(MSM_Glasgow_Influenza.Year,1-MSM_Glasgow_Influenza.prob,'--','LineWidth',0.5)
% legend('Influenza mortality','Regime probability')

ylabel('Estimated high mortality regime probability')
box off
grid on
xlim([1895,1975])

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',6)
aa = get(gca,'YTickLabel');
set(gca,'YTickLabel',aa,'fontsize',6)


h = figure(1);

%set (h, 'Units','centimeters', 'Positioff', [0 0 14.5 14.5]);
h.Units='centimeters';
h.OuterPosition=[0 0 19 10];
exportgraphics(h,'../Figures/Figure_3.pdf','BackgroundColor','none','Resolution', 900)
exportgraphics(h,'../Figures/Figure_3.emf','BackgroundColor','none','Resolution', 900)
exportgraphics(h,'../Figures/Figure_3.eps','BackgroundColor','none','Resolution', 900)
exportgraphics(h,'../Figures/Figure_3.jpg','BackgroundColor','none','Resolution', 900)
exportgraphics(h,'../Figures/Figure_3.png','BackgroundColor','none','Resolution', 900)

