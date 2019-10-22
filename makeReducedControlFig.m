load controlInputInjector.mat
controlInput2=controlInput.*ones(1,50);
build=ModelFactory;
modelFsp=build.optimizedTwoCellModel;
modelFsp.model.controlInput=controlInput2;
p=reshape(modelFsp.getSteadyState,[50 50]);
AcademicFigure;
view=ViewTwoCellFSP(modelFsp,gca);
subplot(1,3,1);
view.plotSampledSumForces(4);
view=ViewTwoCellFSP(modelFsp,subplot(1,3,2));
view.plotSteadyStateWithTarget([30 1]);
view=ViewTwoCellFSP(modelFsp,subplot(1,3,3));
view.plotMarginals();
