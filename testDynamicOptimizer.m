build=ModelFactory;
model=build.autoregulatedModelWithoutInput
modelFsp=TwoCellFSP(model)
optimizer=GradientControlerOptimizer
optimizer.gmresMaxIter=1;
optimizer.numIterations=1;
modelFsp=modelFsp.accept(optimizer)
%%

%%
dOptimizer=DynamicControlOptimizer(modelFsp)
dOptimizer.time=linspace(0,5,50)
[data,modelFsp,u]=dOptimizer.optimize()
N=length(data.time)
%%
for i=1:N
pcolor(reshape(data.state(:,i),[50 50]))
pause(1)
end
%%
pss=model.getSteadyState();
steadyMarginal1=sum(pss,1);
steadyMarginal2=sum(pss,2);


sampleProbability=preAllocateArray(50,50);
for i=1:N
sampleProbability=sampleProbability+reshape(data.state(:,i),[50 50]);
end
sampleProbability=sampleProbability/N;
dynamicP=sampleProbability;
dyanmicMarginal1=sum(dynamicP,1);
dynamicMarginal2=sum(dynamicP,2);
figure
hold on
plot(steadyMarginal1);
plot(steadyMarginal2);
hold off
figure
hold on
plot(dyanmicMarginal1);
plot(dynamicMarginal2);
hold off
score=ProbabilityScore(model)
score.getScore(pss)
score.getScore(dynamicP)