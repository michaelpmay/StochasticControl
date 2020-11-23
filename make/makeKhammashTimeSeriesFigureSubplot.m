build=ModelFactoryTestModels
model=build.fullModelWithExperimentalInput
ode=SolverODE(model)
data=ode.run
close all
figure 
hold on
plot(data.time,data.state(5,:),'LineWidth',2)

model=build.khammashFitModel
ode=SolverODE(model)
data=ode.run
plot(data.time,data.state(1,:),'LineWidth',2)

data=KhammashTimeSeriesData
plot(data.time,data.state(1,:),'ro')
yyaxis right
data=KhammashTimeSeriesData
plot(data.time,data.state/max(data.state)*20,'ro')
axis=[0 780 0 22.65]