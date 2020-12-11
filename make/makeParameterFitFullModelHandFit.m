realdata=KhammashTimeSeriesData;
realdata.state=realdata.state./max(realdata.state).*20;
build = ModelFactoryTestModels;
model=build.fullModelWithExperimentalInput;
%parameters=[1.1164    1.1164/20    1.0000  579.5275    0.0004    0.0024    2.0309  0.0257    1.2718]
%model.parameters=parameters
model.initialState=[0 0 0 0 0]
ode=SolverODE(model)
data=ode.run()
figure
subplot(1,3,1)
plot(data.time,data.state)
legend('1','2','3','4','5');
subplot(1,3,2)
plot(realdata.time,realdata.state,'r*')
hold on
plot(data.time,data.state(5,:),'b-')