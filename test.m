build=ModelFactory
model1=build.unregulatedModelWithUniformLight(0)
model2=build.unregulatedModelWithoutInput()
controlInput=ones(50,50)*.3
model1.controlInput=controlInput
model2.controlInput=controlInput
fsp1=TwoCellFSP(model1,[50 50])
fsp2=TwoCellFSP(model2,[50 50])
data1=fsp1.getSteadyStateReshape()
data2=fsp2.getSteadyStateReshape()
subplot(1,2,1)
pcolorProbability(data1)
subplot(1,2,2)
pcolorProbability(data2)