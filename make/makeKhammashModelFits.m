addpath classes/
addpath utility/
clear all
data=KhammashTimeSeriesData
optimizer=ParameterOptimizer
optimizer.realData=data
optimizer.targetSpecies=5;
optimizer.maxIter=50;
optimizer.initialRate=2;
build = ModelFactory
model=build.khammashFullModelWithLightInput()
ode=SolverODE(model)
parameters=[38.6138e-003 1.8490e-003 4.8027e+000 1.6850e+006 471.5881e-003 195.7343e-003 1.6801e+003]
for k=1:100
  for i=1:20
  [optODE{i},score(i)]=optimizer.optimize(ode) 
  end
[~,minIndex]=min(score);
minOde=optODE{minIndex}
ode=minOde;
parameters=minOde.model.parameters;
end