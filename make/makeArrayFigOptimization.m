clear all

makeFullControlerAutoregulatedModelOptimization(3,2)

makeUniformControlerAutoregulatedModelOptimization(3,2)

makeFullControlerUnregulatedModelOptimization(3,2)

makeUniformControlerUnregulatedModelOptimization(3,2)

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
optimizer.initialInputLevel=1;
optimizer.initialRate=.5/2000;
optimizer.saveInject=false;
optimizer.numIterations=numIterations;
optimizer.gradCalc=UniformGradientCalculator(modelFsp);
optimizer.gradCalc.gmresMaxIter=gNumIterations;
modelFsp=optimizer.visit(modelFsp)
controlInput=modelFsp.model.controlInput;
save('data/UniformControlerUnegulatedModelControler','controlInput')
end
