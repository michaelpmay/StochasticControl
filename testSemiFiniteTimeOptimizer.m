addpath classes
build=ModelFactory;
modelFsp=build.optimizedTwoCellModel;
optimizer=SemiFiniteTimeOptimizer(modelFsp);
optimizer.maxElements=15;
optimizer.numIterations=15;
%optimizer=optimizer.updatePartialElements(20)
u=optimizer.parallelOptimize();
optimizer.time=linspace(0,5,50);%was 0 50 50 
save('u','u');
while 1
for i=1:length(u)
  pcolorProbability(u{i});
  pause(1)
end
end

