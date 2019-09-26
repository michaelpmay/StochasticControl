build=ModelFactory;
modelFsp=build.optimizedTwoCellModel;
modelFsp.model.time=linspace(0,50,500);
modelFsp.model.controlInput=.3*ones([50 50]);
optimizer=AlphaTimeControlOptimizer(modelFsp);
optimizer.optimize;
