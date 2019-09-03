%make Frequency Analysis
addpath classes
build=ModelFactory;
lowFreq=.01;
highFreq=.1;
lowAmp=.1;
highAmp=.5;
freq=[.01,.1];
amp=[.1 .5];
initialState=[0 40];
time=[0 500];
menu=ParallelMenu;
for i=1:length(freq)
  for j=1:length(amp)
    for k=1:length(initialState)
    menu=menu.attachTicketItem(@analyzeUnregulatedFrequency,{freq(i),amp(j),initialState(k),linspace(time(1),time(2),1000000/freq(i))})
    end
  end
end
for i=1:2
  for j=1:2
    menu=menu.attachTicketItem(@analyzeAutoregulatedFrequency,{freq(i),amp(j),initialState(k),linspace(time(1),time(2),1000000/freq(i))})
  end
end
data=menu.run


figure()
ind=1;
for i=1:length(freq)
  for j=1:length(amp)
    subplot(2,2,ind);
    plot(data{ind}.time,data{ind}.state)    
    ind=ind+1;
  end
end
figure()
for i=1:length(freq)
  for j=1:length(amp)
    subplot(2,2,ind-4);
    plot(data{ind}.time,data{ind}.state)    
    ind=ind+1;
  end
end

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

