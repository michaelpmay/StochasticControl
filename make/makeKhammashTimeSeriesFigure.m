addpath classes/
addpath(genpath('utility'))
mu=5000;
sig=4000;
del=500;
bkg=100;
build=ModelFactory;
reducedmodel=build.unregulatedModelWithExperimentalInput();
fullModel=build.fullModel
solver=Strategy(SolverODE,reducedmodel);
%%
AcademicFigure()

axes(1)=subplot(1,2,1);
fig1=KhammashTimeSeriesView(solver,axes(1));
fig1.plotTimeSeries();

axes(2)=subplot(1,2,2);
fig2=KhammashProteinModelView(axes(2));
fig2.plotProteinHistogram();
