addpath(genpath('utility'))
close all
figlayer=FigureLayer;
figlayer.axes.datalayer.forceAnalysis=false;
fig02=figlayer.Figure2;
fig03=figlayer.Figure3;
fig04=figlayer.Figure4;
fig05=figlayer.Figure5;
fig06=figlayer.Figure6;
fig07=figlayer.Figure7;
fig08=figlayer.Figure8;
fig09=figlayer.Figure9;
fig10=figlayer.Figure10;
fig11=figlayer.Figure11;
fig12=figlayer.Figure12;
fig13=figlayer.Figure13;
fig14=figlayer.Figure14;
fig15=figlayer.Figure15;
fig16=figlayer.Figure16;
fig17=figlayer.Figure17;
%% 
fig02=figlayer.Figure2;
set(gcf, 'InvertHardCopy', 'off');
set(gcf,'Renderer','OpenGL')
print(fig02,'figures/print/ModelFits.png','-dpng','-r600')
close(fig02)
fig03=figlayer.Figure3;
set(gcf, 'InvertHardCopy', 'off');
set(gcf,'Renderer','OpenGL')
print(fig03,'figures/print/HystresisFrequency.png','-dpng','-r600')
close(fig03)
fig04=figlayer.Figure4;
set(gcf, 'InvertHardCopy', 'off');
set(gcf,'Renderer','OpenGL')
print(fig04,'figures/print/SSAODE.png','-dpng','-r600')
close(fig04)
fig05=figlayer.Figure5;
set(gcf, 'InvertHardCopy', 'off');
set(gcf,'Renderer','OpenGL')
print(fig05,'figures/print/3by4ReducedModels.png','-dpng','-r600')
close(fig05)
fig06=figlayer.Figure6;
set(gcf, 'InvertHardCopy', 'off');
set(gcf,'Renderer','OpenGL')
print(fig06,'figures/print/ControlTrajectory_TwoCell.png','-dpng','-r600')
close(fig06)
fig07=figlayer.Figure7;
print(fig07,'figures/print/ControlTrajectory_FourCell.png','-dpng','-r600')
close(fig07)
fig08=figlayer.Figure8;
print(fig08,'figures/print/ControlTrajectory_PredictiveReduced.png','-dpng','-r600')
close(fig08)
fig09=figlayer.Figure9;
print(fig09,'figures/print/ControlTrajectory_PredictiveFull.png','-dpng','-r600')
close(fig09)
fig10=figlayer.Figure10;
set(fig10, 'InvertHardCopy', 'off');
set(fig10,'Renderer','OpenGL')
print(fig10,'figures/print/CalibrationReducedFullModel.png','-dpng','-r600')
close(fig10)
fig11=figlayer.Figure11;
set(gcf, 'InvertHardCopy', 'off');
set(gcf,'Renderer','OpenGL')
print(fig11,'figures/print/ControlTrajectory_PredictiveComparison.png','-dpng','-r600')
close(fig11)
fig12=figlayer.Figure12;
set(gcf, 'InvertHardCopy', 'off');
set(gcf,'Renderer','OpenGL')
print(fig12,'figures/print/3by5FullModels.png','-dpng','-r600')
close(fig12)
fig13=figlayer.Figure13;
set(gcf, 'InvertHardCopy', 'off');
set(gcf,'Renderer','OpenGL')
print(fig13,'figures/print/ControlTrajectory_PredictiveReducedSlowed.png','-dpng','-r600')
close(fig13)
fig14=figlayer.Figure14;
set(gcf, 'InvertHardCopy', 'off');
set(gcf,'Renderer','OpenGL')
print(fig14,'figures/print/ControlTrajectory_PredictiveFullComparison.png','-dpng','-r600')
close(fig14)
fig15=figlayer.Figure15;
set(gcf, 'InvertHardCopy', 'off');
set(gcf,'Renderer','OpenGL')
print(fig15,'figures/print/ControlTrajectory_PredictiveReducedComparison.png','-dpng','-r600')
close(fig15)
fig16=figlayer.Figure16;
set(gcf, 'InvertHardCopy', 'off');
set(gcf,'Renderer','OpenGL')
print(fig16,'figures/print/ControlTrajectoryReducedModel.png','-dpng','-r600')
close(fig16)
fig17=figlayer.Figure17;
set(gcf, 'InvertHardCopy', 'off');
set(gcf,'Renderer','OpenGL')
print(fig17,'figures/print/ControlTrajectoryFullModel.png','-dpng','-r600')
close(fig17)
fig18=figlayer.Figure18;
set(gcf, 'InvertHardCopy', 'off');
set(gcf,'Renderer','OpenGL')
print(fig18,'figures/print/ControlTrajectoryReducedModelReducedControl','-dpng','-r600')
close(fig18)
fig19=figlayer.Figure19;
set(gcf, 'InvertHardCopy', 'off');
set(gcf,'Renderer','OpenGL')
print(fig19,'figures/print/3by5ReducedModels.png','-dpng','-r600')
close(fig19)