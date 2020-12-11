clear all
close all
%parameters=[2.1673e-03   1.2515e-04   1.7048e-06   1.0000e+03   1.7563e-02   7.0349e+00 2.0226e-01   7.3540e+01   4.5928e-01]
load data/parameters/khammashFullModelWithLightInputFixedU
parameters=[1.0000    1.0932    1.0000  519.0960    0.0004    0.0024    2.0309 0.0257    1.2718]
%parameters(2)=parameters(1)/20;
%parameters(7)=parameters(6)/5;
for j=1:1
  for i=1:5
    [ode{i},error(i)]=do(parameters);
  end
  [~,minIndex]=min(error);
  selection=input('pick best figure:  ')
  parameters=ode{selection}.model.parameters;
  close all
end


function [ode,error]=do(parameters)
addpath(genpath('utility/'))
realdata=KhammashTimeSeriesData;
realdata.state=realdata.state./max(realdata.state).*20;
optimizer=ParameterOptimizer;
optimizer.index=5;
optimizer.strategy=ParameterOptimizerParallelBeeSwarm;
optimizer.data=realdata;
optimizer.strategy.numBees=16; 
optimizer.strategy.numSteps=1;
optimizer.strategy=optimizer.strategy.setLogBounds([-0 -5 -0 -5 -5 -5 -5 -5 -5 -5 -5 -5;
                                                     4  4  0 4  4  4  4  4  4  4  4  4]);
optimizer.strategy.subOptimizer.maxIter=5;
optimizer.strategy.subOptimizer.initialRate=.2;
optimizer.strategy.subOptimizer.minRate=.01;
build = ModelFactoryTestModels;

model=build.fullModelWithExperimentalInput;
model.parameters=parameters;
%model2=build.fullModelWithLightInputFreeU;
ode=SolverODE(model);
%ode2=SolverODE(model2);
%%
  dataIsGood=0;
  while dataIsGood==0
    tIsGood=zeros(size(model.initialState));
    ode=SolverODE(model);
    [tempode,error]=optimizer.visit(ode)
    data=tempode.run();
    for j=1:size(data.state,1)
      if any(data.state(j,:)>=5)&any(data.state(j,:)<=200)
        tIsGood(j)=1;
      end
    end
    if all(tIsGood(4))
      dataIsGood=1;
      ode=tempode;
    end
  end
  parameters=ode.model.parameters;
  parameters(2)=parameters(1)/20;
  %ode1.model.save('data/models/khammashFullModelWithLightInputFixedU.m')
  %save('data/parameters/khammashFullModelWithLightInputFixedU','parameters')
  
%%
% ode2.model.parameters=parameters;
% for i =1:1
%   ode2.model.parameters=ode1.model.parameters;
%   ode2.model.parameters(9:11)=[320 0 20]/320;
%   [ode2,error2]=optimizer.visit(ode2)
%   parameters=ode2.model.parameters;
%   ode2.model.save('data/models/khammashFullModelWithLightInputFreeU.m');
%   save('data/parameters/khammashFullModelWithLightInputFreeU','parameters');
% end
%%
data1=ode.run();
% data2=ode2.run();
figure
subplot(1,3,1)
plot(data1.time,data1.state)
legend('1','2','3','4','5');
subplot(1,3,2)
plot(realdata.time,realdata.state,'r*')
hold on
plot(data1.time,data1.state(5,:),'b-')
% plot(data2.time,data2.state(5,:),'g-')
end