fig=open('figures/ArrayFig_30_10_edits.fig')
afControler=fig.Children(5).Children(end).CData
auControler=fig.Children(8).Children(end).CData
ufControler=fig.Children(11).Children(end).CData
uuControler=fig.Children(14).Children(end).CData

addpath classes
addpath utility
builder=ModelFactory
afModel=builder.autoregulatedModelWithUniformInput(0)
ufModel=builder.unregulatedModelWithUniformLight(0)
auModel=builder.autoregulatedModelWithUniformInput(0)
uuModel=builder.unregulatedModelWithUniformLight(0)
afModel.controlInput=afControler;
auModel.controlInput=auControler;
ufModel.controlInput=ufControler;
uuModel.controlInput=uuControler;
target=[30;10];
AcademicFigure()
figure()
plotModel(uuModel,1,target)
plotModel(ufModel,2,target)
plotModel(auModel,3,target)
plotModel(afModel,4,target)

function plotModel(model,colNum,target)
subplotIndex=[0 4 8];
fsp=TwoCellFSP(model,[50 50])
view=ViewTwoCellFSP(fsp,subplot(3,4,subplotIndex(1)+colNum))
view.plotSampledSumForces(4)
view=ViewTwoCellFSP(fsp,subplot(3,4,subplotIndex(2)+colNum))
view.plotSteadyStateWithTarget(target)
view=ViewTwoCellFSP(fsp,subplot(3,4,subplotIndex(3)+colNum))
view.plotMarginals()
end