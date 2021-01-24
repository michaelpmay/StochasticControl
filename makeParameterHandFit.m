addpath(genpath('utility'))

layer=DataLayer;
data=layer.get('ModelFit_UnregulatedReducedModel');
model.parameters=[0.000000000100000   0.020300000000000   0.461971407775547 0 08];
model.time=realdata.time
ode=SolverODE(data.model)
trajectory=ode.run;
indVec=[1,2,3,4,5,6,7,8 9 11 13 15 16 17 18 19];
errorFunction=@(y,x)sum(((y(indVec)-x(indVec))./y(indVec)).^2);

error=errorFunction(realdata.state/max(realdata.state)*20,trajectory.state(1,:))
hold on
plot(trajectory.time,realdata.state/max(realdata.state)*20)
plot(trajectory.time,trajectory.state(1,:))
%%
addpath(genpath('utility'))
realdata=KhammashTimeSeriesData
build=ModelFactory;
model=build.fullModelWithFitInput
model.parameters=[2/10,10/10/20,1,20,.05,.5,.5,.0142,0.4060  0.0000  0.04];
model.time=[-500 realdata.time];
ode=SolverODE(model)
trajectory=ode.run;
indVec=[1,2,3,4,5,6,7,8 9 11 13 15 16 17 18 19];
errorFunction=@(y,x)sum(((y(indVec)-x(indVec))./y(indVec)).^2);
error=errorFunction(realdata.state/max(realdata.state)*20,trajectory.state(5,:))
figure
plot(realdata.time,realdata.state/max(realdata.state)*20,'k.','MarkerSize',24)
hold on
plot(trajectory.time,trajectory.state(5,:))
%%
ssa=SolverSSA(data.model);
ssa.model.time=linspace(0,5000,10001)
tic
data=ssa.run(50);
time1=toc
sss.model.parameters=[1.1164,1.1164/20,1.0000,579.5275,0.0004,0.0024,2.0309,0.025,1.2718];
tic
ssa.run(50);
time2=toc