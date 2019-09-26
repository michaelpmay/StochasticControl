addpath classes
addpath testCases
build=ModelFactory;
model=build.autoregulatedModelWithUniformInput(0);
optimizer=JointTimeOptimizer;
optimizer.uRange=[0,.5,1];
optimizer.time=[0 100];
optimizer.deltaTRange=linspace(.1,1,5);
analysis=optimizer.fastAnalyze(model);
