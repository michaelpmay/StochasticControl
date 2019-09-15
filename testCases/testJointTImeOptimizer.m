addpath classes
build=ModelFactory;
model=build.autoregulatedModelWithoutInput;
model.controlInput=.3*ones([50 50])
optimizer=JointTimeOptimizer
optimizer.optimize(model)