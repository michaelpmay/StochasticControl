addpath classes
build=ModelFactory;
model=build.khammashFitModel;
model.parameters(1)=10
model.parameters(3)=320
model.parameters(2)=.020
solver=Solver(GenericODE,model);
optimizer=ParameterOptimizer;
optimizer.realData=KhammashTimeSeriesData;
minError=inf;
minSolver=solver;
while 1
  for j=1:5
    solver.model.parameters=solver.model.parameters;
    for k=1:5
    [solver,error]=solver.accept(optimizer);
    error
    if error<minError
      minSolver=solver
    end
      solver=minSolver;
    end
  end
  
  data=solver.run();
  hold on
  plot(data.time,data.state);
  plot(optimizer.realData.time,optimizer.realData.state);
  hold off
end
