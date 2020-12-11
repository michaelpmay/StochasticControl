clear all3
addpath(genpath('utility'))
video=VideoWriter('optimizationVideo')
video.Quality=100;
build=ModelFactoryTestModels
model=build.autoregulatedModelWithUniformLight(0)
model.controlInput=0.3*ones(50);
fsp=TwoCellFSP(model,[50 50]);
optimizer=GradientControlerOptimizer;
optimizer.gradCalc=FullGradientCalculator;
optimizer.gradCalc.gmresMaxIter=30;
optimizer.initialRate=.05;
optimizer.numIterations=1;
video.open
fig=AcademicFigure
fig.Position(3:4)=[1064, 420]
for i=1:50
fsp=optimizer.visit(fsp);
video.writeVideo(getframe(gcf))
end
video.close