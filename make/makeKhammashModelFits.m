clear all
close all
%parameters=[2.1673e-03   1.2515e-04   1.7048e-06   1.0000e+03   1.7563e-02   7.0349e+00 2.0226e-01   7.3540e+01   4.5928e-01]
parameters=[1 1 1 1 1 1 1 1]
%parameters(2)=parameters(1)/20;
%parameters(7)=parameters(6)/5;
for j=1:10
  for i=1:5
    [ode1{i},ode2{i},error1(i),error2(i)]=do(parameters);
  end
  [~,minIndex]=min(error1);
  selection=input('pick best figure')
  parameters=ode1{selection}.model.parameters;
  close all
end
function [ode1,ode2,error1,error2]=do(parameters)
addpath(genpath('utility/'))
realdata=KhammashTimeSeriesData;
realdata.state=realdata.state./max(realdata.state).*20;
optimizer=ParameterOptimizer;
optimizer.index=5;
optimizer.strategy=ParameterOptimizerParallelBeeSwarm;
optimizer.data=realdata;
optimizer.strategy.numBees=16;
optimizer.strategy.numSteps=2;
optimizer.strategy=optimizer.strategy.setLogBounds([-3 -5  log(1/320) -5 -5 -2 -5 -5 -5 -5 -5;
  5  5  log(1/320)  3  3  3  3  3  3  3  3]);
optimizer.strategy.subOptimizer.maxIter=20;
optimizer.strategy.subOptimizer.initialRate=.1;
build = ModelFactoryTestModels;

model1=build.khammashFullModelWithLightInputFixedU;
%model1.parameters=parameters;
model2=build.khammashFullModelWithLightInputFreeU;
ode1=SolverODE(model1);
ode2=SolverODE(model2);
%%
for i=1:2
  dataIsGood=0;
  while dataIsGood==0
    tIsGood=zeros(size(model1.initialState));
    ode1=SolverODE(model1);
    [tempode,error1]=optimizer.visit(ode1)
    data=tempode.run();
    for j=1:size(data.state,1)
      if any(data.state(j,:)>=10)
        tIsGood(j)=1;
      end
    end
    if all(tIsGood(4))
      dataIsGood=1;
    end
  end
  parameters=ode1.model.parameters;
  parameters(2)=parameters(1)/20
  ode1.model.save('data/models/khammashFullModelWithLightInputFixedU.m')
  save('data/parameters/khammashFullModelWithLightInputFixedU','parameters')
end
%%

for i =1:1
  ode2.model.parameters=ode1.model.parameters;
  ode2.model.parameters(9:11)=[320 0 20];
  [ode2,error2]=optimizer.visit(ode2)
  parameters=ode2.model.parameters;
  parameters(2)=parameters(1)/20;
  ode2.model.save('data/models/khammashFullModelWithLightInputFreeU.m');
  save('data/parameters/khammashFullModelWithLightInputFreeU','parameters');
end
%%
data1=ode1.run();
data2=ode2.run();
figure
subplot(1,3,1)
plot(data2.time,data2.state)
legend('1','2','3','4','5');
subplot(1,3,2)
plot(realdata.time,realdata.state,'r*')
hold on
plot(data1.time,data1.state(5,:),'b-')
plot(data2.time,data2.state(5,:),'g-')
subplot(1,3,3)
plot([0 20 320],ode2.model.parameters(end-[1,0,2]))
end