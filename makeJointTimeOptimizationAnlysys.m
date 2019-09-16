addpath classes
build=ModelFactory;
modelFsp=build.optimizedTwoCellModel;
optimizer=JointTimeOptimizer;
optimizer.time=[0,100]
analysis=optimizer.analyze(modelFsp.model);

AcademicFigure
hold on
for i=1:length(analysis)
plot(analysis{i}.time,analysis{i}.targetData.node{1}.state);
end
hold off

AcademicFigure
hold on
for i=1:length(analysis)
plot(analysis{i}.time(2:end),analysis{i}.score);
end
hold off