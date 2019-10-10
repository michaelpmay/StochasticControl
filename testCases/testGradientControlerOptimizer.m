addpath classes
build=ModelFactory;
model=build.autoregulatedModelWithoutInput;
modelFsp=TwoCellFSP(model,[50 50]);
controler=GradientControlerOptimizer();
controler.gradCutoffIndex=2500;
modelFsp.accept(controler);
[optimizedControler,U]=controler.optimizeControler();

