addpath classes
build=ModelFactory;
model=build.autoregulatedModelWithUniformInput(.0);
optimizer=JointTimeOptimizer;
optimizer.time=linspace(0,1000,1000);%was 0 50 50 
optimizer.deltaTRange=0.1:0.1:20;%was :20
analysis=optimizer.parallelFastAnalyze(model);
save('analysis','analysis');
