addpath classes/
clear all
controlInput=getControlInput(80,30,.6);
function controlInput=getControlInput(gmresIter,numIter,inputLevel)
build=ModelFactory;
model=build.autoregulatedModelWithoutInput;
modelFsp=TwoCellFSP(model,[50 50]);
optimizer=GradientControlerOptimizer;
optimizer.gmresMaxIter=gmresIter;
optimizer.numIterations=numIter;
optimizer.initialInputLevel=inputLevel;
optimizer.initialRate=.5
modelFsp=modelFsp.accept(optimizer);
end
