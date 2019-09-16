addpath classes
build=ModelFactory;
modelFsp=build.optimizedTwoCellModel;
optimizer=JointTimeOptimizer;
optimizer.time=[0,100]
analysis=optimizer.analyze(modelFsp.model);
plot(analysis{1}.time,analysis{1}.targetData.node{1}.state);
save('analysis','analysis');
