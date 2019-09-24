modelFsp=build.optimizedTwoCellModel;
modelFsp.model.time=linspace(0,10);
modelFsp.model.controlInput=.3*ones([50 50])
optimizer=AlphaTimeControlOptimizer(modelFsp)