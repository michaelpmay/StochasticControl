addpath classes
build=ModelFactory;
modelFsp=build.optimizedTwoCellModel;
optimizer=SemiFiniteTimeOptimizer(modelFsp);
optimizer.maxElements=20;
optimizer.numIterations=10;
%optimizer=optimizer.updatePartialElements(20)
u=optimizer.optimize();
save('u','u');

