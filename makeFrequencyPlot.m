%make Frequency Analysis
addpath classes
close all
clear all
build=ModelFactory;
freq=[.1 .0001];
amp=[.35];%.315
initialState=[0 40];
time=[0 50000];
steps=250000;%250000
menu=ParallelMenu;
for i=1:length(freq)
  for j=1:length(amp)
    for k=1:length(initialState)
      menu=menu.attachTicketItem(@analyzeAutoregulatedFrequency,{freq(i),amp(j),initialState(k),linspace(time(1),time(2),steps)});
    end
  end
end
data=menu.run
makePlots(data,menu,build);

menu=ParallelMenu;
for i=1:length(freq)
  for j=1:length(amp)
    for k=1:length(initialState)
      menu=menu.attachTicketItem(@analyzeUnregulatedFrequency,{freq(i),amp(j),initialState(k),linspace(time(1),time(2),steps)});
    end
  end
end
data=menu.run;
makePlots(data,menu,build);
%save('workspaceFrequencyPlot')

function makePlots(data,menu,factory)
for i=1:2:length(data)
  figure
  hold on
  plot(data{i}.time,data{i}.state);
  plot(data{i+1}.time,data{i+1}.state);
  hold off
end
frequency={};
period={};
for i=1:length(data)
  frequency{i}=menu.ticketItems{i}.input{1};
  period{i}=2/frequency{i};
  N=sum(data{i}.time<(data{i}.time(end)-period{i}));
  trimData{i}.time=data{i}.time(N:end);
  trimData{i}.time=linspace(0,2,length(trimData{i}.time));
  trimData{i}.state=data{i}.state(N:end);
end
AcademicFigure;
for i=1:2:length(data)
  hold on
  plot(trimData{i}.time,trimData{i}.state);
  plot(trimData{i+1}.time,trimData{i+1}.state);
  hold off
end
timeSeries10=linspace(0,20,500);
funSeries10=factory.frequencyInput(timeSeries10,0,[.1 .315]);
AcademicFigure;
plot(timeSeries10,funSeries10);
end

function data=analyzeUnregulatedFrequency(frequency,intensity,state,time)
build=ModelFactory;
model=build.unregulatedModelWithFrequencyInput(frequency,intensity);
solver=SolverODE(model);
solver.model.time=time;
solver.model.initialState=state;
data=solver.run();
end

function data=analyzeAutoregulatedFrequency(frequency,intensity,state,time)
build=ModelFactory;
model=build.autoregulatedModelWithFrequencyInput(frequency,intensity);
solver=SolverODE(model);
solver.model.time=time;
solver.model.initialState=state;
data=solver.run();
end

