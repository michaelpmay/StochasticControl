addpath classes
build=ModelFactory;
target=[30;10];
numGIter=30;
numUIter=500;
gmresMaxIter=100;
model=build.unregulatedModelWithoutInput;
controler=UniformControlerOptimizer();
controler.target=target;
controler.numIterations=numUIter;
[uuModel,uuControler]=optimizeModel(model,controler)

model=build.unregulatedModelWithoutInput;
controler=GradientControlerOptimizer();
controler.target=target;
controler.numIterations=numGIter;
controler.gmresInputMaxIter=gmresMaxIter;
[ugModel,ugControler]=optimizeModel(model,controler)

model=build.autoregulatedModelWithoutInput;
controler=UniformControlerOptimizer();
controler.target=target;
controler.numIterations=numUIter;
[auModel,auControler]=optimizeModel(model,controler);

model=build.autoregulatedModelWithoutInput
controler=GradientControlerOptimizer();
controler.target=target;
controler.numIterations=numGIter;
controler.gmresInputMaxIter=gmresMaxIter;
[agModel,agControler]=optimizeModel(model,controler)

save('ArrayFigOpt');

AcademicFigure()
plotModel(uuControler.model,1,target);
plotModel(ugControler.model,2,target);
plotModel(auControler.model,3,target);
plotModel(agControler.model,4,target);

function [optimalFSP,optimalControler]=optimizeModel(model,controlOptimizer)
myFSP=TwoCellFSP(model);
[optimalFSP,optimalControler]=myFSP.accept(controlOptimizer);
end
function plotModel(model,colNum,target)
subplotIndex=[0 4 8];
view=ViewTwoCellFSP(model,subplot(3,4,subplotIndex(1)+colNum));
view.plotSampledSumForces(4);
view=ViewTwoCellFSP(model,subplot(3,4,subplotIndex(2)+colNum));
view.plotSteadyStateWithTarget(target);
view=ViewTwoCellFSP(model,subplot(3,4,subplotIndex(3)+colNum));
view.plotMarginals();
end