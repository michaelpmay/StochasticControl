clear all
close all
build=ModelFactory;
layer=DataLayer;
data=layer.get('CalibrationCurveAutoregulatedFullReduced')
model=build.calibratedFullAutoModel(data.calibration);
model.initialState=100*ones([5,1]);
model.parameters(13)=.6;
ode=SolverODE(model);
trajectory=ode.run();
plot(trajectory.time,trajectory.state(5,:));

model=build.calibratedFullAutoModelWithFrequencyInput(.001,.2,.2)
model.initialState=100*ones([5,1]);
model.time=linspace(0,2000,4000);
ode=SolverODE(model);
trajectory=ode.run();
plot(trajectory.time,trajectory.state(5,:));