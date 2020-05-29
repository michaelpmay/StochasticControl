clear all
close all
build=ModelFactory();
load data/controlers/AutoregulatedModelFullControler.mat
scale=1.5;
N=5;
range=linspace(5,100,10);
for i=1:length(range)
  input=range(i);
  model=build.khammashAutoregulatedFullModelWithControlInput(input);
  ode=SolverODE(model);
  ode1=ode;
  ode2=ode;
  ode1.model.initialState=[1;1;0;0;0];
  ode2.model.initialState=[1;1;0;0;50];
  data1=ode1.run();
  data2=ode2.run();
  D(i)=data1.state(5,end)-data2.state(5,end);
  figure
  hold on
  plot(data1.time,data1.state(5,:));
  plot(data2.time,data2.state(5,:));
end