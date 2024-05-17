clear
clc
close all
Load_Data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Figure 2  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2)
subplot(6,1,1)
plot(Glasgow_Data.Year(1:end),Glasgow_Data.Whooping_Cough(1:end),'.-', 'Linewidth', 0.5, 'Color','black', 'Markersize',6  ,'MarkerEdgeColor','black')
ylabel({'Whooping', 'Cough'})
box off
grid on
xlim([1895,1975])
yticks([0:500:1000])
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',6)
aa = get(gca,'YTickLabel');
set(gca,'YTickLabel',aa,'fontsize',6)

subplot(6,1,2)
plot(Glasgow_Data.Year(1:end),Glasgow_Data.Pulmonary_Tuberculosis(1:end),'.-', 'Linewidth', 0.5, 'Color','black', 'Markersize',6  ,'MarkerEdgeColor','black')
ylabel({'Pulmonary', 'Tuberculosis'})
box off
grid on
xlim([1895,1975])
yticks([0:1000:2000])
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',6)
aa = get(gca,'YTickLabel');
set(gca,'YTickLabel',aa,'fontsize',6)

subplot(6,1,3)
plot(Glasgow_Data.Year(1:end),Glasgow_Data.Bronchitis(1:end),'.-', 'Linewidth', 0.5, 'Color','black', 'Markersize',6  ,'MarkerEdgeColor','black')
ylabel('Bronchitis')
box off
grid on
xlim([1895,1975])
yticks([0:500:1500])
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',6)
aa = get(gca,'YTickLabel');
set(gca,'YTickLabel',aa,'fontsize',6)

subplot(6,1,4)
plot(Glasgow_Data.Year(1:end),Glasgow_Data.Pneumonia(1:end),'.-', 'Linewidth', 0.5, 'Color','black', 'Markersize',6  ,'MarkerEdgeColor','black')
ylabel('Pneumonia')
box off
grid on
xlim([1895,1975])
yticks([0:1000:2000])
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',6)
aa = get(gca,'YTickLabel');
set(gca,'YTickLabel',aa,'fontsize',6)

subplot(6,1,5)
plot(Glasgow_Data.Year(1:end),Glasgow_Data.Influenza(1:end),'.-', 'Linewidth', 0.5, 'Color','black', 'Markersize',6  ,'MarkerEdgeColor','black')
ylabel('Influenza')
box off
grid on
xlim([1895,1975])
yticks([0:1000:2000])
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',6)
aa = get(gca,'YTickLabel');
set(gca,'YTickLabel',aa,'fontsize',6)

subplot(6,1,6)
plot(Glasgow_Data.Year(1:end),Glasgow_Data.Selected_Resp(1:end),'.-', 'Linewidth', 0.5, 'Color','black', 'Markersize',6  ,'MarkerEdgeColor','black')
ylabel({'Selected respiratory', 'diseases'})
box off
grid on
xlim([1895,1975])
yticks([0:2500:6000])
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',6)
aa = get(gca,'YTickLabel');
set(gca,'YTickLabel',aa,'fontsize',6)


h = figure(2);

%set (h, 'Units','centimeters', 'Positioff', [0 0 14.5 14.5]);
h.Units='centimeters';
h.OuterPosition=[0 0 19 20];
exportgraphics(h,'../Figures/Figure_2.pdf','BackgroundColor','none','Resolution', 900)
exportgraphics(h,'../Figures/Figure_2.emf','BackgroundColor','none','Resolution', 900)
exportgraphics(h,'../Figures/Figure_2.eps','BackgroundColor','none','Resolution', 900)
exportgraphics(h,'../Figures/Figure_2.jpg','BackgroundColor','none','Resolution', 900)
exportgraphics(h,'../Figures/Figure_2.png','BackgroundColor','none','Resolution', 900)