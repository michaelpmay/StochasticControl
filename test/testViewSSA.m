addpath classes
addpath testCases
load('inFiles\OptimizedUnregulatedODE.mat');
myOptimizedODE=obj;
myParameters=myOptimizedODE.parameters
myParameters.ko=0
myParameters.u=[2 0]
myParameters.inputSignal=@(x,t,u)u(1)*(t<500)+u(2)*(t>500)
ssa=ModelSSA(myParameters);
ssa.time=linspace(0,1000,10000);
data=ssa.run();
axes1=subplot(1,1,1);
visual1=ViewSSA(data,axes1);

visual1.plotTimeSeries(1,1)
visual1.plotWindowHistogram(1,1000,5000);