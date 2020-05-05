addpath classes
addpath utility/
clear all
builder=ModelFactory
model=builder.unregulatedModelWithoutInput();
modelFsp=TwoCellFSP(model,[50 50])
modelFsp.model.controlInput=zeros(50)
optimizer=GradientControlerOptimizer
optimizer.saveInject=false;
optimizer.numIterations=20
optimizer.gradCalc=FullGradientCalculator;
optimizer.gradCalc.gmresMaxIter=30;
%afFsp=optimizer.visit(modelFsp)

optimizer.gradCalc=UniformGradientCalculator(modelFsp);
optimizer.gradCalc.gmresMaxIter=10;
optimizer.initialRate=.001
uuFsp=optimizer.visit(modelFsp)

view=ViewTwoCellFSP(modelFsp,axes)
subplot(1,2,1)
view.plotSteadyState
subplot(1,2,2)
view.plotSampledSumForces(5)
%%%%%%%%%%%%
optimizer.gradCalc=ReducedGradientCalculator(modelFsp);
optimizer.gradCalc.gmresMaxIter=5;
rGrad=optimizer.visit(modelFsp)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
minLightRange=.2
maxLightRange=.8
for k=1:10
lightRange=linspace(minLightRange,maxLightRange,11)
scorer=ProbabilityScore([50 50])
for i=1:length(lightRange)
  model=builder.unregulatedModelWithUniformLight(lightRange(i))
  model.controlInput=0*ones(50)
  fsp=TwoCellFSP(model,[50 50])
  score(i)=scorer.getScore(fsp.getSteadyStateReshape)
end
[~,minInd]=min(score)
minLightRange=lightRange(minInd-1);
maxLightRange=lightRange(minInd+1);
end
