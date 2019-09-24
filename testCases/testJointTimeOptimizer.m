addpath classes
addpath testCases
build=ModelFactory;
model=build.autoregulatedModelWithUniformInput(.3);
optimizer=JointTimeOptimizer;
optimizer.time=[0 10];
optimizer.deltaTRange=linspace(.25,.5,2);
analysis=optimizer.analyze(model); 