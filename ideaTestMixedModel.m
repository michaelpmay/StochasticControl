build=ModelFactory;
model=build.mixModelFullExperimentalInput;
model.initialState=[1 0 0]';
model.parameters=[1.2092    1.3103    1.5256    1.0519    1.1278    1.3225    0.9667    1.4110];
ode=SolverODE(model);
realdata=KhammashTimeSeriesData;
realdata.state=realdata.state./max(realdata.state)*20;
indVec=[1,2,3,4,5,6,7,8 9 11 13 15 16 17 18 19];
optimizer=ParameterOptimizerPseudoRandom;
optimizer.errorFunction=@(y,x)sum(((y(indVec)-x(indVec))./y(indVec)).^2);
for i=1:100
[ode,error]=optimizer.optimize(ode,realdata,3);
error
end
trajectory=ode.run();
figure
plot(trajectory.time,trajectory.state(3,:));
%% Test Pseudo Full Model
build=ModelFactory;
uRange=logspace(-5,0,100);
figure
model=build.fullModelWithFitInput()
model.time=linspace(0,2000,300);
ode=SolverODE(model);
trajectory=ode.run();
hold on
plot(trajectory.time,trajectory.state(5,:));

speeds=100000
for i=1:length(speeds)
model=build.speedFullModelFitInput(speeds(i))
model.time=linspace(0,2000,300);
ode=SolverODE(model);
trajectory=ode.run();
hold on
plot(trajectory.time,trajectory.state(5,:));
end

%% Calibrate from full Model
build=ModelFactory;
uRange=logspace(-5,0,100);
for i=1:length(uRange)
model=build.speedFullModelWithUniformLight(10000,uRange(i));
model.time=linspace(0,5000,3);
ode=SolverODE(model);
trajectory=ode.run();
protein1(i)=trajectory.state(5,end);
end
for i=1:length(uRange)
model=build.unregulatedModelWithUniformLight(uRange(i))
model.time=linspace(0,5000,3);
ode=SolverODE(model);
trajectory=ode.run();
protein2(i)=trajectory.state(1,end);
end
pRange=linspace(0,min([max(protein1),max(protein)]),200)
c1=interp1(protein1,uRange,pRange);
c2=interp1(protein2,uRange,pRange);
figure 
plot(c2,c1);
speeds=1000
for i=1:length(speeds)
model=build.psudoFullModelExperimentalInput(speeds(i))
ode=SolverODE(model);
trajectory=ode.run();
hold on
plot(trajectory.time,trajectory.state(5,:)*speeds(i));
end
figure
plot(trajectory.time,trajectory.state(5,:));