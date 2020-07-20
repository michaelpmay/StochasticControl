clear all
load data/file/ideaFullModelHisteresis

rangeProtein=[0:.01:39.5];
calibrationAF=interp1(upAnalysisAF,rangeAF,rangeProtein);
calibrationAS=interp1(upAnalysisAS,rangeAS,rangeProtein);

figure
plot(calibrationAS,calibrationAF)
calibrationFS=[calibrationAS;calibrationAF]
calibrationFS(isnan(calibrationFS))=0
builder=ModelFactoryTestModels;
calibModel=builder.calibratedFullAutoModel(calibrationFS)
[upAnalysis,downAnalysis,range]=performAnalysis(calibModel,13,5,0:.01:.38,'bx-','bo-');%parameter on model to tweak is 6
figure
plot(range,upAnalysis,range,downAnalysis,'r-')
save data/file/makeAutoModelCalibration/workspace
save('data/file/makeAutoModelCalibration/calibration','calibrationFS')
calibModel.save('data/file/makeAutoModelCalibration/calibModel.m')
function [upAnalysis,downAnalysis,range]=performAnalysis(model,lightIndex,speciesIndex,uRange,spec1,spec2)
modelOde=SolverODE(model);
analyzer=HisteresisAnalysis(modelOde);
analyzer.time=linspace(0,1500,1500);
analyzer.speciesIndex=speciesIndex;
analyzer.uRange=uRange;
[upAnalysis,downAnalysis]=analyzer.analyze(lightIndex);
%plot(analyzer.uRange,upAnalysis,spec1,analyzer.uRange,downAnalysis,spec2);
range=analyzer.uRange;
end