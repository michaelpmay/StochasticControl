addpath classes
numOptIter=5
numGmresIter=100
decrement=.99
initialOptRate=2
target=[30;10]
autoregModel=AutoRegulatedPlugin();
autoregModel.input=@(t,x)0
%%
gradOptimizer=GradientControlerOptimizer();
gradOptimizer.numIterations=5;
gradOptimizer.initialRate=.5;
gradOptimizer.decrement=decrement;
gradOptimizer.target=target;
model=ModelFSP(AutoregulatedPlugin);
model.gmresInputMaxIter=numGmresIter;
agModel=model.accept(gradOptimizer);

uniformOptimizer=UniformControlerOptimizer();
uniformOptimizer.numIterations=numOptIter;
uniformOptimizer.range=[0,3];
uniformOptimizer.numIterations=50;
uniformOptimizer.target=target;
model=ModelFSP(AutoregulatedPlugin);
auModel=model.accept(uniformOptimizer);

gradOptimizer=GradientControlerOptimizer();
gradOptimizer.numIterations=50;
gradOptimizer.initialRate=.5;
gradOptimizer.decrement=.99;
gradOptimizer.initialInputLevel=.1;
gradOptimizer.target=target;
model=ModelFSP(UnregulatedPlugin);
model.gmresInputMaxIter=5;
ugModel=model.accept(gradOptimizer);

uniformOptimizer=UniformControlerOptimizer();
uniformOptimizer.numIterations=numOptIter;
uniformOptimizer.range=[0,3];
uniformOptimizer.numIterations=500;
uniformOptimizer.target=target;
model=ModelFSP(UnregulatedPlugin);
uuModel=model.accept(uniformOptimizer);

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