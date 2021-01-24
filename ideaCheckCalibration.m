layer=DataLayer
layer.update('CalibrationCurveUnregulatedFullReduced')
data=layer.get('CalibrationCurveUnregulatedFullReduced')
currentState=[0 0 0 0 0]';
uRange=linspace(0,2,100);
build=ModelFactory;
model=build.calibratedFullModel(data.calibration);
modelOde=SolverODE(model);
for i=1:length(uRange)
modelOde.model.time=linspace(0,3500,50);
modelOde.model.initialState=currentState;
modelOde.model.parameters(9)=uRange(i);
trajectory=modelOde.run;
currentState=trajectory.state(:,end);
history1(i)=currentState(5,end);
end
model=build.unregulatedModelWithUniformLight(0);
modelOde=SolverODE(model);
currentState=[0]';
for i=1:length(uRange)
modelOde.model.time=linspace(0,3500,50);
modelOde.model.initialState=currentState;
modelOde.model.parameters(3)=uRange(i);
trajectory=modelOde.run;
currentState=trajectory.state(:,end);
history2(i)=currentState(1,end);
end
figure
hold on
plot(uRange,history1)
plot(uRange,history2)
%%
clear all
layer=DataLayer
%layer.update('CalibrationCurveUnregulatedFullReduced')
data=layer.get('CalibrationCurveAutoregulatedFullReduced');
currentState=[0 0 0 0 0]';
uRange=linspace(0,2,100);
build=ModelFactory;
model=build.calibratedFullAutoModel(data.calibration);
modelOde=SolverODE(model);
for i=1:length(uRange)
modelOde.model.time=linspace(0,3500,50);
modelOde.model.initialState=currentState;
modelOde.model.parameters(13)=uRange(i);
trajectory=modelOde.run;
currentState=trajectory.state(:,end);
history1(i)=currentState(5,end);
end
model=build.autoregulatedModelWithUniformLight(0);
modelOde=SolverODE(model);
currentState=[0]';
for i=1:length(uRange)
modelOde.model.time=linspace(0,3500,50);
modelOde.model.initialState=currentState;
modelOde.model.parameters(6)=uRange(i);
trajectory=modelOde.run;
currentState=trajectory.state(:,end);
history2(i)=currentState(1,end);
end
figure
hold on
plot(uRange,history1)
plot(uRange,history2)
%%
clear all
layer=DataLayer;
layer.update('CalibrationCurveUnregulatedFullReduced');
data=layer.get('CalibrationCurveUnregulatedFullReduced');
currentState=[0 0 0 0 0]';
uRange=linspace(0,2,100);
build=ModelFactory
for i=1:1:length(uRange)
model=build.calibratedFullModel(data.calibration);
modelOde=SolverODE(model);
modelOde.model.time=linspace(0,3500,50);
modelOde.model.initialState=currentState;
modelOde.model.parameters(9)=uRange(i);
trajectory=modelOde.run;
currentState=trajectory.state(:,end);
history(i)=currentState(5,end);
end
figure
plot(uRange,history);