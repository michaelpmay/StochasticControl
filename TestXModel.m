builder=ModelFactory;
model=builder.autoregulatedModelWithoutInput;
modelFsp=ReducedGradientControlerOptimizer(model,[50 50])
optimizer=GradientControlerOptimizer