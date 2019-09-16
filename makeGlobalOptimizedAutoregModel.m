addpath classes/
clear all
controlInput=getControlInput(30,30);
function controlInput=getControlInput(gmresIter,numIter)
build=ModelFactory;
model=build.autoregulatedModelWithoutInput;
modelFsp=TwoCellFSP(model,[50 50]);
optimizer=GradientControlerOptimizer;
optimizer.gmresMaxIter=gmresIter;
optimizer.numIterations=1;
optimizer.initialInputLevel=.4;
optimizer.initialRate=.1
rate=.1;
modelFsp=modelFsp.accept(optimizer);
end
