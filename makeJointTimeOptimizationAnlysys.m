addpath classes
build=ModelFactory;
model=build.autoregulatedModelWithUniformInput(.3);
optimizer=JointTimeOptimizer;
optimizer.time=[0,200];
optimizer.deltaTRange=0.1:0.1:20;
analysis=optimizer.parallelFastAnalyze(model);
%%save('analysis','analysis');
