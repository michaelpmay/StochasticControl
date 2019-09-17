addpath classes
build=ModelFactory
modelFsp=build.optimizedTwoCellModel
optimizer=SemiFiniteTimeOptimizer(modelFsp);
eArray=optimizer.getPartialElements(20)
