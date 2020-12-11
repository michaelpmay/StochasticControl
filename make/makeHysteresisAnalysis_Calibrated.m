%makeHisteresisFigure
addpath(genpath('utility'))
clear all
build=ModelFactoryTestModels;
autoModel=build.autoregulatedModelWithUniformLight(0);
fullAutoModel=build.fullAutoModelWithUniformLight(0);
ode=SolverODE(fullAutoModel);
data=ode.run();
AcademicFigure;
uRange=0:1:1000;
[upAnalysisAS,downAnalysisAS]=performAnalysis(autoModel,6,1,uRange);%parameter on model to tweak is 6
[upAnalysisAF,downAnalysisAF]=performAnalysis(fullAutoModel,13,5,uRange);%parameter on model to tweak is 3
%[upAnalysisUS,downAnalysisUS,rangeUS]=performAnalysis(unregModel,3,1,'gx-','go-');%parameter on model to tweak is 6
%[upAnalysisUF,downAnalysisUF,rangeUF]=performAnalysis(fullModel,9,5,'rx-','ro-');%parameter on model to tweak is 3
%save data/file/ideaFullModelHisteresis
rangeProtein=[0:.01:60];
calibrationAF=interp1(upAnalysisAF,uRange,rangeProtein);
calibrationAS=interp1(upAnalysisAS,uRange,rangeProtein);
calibrationFS=[calibrationAS;calibrationAF]
calibrationFS(isnan(calibrationFS))=0;
builder=ModelFactoryTestModels;
calibModel=builder.calibratedFullAutoModel(calibrationFS)
[upAnalysis,downAnalysis]=performAnalysis(calibModel,13,5,0:1:600);%parameter on model to tweak is 6
figure
subplot(1,2,1)
hold on
plot(uRange,upAnalysisAS,'ko-',uRange,downAnalysisAS,'kx-','LineWidth',2);
plot(uRange,upAnalysisAF,'bo-',uRange,downAnalysisAF,'bx-','LineWidth',2);
xlim([0 600])
ylim([0 60])
subplot(1,2,2)
hold on
plot(uRange,upAnalysisAS,'k-',uRange,downAnalysisAS,'k-','LineWidth',2);
plot(0:1:600,upAnalysis,'b-',0:1:600,downAnalysis,'r--','LineWidth',2)
xlim([0 600])
ylim([0 60])
figure
plot(calibrationAS,calibrationAF,'LineWidth',2)
save data/file/makeAutoModelCalibration/workspace
save('data/file/makeAutoModelCalibration/calibration','calibrationFS')
calibModel.save('data/file/makeAutoModelCalibration/calibModel.m')

function [upAnalysis,downAnalysis]=performAnalysis(model,lightIndex,speciesIndex,uRange)
modelOde=SolverODE(model);
analyzer=HisteresisAnalysis(modelOde);
analyzer.time=linspace(0,2000,2000);
analyzer.speciesIndex=speciesIndex;
analyzer.uRange=uRange;
[upAnalysis,downAnalysis]=analyzer.analyze(lightIndex);
end