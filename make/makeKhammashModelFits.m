addpath classes/
addpath utility/
clear all
data=KhammashTimeSeriesData
optimizer=KhammashParameterOptimizer
optimizer.realData=data
optimizer.targetSpecies=5;
optimizer.maxIter=10;
optimizer.initialRate=.01;
build = ModelFactory
model=build.khammashFullModelWithLightInput()
model.time=data.time;
ode=SolverODE(model)
parameters=[.10 .02 .1 .02 10 110 .002 .001 3 65000]
minOde=ode
minOde.model.parameters=parameters
for k=1:100
  for i=1:4
  [optODE{i},score(i)]=optimizer.optimize(minOde);
  end
[~,minIndex]=min(score);
minOde=optODE{minIndex}
ode=minOde;
parameters=minOde.model.parameters
end
data=fullRun(ode,[.10 .02 .1 .02 10 110 .002 .001 3 65000])
data.state(5,:)=data.state(5,:)*12366/20
hold on
plot(data.time,data.state)
realData=KhammashTimeSeriesData
plot(realData.time,realData.state,'r*')
function data=run(ode,parameters)
ode.model.parameters=parameters
data=ode.run
subplot(1,2,1)
plot(data.time,data.state(1:4,:))
subplot(1,2,2)
plot(data.time,data.state(5,:))
end

function data=fullRun(ode,parameters)
ode.model.parameters=parameters
ode.model.time=0:10:780
data=ode.run
subplot(1,2,1)
plot(data.time,data.state(1:4,:))
subplot(1,2,2)
plot(data.time,data.state(5,:))
end