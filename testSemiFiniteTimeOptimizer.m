addpath classes
build=ModelFactory
modelFsp=build.optimizedTwoCellModel
optimizer=SemiFiniteTimeOptimizer(modelFsp);
optimizer.maxElements=10;
optimizer.numIterations=3
%optimizer=optimizer.updatePartialElements(20)
u=optimizer.optimize()
for i=1:length(u)
  pcolorProbability(u{i})
  pause(.5)
end