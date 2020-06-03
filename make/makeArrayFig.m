factory=ModelFactory
aModel=factory.autoregulatedModelWithoutInput()
uModel=factory.unregulatedModelWithoutInput()

uuControler=load('data/controlers/UniformControlerUnegulatedModelControler.mat')
ufControler=load('data/controlers/FullControlerUnregulatedModelControler.mat')
auControler=load('data/controlers/UniformControlerAutoregulatedModelControler.mat')
afControler=load('data/controlers/FullControlerAutoregulatedModelControler.mat')

uuModel=uModel;
uuModel.controlInput=uuControler.controlInput;
ufModel=uModel;
ufModel.controlInput=ufControler.controlInput;
auModel=aModel;
auModel.controlInput=auControler.controlInput;
afModel=aModel;
afModel.controlInput=afControler.controlInput;

dims=[50 50]
uuFsp=TwoCellFSP(uuModel,dims);
ufFsp=TwoCellFSP(ufModel,dims);
auFsp=TwoCellFSP(auModel,dims);
afFsp=TwoCellFSP(afModel,dims);

target=[30 10];
AcademicFigure()
plotModel(uuFsp,1,target)
plotModel(ufFsp,2,target)
plotModel(auFsp,3,target)
plotModel(afFsp,4,target)

function plotModel(model,colNum,target)
subplotIndex=[0 4 8];

view=ViewTwoCellFSP(model,subplot(3,4,subplotIndex(1)+colNum))
view.plotSampledSumForces(4)
caxis([0 2]);

view=ViewTwoCellFSP(model,subplot(3,4,subplotIndex(2)+colNum))
view.plotSteadyStateWithTarget(target)

view=ViewTwoCellFSP(model,subplot(3,4,subplotIndex(3)+colNum))
view.plotMarginals()
end