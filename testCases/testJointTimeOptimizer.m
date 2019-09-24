addpath classes
addpath testCases
build=ModelFactory;
model=build.autoregulatedModelWithUniformInput(.3);
optimizer=JointTimeOptimizer;
optimizer.uRange=[0,.5,1];
optimizer.time=[0 10];
optimizer.deltaTRange=linspace(.25,.5,2);
analysis=optimizer.fastAnalyze(model); 