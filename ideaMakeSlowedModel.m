layer=DataLayer
data=layer.get('CalibrationCurveUnregulatedFullReduced')
currentState=[0 0 0 0 0]';
uRange=linspace(0,2,100);
build=ModelFactory;
model1=build.calibratedFullModel(data.calibration);
ode1=SolverODE(model1);
u=.5;
ode1.model.parameters(9)=u;
ode1.model.time=linspace(0,5000,1000);
model2=build.unregulatedModelWithUniformLightSlowed(u);
ode2=SolverODE(model2);
ode2.model.parameters(3)=u;
ode2.model.time=linspace(0,5000,1000);
trajectory1=ode1.run;
trajectory2=ode2.run;
figure 
hold on
plot(trajectory1.time,trajectory1.state(5,:))
plot(trajectory2.time,trajectory2.state(1,:))
