addpath classes
build=ModelFactory;
model=build.autoregulatedModelWithUniformInput(.3);
optimizer=JointTimeOptimizer;
optimizer.time=[0,100];
optimizer.deltaTRange=0.1:0.1:20;
analysis=optimizer.analyze(model);
save('analysis','analysis');