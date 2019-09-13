addpath classes
build=ModelFactory;
model=build.autoregulatedModelWithoutInput;
optimizer=JointTimeOptimizer
optimizer.optimize(model)