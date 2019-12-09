addpath classes/
build=ModelFactory;
modelFsp=build.optimizedTwoCellModel;
load inFiles/autoregulatedReducedControler_110gmres.mat
controlInput2D=ones(1,50).*controlInput;
modelFsp.model.controlInput=controlInput2D
modelView=ViewModelFsp(modelFsp);
fig=AcademicFigure;
fig.Position(3:4)=[1600 400];
subplot(1,3,1)
modelView.viewControlInput
tightLayout()
subplot(1,3,2)
modelView.viewSteadyStateWithTargetScore
tightLayout()
subplot(1,3,3)
modelView.viewMarginalWithTarget
tightLayout()
zczsd