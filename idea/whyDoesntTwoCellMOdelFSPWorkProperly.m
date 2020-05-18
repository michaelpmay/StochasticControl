addpath classes /
addpath utility/
clear all
close all
builder=ModelFactory;
initialState=40;
lightlevel=.1
model{1}=builder.unregulatedModelWithoutInput();
model{1}.controlInput=lightlevel*ones([50 50]);
model{1}.initialState=initialState;
model{2}=builder.unregulatedModelWithUniformLight(lightlevel);
model{2}.controlInput=.0*ones([50 50]);
model{2}.initialState=initialState;

for i=1:2
  ode{i}=SolverODE(model{i});
  data{i}=ode{i}.run;
  fsp{i}=TwoCellFSP(model{i},[50,50]);
  Pxy{i}=fsp{i}.getSteadyStateReshape();
  Mx{i}=sum(Pxy{i},2)'*[0:49]'
  My{i}=sum(Pxy{i},1)*[0:49]'
end

figure
subplot(1,3,1)
plot(data{1}.time,data{1}.state)
subplot(1,3,2)
plot(data{2}.time,data{2}.state)
subplot(1,3,3)

