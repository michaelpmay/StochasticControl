load data/controlers/ReducedControlerAutoregulatedModelControler.mat
figure
ax=subplot(1,1,1)
ax.Color=[1,1,1]
hold on
a1=area([0:49],fullModelCalibration(controlInput(1:50)))
a1.EdgeAlpha=0;
xlabel('Species Count')
ylabel('Control Input')
box