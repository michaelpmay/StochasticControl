load dOptimizerWorkspace.mat
addpath classes
warning('off')
build=ModelFactory;
model=build.autoregulatedModelWithoutInput
modelFsp=TwoCellFSP(model);
modelFsp.controlInput=controler;
dOptimizer=DynamicControlOptimizer(modelFsp);
U=dOptimizer.globalOptimize(.00001);
save('U','U');
