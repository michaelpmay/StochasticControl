%% Make All Figures
% This code is used to create all of the figures in the paper. Some codes
% require a strong server to perform computation, but there is
% precalculated data in the data folder. 

% Any data anlysis can be forcefully recomputed by using :
%     figlayer.axes.datalayer.forceAnalysis=true
% setting this variable to false when making figure through the figlayer
% will re-analyze ALL simulations.
% Warning: 
% 1) Long simulation times required for some analyses (especially
% the Full Model Analyses) may take hours on a 24 core server and days for
% a 2 core laptop. 
% 2) The loading of multiple data sets when creating
% figures may read and crease many gigabytes of data. 
% Solution: 
% 1) Do not set forceAnalysis=true unless you are on a machine than can 
% perform many parallel simulations 
% 2) Do not create more than 1 figure at a time. Close previous figures before openeing new figures.
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
print(fig03,'figures/print/HystresisFrequency.svg','-dpng','-r600')
close(fig03)
fig04=figlayer.Figure4;
set(gcf, 'InvertHardCopy', 'off');
set(gcf,'Renderer','OpenGL')
print(fig04,'figures/print/SSAODE.png','-dpng','-r600')
close(fig04)
fig05=figlayer.Figure5;
set(gcf, 'InvertHardCopy', 'off');
set(gcf,'Renderer','OpenGL')
print(fig05,'figures/print/3by4ReducedModels.svg','-dpng','-r600')
close(fig05)
fig06=figlayer.Figure6;
set(gcf, 'InvertHardCopy', 'off');
set(gcf,'Renderer','OpenGL')
print(fig06,'figures/print/ControlTrajectory_TwoCell.svg','-dpng','-r600')
close(fig06)
fig07=figlayer.Figure7;
print(fig07,'figures/print/ControlTrajectory_FourCell.svg','-dpng','-r600')
close(fig07)
fig08=figlayer.Figure8;
print(fig08,'figures/print/ControlTrajectory_PredictiveReduced.svg','-dpng','-r600')
close(fig08)
fig09=figlayer.Figure9;
print(fig09,'figures/print/ControlTrajectory_PredictiveFull.svg','-dpng','-r600')
close(fig09)
fig10=figlayer.Figure10;
set(fig10, 'InvertHardCopy', 'off');
set(fig10,'Renderer','OpenGL')
print(fig10,'figures/print/CalibrationReducedFullModel.svg','-dpng','-r600')
close(fig10)
fig11=figlayer.Figure11;
set(gcf, 'InvertHardCopy', 'off');
set(gcf,'Renderer','OpenGL')
print(fig11,'figures/print/ControlTrajectory_PredictiveComparison.png','-dpng','-r600')
close(fig11)
fig12=figlayer.Figure12;
set(gcf, 'InvertHardCopy', 'off');
set(gcf,'Renderer','OpenGL')
print(fig12,'figures/print/3by5FullModels.svg','-dpng','-r600')
close(fig12)
fig13=figlayer.Figure13;
set(gcf, 'InvertHardCopy', 'off');
set(gcf,'Renderer','OpenGL')
print(fig13,'figures/print/ControlTrajectory_PredictiveReducedSlowed.svg','-dpng','-r600')
close(fig13)
fig14=figlayer.Figure14;
set(gcf, 'InvertHardCopy', 'off');
set(gcf,'Renderer','OpenGL')
print(fig14,'figures/print/ControlTrajectory_PredictiveFullComparison.svg','-dpng','-r600')
close(fig14)
fig15=figlayer.Figure15;
set(gcf, 'InvertHardCopy', 'off');
set(gcf,'Renderer','OpenGL')
print(fig15,'figures/print/ControlTrajectory_PredictiveReducedComparison.svg','-dpng','-r600')
close(fig15)
fig16=figlayer.Figure16;
set(gcf, 'InvertHardCopy', 'off');
set(gcf,'Renderer','OpenGL')
print(fig16,'figures/print/ControlTrajectoryReducedModel.svg','-dpng','-r600')
close(fig16)
fig17=figlayer.Figure17;
set(gcf, 'InvertHardCopy', 'off');
set(gcf,'Renderer','OpenGL')
print(fig17,'figures/print/ControlTrajectoryFullModel.svg','-dpng','-r600')
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
fig20=figlayer.Figure20;
set(gcf, 'InvertHardCopy', 'off');
set(gcf,'Renderer','OpenGL')
print(fig20,'figures/print/ModelPredictiveControl.png','-dpng','-r600')
close(fig20)