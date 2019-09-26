addpath classes
build=ModelFactory;
model=build.autoregulatedModelWithUniformInput(.3);
optimizer=JointTimeOptimizer;
optimizer.time=[0,1000];
optimizer.deltaTRange=0.1:0.1:50;
analysis=optimizer.parallelFastAnalyze(model);
%%save('analysis','analysis');
