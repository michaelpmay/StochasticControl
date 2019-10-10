addpath classes
build=ModelFactory;
model=build.autoregulatedModelWithoutInput;
modelFsp=TwoCellFSP(model,[50 50]);
modelFsp.model.controlInput=.3*ones(50,1);
controler=ReducedGradientControlerOptimizer();
modelFsp.accept(controler);
[optimizedControler,U]=controler.optimizeControler();

