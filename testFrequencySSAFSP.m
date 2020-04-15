addpath classes/  
solve(0.001688543281894,.21,.21)
solve(0.001688543281894-0.0000001,.21,.21)

function solve(frequency,amp,dco)
factory=ModelFactory
time=linspace(0,100000,100000+1);
T=1/frequency;
model=factory.buildAutoregulatedFrequencyResponseModel(frequency,amp,dco,2,time)
modelSSA=SolverSSA(model);
u1=factory.frequencyInput(time,0,[frequency amp,dco]);
data1=modelSSA.run();
data11=data1.node{1};
data1.node{1}.time=data1.node{1}.time./T;
X=zeros([80 80]);
for i=1:length(data11.time)
  X(data11.state(1,i)+1,data11.state(2,i)+1)=X(data11.state(1,i)+1,data11.state(2,i)+1)+1;
end
figure
subplot(1,3,1)
plot(time./T,u1)
view=ViewSSA(data1,subplot(1,3,2))
view.plotAll;
subplot(1,3,3)
pcolorProbability(X)
end