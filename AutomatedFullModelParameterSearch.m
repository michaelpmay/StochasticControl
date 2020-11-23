addpath(genpath('utility/'))
realdata=KhammashTimeSeriesData;
realdata.state=realdata.state./max(realdata.state).*20;
build = ModelFactoryTestModels;
model=build.fullModelWithExperimentalInput;
N=24
maxNumCompThreads(24)
optimizer=ParameterOptimizer;
optimizer.strategy=ParameterOptimizerBeeSwarm;
optimizer.data=realdata
optimizer.index=5;
optimizer.strategy.numSteps=2;
optimizer.strategy.numBees=8;
optimizer.strategy.mutationRate=.1;
ode=SolverODE(model);
ode.model.parameters=[1.1164 1.1164/20 1.0000 579.5275 0.0004 0.0024 2.0309 0.0257 1.2718];
parfor i=1:N*4
  i
  optOde{i}=optimize(ode,optimizer);
end

function ode=optimize(ode,optimizer)
ode.model.parameters=ode.model.parameters.*exp(1.5*(rand(size(ode.model.parameters))-.5))
ode=optimizer.optimize(ode)
end