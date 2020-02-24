factory=ModelFactory
amp=.1
frq=.001
dco=.25
time=linspace(0,200000,200000+1);
model=factory.buildAutoregulatedFrequencyResponseModel(frq,amp,dco,2,time)
modelSSA=SolverSSA(model);
u1=factory.frequencyInput(time,0,[frq amp,dco]);
data1=modelSSA.run();
data11=data1.node{1};
X=zeros([80 80]);
for i=1:length(data11.time)
  X(data11.state(1,i)+1,data11.state(2,i)+1)=X(data11.state(1,i)+1,data11.state(2,i)+1)+1;
end
model=factory.buildAutoregulatedFrequencyResponseModel(.000,amp,dco,2,time)
modelSSA=SolverSSA(model);
data2=modelSSA.run();
u2=factory.frequencyInput(time,0,[000 amp,dco]);
Y=zeros([80 80]);
data22=data2.node{1};
for i=1:length(data22.time)
  Y(data22.state(1,i)+1,data22.state(2,i)+1)=Y(data22.state(1,i)+1,data22.state(2,i)+1)+1;
end
figure
subplot(3,2,1)
plot(time,u1)
subplot(3,2,2)
plot(time,u2)
view=ViewSSA(data1,subplot(3,2,3))
view.plotAll;
view=ViewSSA(data2,subplot(3,2,4))
view.plotAll;
subplot(3,2,5)
pcolorProbability(X)
subplot(3,2,6)
pcolorProbability(Y)