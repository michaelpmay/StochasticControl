addpath classes
addpath utility/
clear all
builder=ModelFactory
model=builder.autoregulatedModelWithoutInput;
modelFsp=TwoCellFSP(model,[50 50])
modelFsp.model.controlInput=.35*ones(2500)
optimizer=GradientControlerOptimizer
optimizer.numIterations=20
optimizer.gradCalc=FullGradientCalculator;
optimizer.gradCalc.gmresMaxIter=5;
%fGrad=optimizer.visit(modelFsp)

optimizer.gradCalc=UniformGradientCalculator(modelFsp);
optimizer.gradCalc.gmresMaxIter=10;
uGrad=optimizer.visit(modelFsp)

optimizer.gradCalc=ReducedGradientCalculator(modelFsp);
optimizer.gradCalc.gmresMaxIter=5;
%rGrad=optimizer.visit(modelFsp)
