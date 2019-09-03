%make Frequency Analysis
addpath classes
clear all
build=ModelFactory;
freq=[.01,.1];
amp=[.1 .5];
initialState=[0 40];
time=[0 500];
menu=ParallelMenu;
for i=1:length(freq)
  for j=1:length(amp)
    for k=1:length(initialState)
      parseTime=single(linspace(time(1),time(2),500000/freq(i)));
      menu=menu.attachTicketItem(@analyzeUnregulatedFrequency,{freq(i),amp(j),initialState(k),parseTime})
    end
  end
end
for i=1:length(freq)
  for j=1:length(amp)
    parseTime=single(linspace(time(1),time(2),500000/freq(i)));
    menu=menu.attachTicketItem(@analyzeAutoregulatedFrequency,{freq(i),amp(j),initialState(k),parseTime})
  end
end
%data=menu.run
%save('workspaceFrequencyPlot')

function data=analyzeUnregulatedFrequency(frequency,intensity,state,time)
build=ModelFactory;
model=build.unregulatedModelWithFrequencyInput(frequency,intensity);
solver=Solver(GenericODE,model);
solver.model.time=time;
solver.model.initialState=state;
data=solver.run();
end

function data=analyzeAutoregulatedFrequency(frequency,intensity,state,time)
build=ModelFactory;
model=build.autoregulatedModelWithFrequencyInput(frequency,intensity);
solver=Solver(GenericODE,model);
solver.model.time=time;
solver.model.initialState=state;
data=solver.run();
end

