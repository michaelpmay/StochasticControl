%run('make/makeDataFullModelFrequencyAnalysis.m')
addpath(genpath('utility'))
load data/mat/FullModelFrequencyAnalysis.mat
fig=figure
fig.Position(3:4)=[1200 800]
subplot(3,3,3)
hold on
plot(linspace(0,2,81),data{1+4}.state(1,(end-80):end),'Linewidth',2)
plot(linspace(0,2,81),data{1+8}.state(5,(end-80):end),'Linewidth',2)
xlabel('Radians')
ylabel('Species Count')
legend('Full Model','Calibrated Model')
label=LabelPlot('A')
label.FontSize=16

subplot(3,3,6)
hold on
plot(linspace(0,2,81),data{2+4}.state(1,(end-80):end),'Linewidth',2)
plot(linspace(0,2,81),data{2+8}.state(5,(end-80):end),'Linewidth',2)
xlabel('Radians')
ylabel('Species Count')
legend('Full Model','Calibrated Model')
label=LabelPlot('B')
label.FontSize=16

subplot(3,3,9)
hold on
plot(linspace(0,2,81),data{3+4}.state(1,(end-80):end),'Linewidth',2)
plot(linspace(0,2,81),data{3+8}.state(5,(end-80):end),'Linewidth',2)
xlabel('Radians')
ylabel('Species Count')
legend('Full Model','Calibrated Model')
label=LabelPlot('C')
label.FontSize=16
