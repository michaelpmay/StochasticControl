addpath classes
clear all
build=ModelFactory;
model=build.autoregulatedModelWithoutInput;
ssOptimizer=GradientControlerOptimizer
ssOptimizer.model=TwoCellFSP(model)
ssOptimizer.gmresMaxIter=2;
ssOptimizer.numIterations=2;
model=ssOptimizer.optimizeControler()
dOptimizer=DynamicControlOptimizer(model)
[data,modelFsp,u]=dOptimizer.optimize()
for i=1:34
pcolor(reshape(data.state(:,i),[50 50]))
pause(1)
end