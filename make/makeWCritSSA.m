addpath classes/
addpath utility/
clear all
frequency=0.0045;
amplitude=.210;
offset=.210;
initialState=[0];
numCycles=50
time=linspace(0,numCycles/frequency,2000);
dataSSA=analyzeSSA(frequency,amplitude,offset,initialState,time)
dataODE1=analyzeODE(frequency,amplitude,offset,[10],time)
dataODE2=analyzeODE(frequency,amplitude,offset,[20],time)
dataODE1.time=dataODE1.time*frequency
dataODE2.time=dataODE2.time*frequency
for i=1:dataSSA.length
  dataSSA.node{i}.time=dataSSA.node{i}.time*frequency;
end
figure
viewSSA=ViewSSA(dataSSA,subplot(1,2,1))
subplot(1,2,1)
hold on
viewODE1=ViewODE(dataODE1,gca)
viewODE2=ViewODE(dataODE2,gca)
viewODE1.plotTimeSeries(1)
viewODE2.plotTimeSeries(1)
viewSSA.plotTimeSeries(1,1)
viewSSA2=ViewSSA(dataSSA,subplot(1,2,2))
viewSSA2.plotSnapshotHistogram(1,(length(time)/2):length(time),0:60)
function data=analyzeSSA(frequency,amplitude,offset,state,time)
build=ModelFactory;
model=build.autoregulatedModelWithFrequencyInput(frequency,amplitude,offset);
solver=SolverSSA(model);
solver.model.time=time;
solver.model.initialState=state;
data=solver.run(20);
end
function data=analyzeODE(frequency,amplitude,offset,state,time)
build=ModelFactory;
model=build.autoregulatedModelWithFrequencyInput(frequency,amplitude,offset);
solver=SolverODE(model);
solver.model.time=time;
solver.model.initialState=state;
data=solver.run();
end