addpath classes
build=ModelFactory;
model=build.autoregulatedModelWithUniformInput(.3);
optimizer=JointTimeOptimizer;
optimizer.time=linspace(0,500,500);
optimizer.deltaTRange=0.1:0.1:20;
analysis=optimizer.parallelFastAnalyze(model);
save('analysis','analysis');
