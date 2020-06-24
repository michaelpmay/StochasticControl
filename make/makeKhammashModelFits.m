addpath(genpath('utility/'))
clear all
realdata=KhammashTimeSeriesData;
realdata.state=realdata.state./max(realdata.state).*20;
optimizer=ParameterOptimizer;
optimizer.index=5;
optimizer.strategy=ParameterOptimizerParallelBeeSwarm;
optimizer.data=realdata;
optimizer.strategy.numBees=16;
optimizer.strategy.numSteps=2;  
optimizer.strategy=optimizer.strategy.setLogBounds([-5 -5 -5 -5 -5 -5 -5 -5 -0 -5 -0;
                                                     3 3  3  3  3  3  3  3  3  1  3]);
optimizer.strategy.subOptimizer.maxIter=20;
optimizer.strategy.subOptimizer.initialRate=.1;
build = ModelFactoryTestModels;
model1=build.khammashFullModelPooledT7FixedU;
model2=build.khammashFullModelPooledT7FreeU;
ode1=SolverODE(model1);
ode2=SolverODE(model2);
ode1.model.parameters=.1*ones(size(ode1.model.parameters));
%%
for i=1:100
[ode1,error1]=optimizer.visit(ode1)
parameters=ode1.model.parameters
ode1.model.save('data/models/khammashModelPooledT7FixedU.m')
save('data/parameters/khammashModelPooledT7FixedUNoRestriction.mat')
end
%%
ode2.model.parameters(9:11)=[320 0 20];
optimizer.strategy=optimizer.strategy.setLogBounds([log10(parameters)-.2 -3 -3 -3
                                 log10(parameters)+.2  3  3  3])
for i =1:10
[ode2,error2]=optimizer.strategy.optimize(ode2,realdata,5);
parameters=ode2.model.parameters
ode2.model.save('data/models/khammashModelPooledT7FreeU.m')
save('data/parameters/khammashModelPooledT7FreeUNoRestriction.mat')
end
%%
data1=ode1.run()
data2=ode2.run()
figure
subplot(1,2,1)
plot(data2.time,data2.state)
subplot(1,2,2)
plot(realdata.time,realdata.state,'r*')
hold on
plot(data1.time,data1.state(5,:),'b-')
plot(data2.time,data2.state(5,:),'g-')