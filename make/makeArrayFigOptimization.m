addpath classes/
addpath utility/
clear all
builder=ModelFactory;
model{1}=builder.unregulatedModelWithoutInput();
model{2}=builder.autoregulatedModelWithoutInput();
for i=1:2
  for j=1:2
    modelFsp=TwoCellFSP(model{i},[50 50]);
    modelFsp.model.controlInput=zeros(50);
    modelFsp.model.controlInput=zeros(50);
    if j==1
      optimizer=GradientControlerOptimizer;
      optimizer.initialInputLevel=.3;
      optimizer.initialRate=.5;
      optimizer.saveInject=false;
      optimizer.numIterations=50;
      optimizer.gradCalc=FullGradientCalculator();
      optimizer.gradCalc.gmresMaxIter=100;
    else
      optimizer=GradientControlerOptimizer;
      optimizer.initialInputLevel=.3;
      optimizer.initialRate=.5/2000;
      optimizer.saveInject=false;
      optimizer.numIterations=50;
      optimizer.gradCalc=UniformGradientCalculator(modelFsp);
      optimizer.gradCalc.gmresMaxIter=8;
      
    end
    optFsp{i,j}=optimizer.visit(modelFsp);
    controlerInput{i,j}=optFsp{i,j}.model.controlInput;
  end
end
save('data/workspaces/workspaceMakeArrayFigOptimization')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
