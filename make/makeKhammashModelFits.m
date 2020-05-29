addpath classes/
addpath utility/
clear all
data=KhammashTimeSeriesData
data.state=data.state./max(data.state).*20;
optimizer=ParameterOptimizer
optimizer.index=5;
optimizer.data=data;
optimizer.optimizer.maxIter=200;
optimizer.optimizer.initialRate=.1;
build = ModelFactory
model=build.khammashFullModelWithLightInput
ode=SolverODE(model);
ode.model.parameters=[0.3129 0.3135 0.0003 3.0000 0.0100 0.0116 7.3980 0.1463]
n=16;
m=50;
for k=1:m
 parfor i=1:n
  [optode{i},error(i)]=optimizer.visit(ode)
 end
 [minError,minIndex]=min(error);
 ode=optode{minIndex};
end
%ssa=SolverSSA(model);
%ssa.model.time=linspace(0,870,5000)
%dataSSA=ssa.run();
data=ode.run();`
hold on
%plot(dataSSA.node{1}.time,dataSSA.node{1}.state)
realData=KhammashTimeSeriesData
realData.state=realData.state./max(realData.state).*20;
plot(realData.time,realData.state,'r*')
subplot(1,2,1)
plot(data.time,data.state(5,:))
subplot(1,2,2)
plot(data.time,data.state(3,:))