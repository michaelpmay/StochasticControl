addpath classes
build=ModelFactory;
model=build.autoregulatedModelWithUniformInput(.3);
optimizer=JointTimeOptimizer;
optimizer.time=[0,1];
optimizer.deltaTRange=0.1:0.1:.2;
analysis=optimizer.analyze(model);
%%save('analysis','analysis');
