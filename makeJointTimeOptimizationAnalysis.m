addpath classes
build=ModelFactory;
model=build.autoregulatedModelWithUniformInput(.0);
optimizer=JointTimeOptimizer;
optimizer.time=linspace(0,500,500);%was 0 50 50 
optimizer.deltaTRange=0.1:0.1:1;%was :20
analysis=optimizer.fastAnalyze(model);
save('analysis','analysis');