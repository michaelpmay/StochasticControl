clear all
build=ModelFactory
lightRange=linspace(0,320,3)
realData=KhammashTimeSeriesData
beta=20/max(realData.state)
for i=1:1
  for j=1:length(lightRange)
model=build.unregulatedModelWithUniformLight(320)
ode=SolverODE(model)
data=ode.run
steadyState(j)=data.state(end)
  end
end

build=ModelFactory
lightRange=linspace(0,320,3)
realData=KhammashTimeSeriesData
alpha=20/max(realData.state)
for i=1:1
  for j=1:length(lightRange)
model=build.unregulatedModelWithUniformLight(320)
ode=SolverODE(model)
data=ode.run
steadyState(j)=data.state(end)
  end
end