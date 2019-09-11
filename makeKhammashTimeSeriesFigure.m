addpath classes
mu=5000;
sig=4000;
del=500;
bkg=100;
build=ModelFactory;
model=build.khammashFitModel
optimizer=ParameterOptimizer;
optimizer.realData=KhammashTimeSeriesData;
optimizer.maxIter=500;
solver=Strategy(SolverODE,model);
%%
AcademicFigure()

axes(1)=subplot(2,2,1);
fig1=KhammashTimeSeriesView(solver,axes(1))
fig1.plotTimeSeries()

axes(2)=subplot(2,2,2);
fig2=KhammashProteinModelView(axes(2))
fig2.plotProteinHistogram();

axes(3)=subplot(2,2,3)
fig3=KhammashProteinModelView(axes(3))
fig3=fig3.setNBins(200);
fig3.plotOnOffBiExpIntensityHistogram(mu,sig,del,bkg);



axes(4)=subplot(2,2,4);
plot(biExponentialMap([ .01 .1  1 10 100 10000 15000 20000 30000 40000 50000 60000 70000 80000 100000 200000]),...
                      [.0   15 .0 .0 .0      0     5    35    70   100    70    55    35    25     10      0],'k-');
