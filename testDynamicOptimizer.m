addpath classes
optimizer=DynamicControlOptimizer;
build=ModelFactory;
model=build.autoregulatedModelWithoutInput;
optimizer.optimize(model);