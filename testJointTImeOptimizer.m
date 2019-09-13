addpath classes
build=ModelFactory;
model=build.autoregulatedModelWithUniformInput(.01);
model.controlInput=ones([50 50])*.3
optimizer=JointTimeOptimizer
[tData,nTData,u]=optimizer.optimize(model)
figure()
subplot(1,3,1)
vSSA=ViewSSA(tData,gca)
vSSA.plotAllTimeSeries(1)
subplot(1,3,2)
plot(nTData.state)
subplot(1,3,3)
plot(u)