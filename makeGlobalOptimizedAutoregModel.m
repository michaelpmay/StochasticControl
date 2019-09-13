addpath classes/
clear all
controlInput=getControlInput(100,30);
save('bestControlInput');
function controlInput=getControlInput(gmresIter,numIter)
build=ModelFactory;
model=build.autoregulatedModelWithoutInput;
modelFsp=TwoCellFSP(model);
optimizer=GradientControlerOptimizer;
optimizer.gmresMaxIter=gmresIter;
optimizer.numIterations=numIter;
modelFsp=modelFsp.accept(optimizer);
controlInput=modelFsp.controlInput;
end
