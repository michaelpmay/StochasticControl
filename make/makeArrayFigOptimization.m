addpath classes/
addpath utility/
clear all
builder=ModelFactory;
model{1}=builder.unregulatedModelWithoutInput();
model{2}=builder.autoregulatedModelWithoutInput();
optimizer=GradientControlerOptimizer;
optimizer.initialInputLevel=.3;
optimizer.initialRate=.1;
optimizer.saveInject=false;
optimizer.numIterations=60;
optimizer.gradCalc=FullGradientCalculator();
optimizer.gradCalc.gmresMaxIter=80;

for i=1:2
  for j=1:2
    modelFsp=TwoCellFSP(model{1},[50 50]);
    modelFsp.model.controlInput=zeros(50);
    modelFsp.model.controlInput=zeros(50);
    if j==1
      optimizer=GradientControlerOptimizer;
      optimizer.initialInputLevel=.3;
      optimizer.initialRate=.1;
      optimizer.saveInject=false;
      optimizer.numIterations=2;
      optimizer.gradCalc=FullGradientCalculator();
      optimizer.gradCalc.gmresMaxIter=6;
      optimizer.gradCalc=FullGradientCalculator();
    else
      optimizer=GradientControlerOptimizer;
      optimizer.initialInputLevel=.3;
      optimizer.initialRate=.01;
      optimizer.saveInject=false;
      optimizer.numIterations=2;
      optimizer.gradCalc.gmresMaxIter=6;
      optimizer.gradCalc=UniformGradientCalculator(modelFsp);
    end
    optFsp{i,j}=optimizer.visit(modelFsp);
    controlerInput{i,j}=optFsp{i,j}.model.controlInput;
  end
end
save('data/workspaces/workspaceMakeArrayFigOptimization')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
