addpath classes
build=ModelFactory;
model=build.autoregulatedModelWithoutInput;
modelFsp=TwoCellFSP(model,[50 50]);
modelFsp.model.controlInput=.3*ones(50,1);
controler=ReducedGradientControlerOptimizer();
modelFsp.accept(controler);
controler.gmresMaxIter=2
controler.saveInject=true;
controler.plotInject=true;
[optimizedControler,U]=controler.optimizeControler();

