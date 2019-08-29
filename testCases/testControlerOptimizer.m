
model=ModelFSP(AutoregulatedParameters);
model.gmresInputMaxIter=5;
controler=ControlerOptimizer(model);
controler.gradCutoffIndex=2500;
[optimizedControler,U]=controler.optimizeControler(1);

