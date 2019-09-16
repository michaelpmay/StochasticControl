addpath classes
build=ModelFactory;
modelFsp=build.optimizedTwoCellModel;
optimizer=JointTimeOptimizer;
optimizer.time=linspace(0,1,3);
optimizer.deltaTRange=linspace(.1,1,2);
optimizer.analyze(model)