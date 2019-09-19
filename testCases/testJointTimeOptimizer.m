addpath classes
addpath testCases
build=ModelFactory;
model=build.autoregulatedModelWithUniformInput(.3);
optimizer=JointTimeOptimizer;
optimizer.time=[0 10];
optimizer.deltaTRange=linspace(.1,1,2);
optimizer.analyze(model)