clear all

makeFullControlerAutoregulatedModelOptimization(60,70)

makeUniformControlerAutoregulatedModelOptimization(60,20)

makeFullControlerUnregulatedModelOptimization(60,70)

makeUniformControlerUnregulatedModelOptimization(60,20)

makeReducedControlerAutoregulatedModelOptimization(20,20)

function makeFullControlerAutoregulatedModelOptimization(numIterations,gNumIterations)
builder=ModelFactory;
model=builder.autoregulatedModelWithoutInput();
modelFsp=TwoCellFSP(model,[50 50]);
optimizer=GradientControlerOptimizer;
optimizer.initialInputLevel=.3;
optimizer.initialRate=.5;
optimizer.saveInject=false;
optimizer.numIterations=numIterations;
optimizer.gradCalc=FullGradientCalculator();
optimizer.gradCalc.gmresMaxIter=gNumIterations;
modelFsp=optimizer.visit(modelFsp)
controlInput=modelFsp.model.controlInput;
save('data/FullControlerAutoregulatedModelControler','controlInput')
end
function makeUniformControlerAutoregulatedModelOptimization(numIterations,gNumIterations)
builder=ModelFactory;
model=builder.autoregulatedModelWithoutInput();
modelFsp=TwoCellFSP(model,[50 50]);
optimizer=GradientControlerOptimizer;
optimizer.initialInputLevel=1;
optimizer.initialRate=.5/2000;
optimizer.saveInject=false;
optimizer.numIterations=numIterations;
optimizer.gradCalc=UniformGradientCalculator(modelFsp);
optimizer.gradCalc.gmresMaxIter=gNumIterations;
modelFsp=optimizer.visit(modelFsp)
controlInput=modelFsp.model.controlInput;
save('data/UniformControlerAutoregulatedModelControler','controlInput')
end
function makeFullControlerUnregulatedModelOptimization(numIterations,gNumIterations)
builder=ModelFactory;
model=builder.unregulatedModelWithoutInput();
modelFsp=TwoCellFSP(model,[50 50]);
optimizer=GradientControlerOptimizer;
optimizer.initialInputLevel=.3;
optimizer.initialRate=.5;
optimizer.saveInject=false;
optimizer.numIterations=numIterations;
optimizer.gradCalc=FullGradientCalculator();
optimizer.gradCalc.gmresMaxIter=gNumIterations;
modelFsp=optimizer.visit(modelFsp)
controlInput=modelFsp.model.controlInput;
save('data/FullControlerUnregulatedModelControler','controlInput')

end
function makeUniformControlerUnregulatedModelOptimization(numIterations,gNumIterations)
builder=ModelFactory;
model=builder.unregulatedModelWithoutInput();
modelFsp=TwoCellFSP(model,[50 50]);
optimizer=GradientControlerOptimizer;
optimizer.initialInputLevel=.3;
optimizer.initialRate=.5/2000;
optimizer.saveInject=false;
optimizer.numIterations=numIterations;
optimizer.gradCalc=UniformGradientCalculator(modelFsp);
optimizer.gradCalc.gmresMaxIter=gNumIterations;
modelFsp=optimizer.visit(modelFsp)
controlInput=modelFsp.model.controlInput;
save('data/UniformControlerUnegulatedModelControler','controlInput')
end
function makeReducedControlerAutoregulatedModelOptimization(numIterations,gNumIterations)
builder=ModelFactory;
model=builder.autoregulatedModelWithoutInput();
modelFsp=TwoCellFSP(model,[50 50]);
optimizer=GradientControlerOptimizer;
optimizer.initialInputLevel=.3;
optimizer.initialRate=.5/2000;
optimizer.saveInject=true;
optimizer.numIterations=numIterations;
optimizer.gradCalc=ReducedGradientCalculator(modelFsp);
optimizer.gradCalc.gmresMaxIter=gNumIterations;
modelFsp=optimizer.visit(modelFsp)
controlInput=modelFsp.model.controlInput;
save('data/ReducedControlerAutoregulatedModelControler','controlInput')
end