addpath classes /
addpath utility/
clear all
builder=ModelFactory;
initialState=0;
lightlevel=.2
model{1}=builder.autoregulatedModelWithoutInput();
model{1}.controlInput=lightlevel*ones([50 50]);
model{1}.initialState=initialState;
model{2}=builder.autoregulatedModelWithUniformLight(lightlevel);
model{2}.controlInput=.0*ones([50 50]);
model{2}.initialState=initialState;
model{3}=builder.autoregulatedModelWithControlInput(lightlevel*ones([100 100]));
model{3}.controlInput=.0*ones([50 50]);
model{3}.initialState=initialState;

for i=1:2
  ode{i}=SolverODE(model{i});
  data{i}=ode{i}.run;
  fsp{i}=TwoCellFSP(model{i},[50,50]);
  Pxy{i}=fsp{i}.getSteadyStateReshape();
  Mx{i}=sum(Pxy{i},2)'*[0:49]'
end
fsp{3}=TwoCellFSP(model{3},[50,50]);
  Pxy{3}=fsp{3}.getSteadyStateReshape();
  Mx{3}=sum(Pxy{3},1)*[0:49]'
figure
subplot(1,3,1)
plot(data{1}.time,data{1}.state)
subplot(1,3,2)
plot(data{2}.time,data{2}.state)
subplot(1,3,3)

