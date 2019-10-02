addpath classes
build=ModelFactory;
modelFsp=build.optimizedTwoCellModel;
optimizer=SemiFiniteTimeOptimizer(modelFsp);
optimizer.maxElements=15;
optimizer.numIterations=15;
%optimizer=optimizer.updatePartialElements(20)
u=optimizer.parallelOptimize();
save('u','u');
while 1
for i=1:length(u)
  pcolorProbability(u{i});
  pause(1)
end
end

