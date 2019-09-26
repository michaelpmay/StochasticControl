addpath classes
addpath testCases
build=ModelFactory;
model=build.autoregulatedModelWithUniformInput(0);
optimizer=JointTimeOptimizer;
optimizer.uRange=[0,.5,1];
optimizer.time=linspace(0,100,100);
optimizer.deltaTRange=.5:.5:5;
analysis=optimizer.fastAnalyze(model);
