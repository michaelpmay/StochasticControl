addpath classes
factory=ModelFactory
model=factory.birthDecayToyModel;
ode=SolverODE(model);
data.time=linspace(1,5)
data.state=2*ones(1,100)
optimizer=ParameterOptimizer()
optimizer.data=data
[ode,error]=optimizer.optimize(ode)



function [model,error]=optimizeMyODE(optimizer,model,name)
model.time=optimizer.realData.time;
[model,error]=model.accept(optimizer);
optimizer.model=model;
scoreString=num2str(error);
scoreString=strrep(scoreString,'.','_');
model.saveAs([name,'_',scoreString],'outFiles/odeOptimization');
end
