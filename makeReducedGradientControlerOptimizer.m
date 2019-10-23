addpath classes
maxIter=90
initialRate=.05;
build=ModelFactory;
model=build.autoregulatedModelWithoutInput;
modelFsp=TwoCellFSP(model,[50 50]);
modelFsp.model.controlInput=2*ones(50,1);
controler=ReducedGradientControlerOptimizer();
controler.modelFsp=modelFsp;
controler.plotInject=true;
controler.saveInject=true;
controler.initialRate=initialRate;
controler.gmresMaxIter=maxIter;
[optimizedAutoregControler,autoregU]=controler.optimizeControler();
save('optimizedReducedAutoregControler');
