addpath classes/
addpath utility/
clear all
data=KhammashTimeSeriesData
optimizer=KhammashParameterOptimizer
optimizer.realData=data
optimizer.targetSpecies=5;
optimizer.maxIter=10;
optimizer.initialRate=.02;
build = ModelFactory
model=build.khammashFullModelWithLightInput()
model.time=data.time;
ode=SolverODE(model)
parameters=[38.6138e-003 1.8490e-003 4.8027e+000 1.6850e+006 471.5881e-003 195.7343e-003 1.6801e+003]
for k=1:100
  parfor i=1:4
  [optODE{i},score(i)]=optimizer.optimize(ode);
  end
[~,minIndex]=min(score);
minOde=optODE{minIndex}
ode=minOde;
parameters=minOde.model.parameters;
end