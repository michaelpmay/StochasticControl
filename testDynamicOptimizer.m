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
dOptimizer.optimize()