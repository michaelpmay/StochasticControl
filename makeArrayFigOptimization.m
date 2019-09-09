addpath classes
build=ModelFactory;
target=[30;10];
numGIter=3;
numUIter=5;
gmresMaxIter=8;
model=build.unregulatedModelWithoutInput;
controler=UniformControlerOptimizer();
controler.score.target=target;
controler.numIterations=numUIter;
[uuModel,uuControler]=optimizeModel(model,controler);

model=build.unregulatedModelWithoutInput;
controler=GradientControlerOptimizer();
controler.score.target=target;
controler.numIterations=numGIter;
controler.gmresInputMaxIter=gmresMaxIter;
[ugModel,ugControler]=optimizeModel(model,controler);

model=build.autoregulatedModelWithoutInput;
controler=UniformControlerOptimizer();
controler.score.target=target;
controler.numIterations=numUIter;
[auModel,auControler]=optimizeModel(model,controler);

model=build.autoregulatedModelWithoutInput;
controler=GradientControlerOptimizer();
controler.score.target=target;
controler.numIterations=numGIter;
controler.gmresInputMaxIter=gmresMaxIter;
[agModel,agControler]=optimizeModel(model,controler);

save('ArrayFigOpt');

AcademicFigure()
plotModel(uuControler,1);
plotModel(ugControler,2);
plotModel(auControler,3);
plotModel(agControler,4);

function [optimalFSP,optimalControler]=optimizeModel(model,controlOptimizer)
myFSP=TwoCellFSP(model);
[optimalFSP,optimalControler]=myFSP.accept(controlOptimizer);
end
function plotModel(controler,colNum)
subplotIndex=[0 4 8];
view=ViewTwoCellFSP(controler.model,subplot(3,4,subplotIndex(1)+colNum));
view.plotSampledSumForces(4);
view=ViewTwoCellFSP(controler.model,subplot(3,4,subplotIndex(2)+colNum));
view.plotSteadyStateWithTarget(controler.score.target);
view=ViewTwoCellFSP(controler.model,subplot(3,4,subplotIndex(3)+colNum));
view.plotMarginals();
end
