addpath classes/
addpath utility/
build=ModelFactory;
controlInput=10*ones(100);
model=build.khammashFullModelWithControlInput(controlInput)
model.time=linspace(0,50);
modelSSA=SolverSSA(model);
data=modelSSA.run();
view=ViewSSA(data,subplot(1,1,1));
view.plotTimeSeries(5,1)