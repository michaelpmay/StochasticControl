addpath classes/
addpath utility/
clear all
data=KhammashTimeSeriesData
optimizer=KhammashParameterOptimizer
optimizer.realData=data
optimizer.targetSpecies=5;
optimizer.maxIter=1;
optimizer.initialRate=.5;
build = ModelFactory
model=build.khammashFullModelWithLightInput()
model.time=data.time;
ode=SolverODE(model)
parameters=[1 1 1 1 1 1 1 1 1 1]
minOde=ode
minOde.model.parameters=parameters
for k=1:100
  parfor i=1:4
  [optODE{i},score(i)]=optimizer.optimize(minOde);
  end
[~,minIndex]=min(score);
minOde=optODE{minIndex}
ode=minOde;
parameters=minOde.model.parameters
end