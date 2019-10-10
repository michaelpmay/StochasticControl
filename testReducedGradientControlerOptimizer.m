addpath classes
build=ModelFactory;
model=build.autoregulatedModelWithoutInput;
modelFsp=TwoCellFSP(model,[50 50]);
modelFsp.model.controlInput=.3*ones(50,1);
controler=ReducedGradientControlerOptimizer();
controler.gradCutoffIndex=2500;
controler.gmresMaxIter=5;
modelFsp.accept(controler);
[optimizedControler,U]=controler.optimizeControler();

