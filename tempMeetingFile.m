addpath classes/
build=ModelFactory;
modelFsp=build.optimizedTwoCellModel;
load inFiles/autoregulatedReducedControler_110gmres.mat
controlInput2D=ones(1,50).*controlInput;
modelFsp.model.controlInput=controlInput2D
modelView=ViewModelFsp(modelFsp);
AcademicFigure
subplot(1,3,1)
modelView.viewControlInput
subplot(1,3,2)
modelView.viewSteadyStateWithTargetScore
subplot(1,3,3)
modelView.viewMarginalWithTarget