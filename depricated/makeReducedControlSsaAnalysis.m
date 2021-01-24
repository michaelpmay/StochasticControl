addpath classes 
build=ModelFactory;

load controlInputInjector.mat
controlInput=controlInput';
controlInput(end+200)=0;
model=build.reducedNCellUnregulatedModel(5,controlInput);
model.time=linspace(0,5000,5000);
analyzer=ReducedControlerSsaAnalysis(model);
analysis=analyzer.analyze;
uData=analysis.getAllTimeSeries(1);

model=build.reducedNCellAutoregulatedModel(5,controlInput);
model.time=linspace(0,50000,50000);
analyzer=ReducedControlerSsaAnalysis(model);
analysis=analyzer.analyze;
aData=analysis.getAllTimeSeries(1);

AcademicFigure;
subplot(2,2,1);
plot(uData.time,uData.state(2:end,:),'b-',uData.time,uData.state(1,:),'r-');
subplot(2,2,2);
hold on
histogram(uData.state(1,:),'normalization','probability')
histogram(uData.state(2:end,:),'normalization','probability')
hold off
subplot(2,2,3);
plot(aData.time,aData.state(2:end,:),'b-',aData.time,aData.state(1,:),'r-');
subplot(2,2,4)
hold on
histogram(aData.state(1,:),'normalization','probability')
histogram(aData.state(2:end,:),'normalization','probability')
hold off