addpath classes
maxIter=60;
initialRate=.1;
build=ModelFactory;
%model=build.autoregulatedModelWithoutInput;
model=build.unregulatedModelWithoutInput;
modelFsp=TwoCellFSP(model,[50 50]);
modelFsp.model.controlInput=2*ones(50,1);
controler=ReducedGradientControlerOptimizer();
controler.modelFsp=modelFsp;
controler.plotInject=true;
controler.saveInject=true;
controler.initialRate=initialRate;
controler.gmresMaxIter=maxIter;
[optimizedAutoregControler,autoregU]=controler.optimizeControler();
save('optimizedReducedUnregControler');
%%
