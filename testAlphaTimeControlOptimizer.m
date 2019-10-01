build=ModelFactory;
modelFsp=build.optimizedTwoCellModel;
modelFsp.model.time=linspace(0,500,5);
initialModel=modelFsp;
initialModel.model.controlInput=.3*ones([50 50]);
modelFsp.model.initialState=initialModel.getSteadyState;
optimizer=AlphaTimeControlOptimizer(initialModel);
[probability,control,score]=optimizer.optimize;
