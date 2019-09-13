addpath classes/
clear all
controlInput=getControlInput(100,30);
function controlInput=getControlInput(gmresIter,numIter)
build=ModelFactory;
model=build.autoregulatedModelWithoutInput;
modelFsp=TwoCellFSP(model);
optimizer=GradientControlerOptimizer;
optimizer.gmresMaxIter=gmresIter;
optimizer.numIterations=1;
rate=1;
for i=1:numIter
  modelFsp=modelFsp.accept(optimizer);
  controlInput=modelFsp.controlInput;
  save('bestControlInput','controlInput');
  optimizer.initialRate=optimizer.initialRate*.99;
end
end
