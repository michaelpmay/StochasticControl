addpath classes
clear all;
warning('off')
build=ModelFactory;
target=[30;10];
dims =[50 50];
numGIter=30;
numUIter=50;
gmresMaxIter=150;
model=build.unregulatedModelWithoutInput;
controler=UniformControlerOptimizer();
controler.score.target=target;
controler.numIterations=numUIter;
[uuModel,uuControler]=optimizeModel(model,controler,dims);
uuControlInput=uuControler.controlInput;

model=build.unregulatedModelWithoutInput;
controler=GradientControlerOptimizer();
controler.score.target=target;
controler.numIterations=numGIter;
controler.gmresMaxIter=gmresMaxIter;
[ugModel,ugControler]=optimizeModel(model,controler);
ugControlInput=ugControler.controlInput;

model=build.autoregulatedModelWithoutInput;
controler=UniformControlerOptimizer();
controler.score.target=target;
controler.numIterations=numUIter;
[auModel,auControler]=optimizeModel(model,controler);
auControlInput=auControler.controlInput;

model=build.autoregulatedModelWithoutInput;
controler=GradientControlerOptimizer();
controler.score.target=target;
controler.numIterations=numGIter;
controler.gmresMaxIter=gmresMaxIter;
[agModel,agControler]=optimizeModel(model,controler);
agControlerInput=agControler.controlInput;

save('workspaces/ArrayFigOpt.mat');
%view=ArrayFigureView({uuControler,ugControler,auControler,agControler});
%view.plot


function [optimalFSP,optimalControler]=optimizeModel(model,controlOptimizer,dims)
myFSP=TwoCellFSP(model,dims);
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
