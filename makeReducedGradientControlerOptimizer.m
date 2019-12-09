addpath classes
maxIter=40;
initialRate=.1;
build=ModelFactory;
%model=build.autoregulatedModelWithoutInput;
model=build.unregulatedModelWithoutInput;
modelFsp=TwoCellFSP(model,[50 50]);
modelFsp.model.controlInput=2*ones(50,1);
optimizer=ReducedGradientControlerOptimizer();
optimizer.modelFsp=modelFsp;
optimizer.plotInject=true;
optimizer.saveInject=true;
optimizer.initialRate=initialRate;
optimizer.gmresMaxIter=maxIter;
optimizer.initialRate=.03;
[optimizedUnregControler,autoregU]=optimizer.optimizeControler();
controlInput=optimizedUnregControler.model.controlInput;
save('optimizedReducedUnregControler','controlInput');
%%
