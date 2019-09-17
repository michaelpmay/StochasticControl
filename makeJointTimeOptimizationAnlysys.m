addpath classes
build=ModelFactory;
model=build.autoregulatedModelWithUniformInput(.3);
optimizer=JointTimeOptimizer;
optimizer.time=[0,100]
analysis=optimizer.analyze(model);

for i=1:50
endScore(i)=analysis{i}.score(end)
deltaT(i)=analysis{i}.time(2)-analysis{i}.time(1)
end

plot(deltaT,endScore)

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

AcademicFigure
hold on
for i=1:length(analysis)
plot(analysis{i}.time(2:end),analysis{i}.dynamicScore);
end
hold off

AcademicFigure
hold on
plot(analysis{1}.time(2:end),analysis{1}.score);
plot(analysis{5}.time(2:end),analysis{5}.score);
plot(analysis{31}.time(2:end),analysis{31}.score);
hold off


AcademicFigure
hold on
for i=1:length(analysis)
plot(analysis{i}.time(2:end),analysis{i}.u);
end
hold off