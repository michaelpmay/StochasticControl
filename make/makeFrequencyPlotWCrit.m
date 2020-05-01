%make Frequency Analysis
addpath classes
addpath parallel
addpath utility
close all
clear all
build=ModelFactory;
freq=linspace(0.004352715535193,0.004351286963765,8);
freq=0.004
%[0 .001 1]    0.002127283950617, 0.002126950617284      [amp=0.1,dc=.21,Wcrit=0.001688543281894]
%freqUnique=[0.004354144106622,0.004354144106622-0.00001]
T=1./freq;
amp=[.21];%.315
dc=.210;
initialState=[0 40];
time=[0 100000];
steps=650000;%500000
menu=ParallelMenu;
for i=1:length(freq)
  time=[0 200*T(i)]
  for j=1:length(amp)
    for k=1:length(initialState)
      menu=menu.attachTicketItem(@analyzeAutoregulatedFrequency,{freq(i),amp(j),dc,initialState(k),linspace(time(1),time(2),steps)});
    end
  end
end
% for i=1:length(freq)
%   for j=1:length(amp)
%     for k=1:length(initialState)
%       menu=menu.attachTicketItem(@analyzeUnregulatedFrequency,{freq(i),amp(j),dc,initialState(k),linspace(time(1),time(2),steps)});
%     end
%   end
% endclose all

data=menu.run;
N=length(data)/2;
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
  if N==0
    N=length(data{i}.time)-100
  end
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
funSeries10=factory.frequencyInput(timeSeries10,0,[.1 .1 .2]);
AcademicFigure;
plot(timeSeries10,funSeries10);
end

function data=analyzeUnregulatedFrequency(frequency,intensity,offset,state,time)
build=ModelFactory;
model=build.unregulatedModelWithFrequencyInput(frequency,intensity,offset);
solver=SolverODE(model);
solver.model.time=time;
solver.model.initialState=state;
data=solver.run();
end

function data=analyzeAutoregulatedFrequency(frequency,intensity,offset,state,time)
build=ModelFactory;
model=build.autoregulatedModelWithFrequencyInput(frequency,intensity,offset);
solver=SolverODE(model);
solver.model.time=time;
solver.model.initialState=state;
data=solver.run();
end

