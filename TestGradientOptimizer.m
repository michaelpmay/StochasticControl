addpath classes
builder=ModelFactory
model=builder.autoregulatedModelWithoutInput;
modelFsp=TwoCellFSP(model,[50 50])
optimizer=GradientControlerOptimizer
optimizer.gradCalc=FullGradientCalculator;
optimizer.visit(modelFsp)
grad=obj.trimGrad(grad);