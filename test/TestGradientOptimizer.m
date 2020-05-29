addpath classes
builder=ModelFactory
model=builder.autoregulatedModelWithoutInput;
modelFsp=TwoCellFSP(model,[50 50])
optimizer=GradientControlerOptimizer
optimizer.numIterations=3
optimizer.gradCalc=FullGradientCalculator;
%fGrad=optimizer.visit(modelFsp)

optimizer.gradCalc=UniformGradientCalculator(modelFsp);
uGrad=optimizer.visit(modelFsp)

optimizer.gradCalc=ReducedGradientCalculator(modelFsp);
rGrad=optimizer.visit(modelFsp)

