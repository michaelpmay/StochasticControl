agModelControl=loadObj('outFiles/target30_10/agModel_98_3445');
auModelControl=loadObj('outFiles/target30_10/auModel_402_6431');
ugModelControl=loadObj('outFiles/target30_10/ugModel_237_0000');
uuModelControl=loadObj('outFiles/target30_10/uuModel_240_0000');

target=[10;30];
AcademicFigure()
plotModel(uuModelControl.model,1,target)
plotModel(ugModelControl.model,2,target)
plotModel(auModelControl.model,3,target)
plotModel(agModelControl.model,4,target)

function plotModel(model,colNum,target)
subplotIndex=[0 4 8];
view=ViewModelFSP(model,subplot(3,4,subplotIndex(1)+colNum))
view.plotSampledSumForces(4)
view=ViewModelFSP(model,subplot(3,4,subplotIndex(2)+colNum))
view.plotSteadyStateWithTarget(target)
view=ViewModelFSP(model,subplot(3,4,subplotIndex(3)+colNum))
view.plotMarginals()
end