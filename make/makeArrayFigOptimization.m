clear all
addpath(genpath('utility/'))
%controlInput=makeFullControlerAutoregulatedModelOptimization(60,70)
%save('data/FullControlerAutoregulatedModelControler','controlInput')

%controlInput=makeUniformControlerAutoregulatedModelOptimization(60,20)
%save('data/UniformControlerAutoregulatedModelControler','controlInput')


%controlInput=makeFullControlerUnregulatedModelOptimization(60,70)
%save('data/UniformControlerUnegulatedModelControler','controlInput')


controlInput=makeUniformControlerUnregulatedModelOptimization(60,20)
%save('data/UniformControlerUnegulatedModelControler','controlInput')

%controlInput=makeReducedControlerAutoregulatedModelOptimization(90,120)
%save('data/controlers/ReducedControlerAutoregulatedModelControler.mat','controlInput')
function controlInput=makeFullControlerAutoregulatedModelOptimization(numIterations,gNumIterations)
builder=ModelFactory;
model=builder.autoregulatedModelWithoutInput();
modelFsp=TwoCellFSP(model,[50 50]);
optimizer=GradientControlerOptimizer;
optimizer.initialControler=.3*ones(50);
optimizer.initialRate=.5;
optimizer.saveInject=false;
optimizer.numIterations=numIterations;
optimizer.gradCalc=FullGradientCalculator();
optimizer.gradCalc.gmresMaxIter=gNumIterations;
modelFsp=optimizer.visit(modelFsp)
controlInput=modelFsp.model.controlInput;
end
function controlInput=makeUniformControlerAutoregulatedModelOptimization(numIterations,gNumIterations)
builder=ModelFactory;
model=builder.autoregulatedModelWithoutInput();
modelFsp=TwoCellFSP(model,[50 50]);
optimizer=GradientControlerOptimizer;
optimizer.initialControler=.3*ones(50);
optimizer.initialRate=.5;
optimizer.saveInject=false;
optimizer.numIterations=numIterations;
optimizer.gradCalc=UniformGradientCalculator(modelFsp);
optimizer.gradCalc.gmresMaxIter=gNumIterations;
modelFsp=optimizer.visit(modelFsp)
controlInput=modelFsp.model.controlInput;
end
function controlInput=makeFullControlerUnregulatedModelOptimization(numIterations,gNumIterations)
builder=ModelFactory;
model=builder.unregulatedModelWithoutInput();
modelFsp=TwoCellFSP(model,[50 50]);
optimizer=GradientControlerOptimizer;
optimizer.initialControler=.3*ones(50);
optimizer.initialRate=.5;
optimizer.saveInject=false;
optimizer.numIterations=numIterations;
optimizer.gradCalc=FullGradientCalculator();
optimizer.gradCalc.gmresMaxIter=gNumIterations;
modelFsp=optimizer.visit(modelFsp)
controlInput=modelFsp.model.controlInput;

end
function controlInput=makeUniformControlerUnregulatedModelOptimization(numIterations,gNumIterations)
builder=ModelFactory;
model=builder.unregulatedModelWithoutInput();
modelFsp=TwoCellFSP(model,[50 50]);
modelFsp.model.controlInput=.0*ones(50);
optimizer=GradientControlerOptimizer;
optimizer.initialRate=.5;
optimizer.saveInject=false;
optimizer.numIterations=numIterations;
optimizer.gradCalc=UniformGradientCalculator(modelFsp);
optimizer.gradCalc.gmresMaxIter=gNumIterations;
modelFsp=optimizer.visit(modelFsp)
controlInput=modelFsp.model.controlInput;
end
function controlInput=makeReducedControlerAutoregulatedModelOptimization(numIterations,gNumIterations)
builder=ModelFactory;
model=builder.autoregulatedModelWithoutInput();
load data/controlers/ReducedControlerAutoregulatedModelControler.mat
modelFsp=TwoCellFSP(model,[50 50]);
optimizer=GradientControlerOptimizer;
optimizer.initialControler=controlInput;
optimizer.initialRate=.02;
optimizer.saveInject=true;
optimizer.numIterations=numIterations;
optimizer.gradCalc=ReducedGradientCalculator(modelFsp);
optimizer.gradCalc.gmresMaxIter=gNumIterations;
modelFsp=optimizer.visit(modelFsp)
controlInput=modelFsp.model.controlInput;
end
