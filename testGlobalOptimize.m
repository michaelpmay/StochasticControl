load dOptimizerWorkspace.mat
model.controlInput=controler;
dOptimizer=DynamicControlOptimizer(model);
U=dOptimizer.globalOptimize(.0001);