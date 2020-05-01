build=ModelFactory
model=build.unregulatedModelWithoutInput;
model.controlInput=zeros(50,50);
modelFSP=TwoCellFSP(model,[50 50]);
optimizer=GradientControlerOptimizer;
calc=ReducedGradientCalculator(modelFsp);
calc.gmresMaxIter=50;
optimizer.gradCalc=calc;
optimizer.modelFsp=modelFSP;
optimizer.optimizeControler
