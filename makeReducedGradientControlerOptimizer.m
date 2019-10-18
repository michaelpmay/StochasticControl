addpath classes
build=ModelFactory;
model=build.autoregulatedModelWithoutInput;
modelFsp=TwoCellFSP(model,[50 50]);
modelFsp.model.controlInput=.3*ones(50,1);
controler=ReducedGradientControlerOptimizer();
controler.modelFsp=modelFsp;
[optimizedAutoregControler,autoregU]=controler.optimizeControler();

model=build.unregulatedModelWithoutInput;
modelFsp=TwoCellFsp(model,[50 50]);
modelFsp.model.controlInput=.3*ones(50,1);
controler=ReducedGradientControlerOptimizer;
controler.modelFSp=modelFsp;
[optimizedUnregControler,unregU]=controler.optimizeControler;
