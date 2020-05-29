model=ModelFSP(AutoregulatedParameters);
model.time=linspace(0,1,5);
data=model.run();
data.plotMovie();
model.controlInput=10*ones(50,50);
ssData=model.getSteadyState();
ssData.plotImage(1);