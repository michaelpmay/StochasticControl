load data/file/ideaFullModelHisteresis

rangeProtein=0:.1:20;
calibrationF=spline(downAnalysisUF,rangeUF,rangeProtein);
calibrationS=spline(downAnalysisUS,rangeUS,rangeProtein);
calibrationF(calibrationS<0)=[]
calibrationS(calibrationS<0)=[]
figure


figure
hold on
[upAnalysisAS,downAnalysisAS,rangeAS]=performAnalysis(unregModel,3,1,calibrationS,'bx-','bo-');%parameter on model to tweak is 6
[upAnalysisAF,downAnalysisAF,rangeAF]=performAnalysis(fullModel,9,5,calibrationF,'kx-','ko-');%parameter on model to tweak is 3

AcademicFigure
subplot(1,3,1)
plot(calibrationF,calibrationS,'m-','Linewidth',2)
title({'Full Model To','Simple Model Calibration'})
xlabel('Input')
ylabel('Output')
subplot(1,3,2)
plot(calibrationS,calibrationF,'m-','Linewidth',2)
title({'Simple Model To','Full Model Calibration'})
xlabel('Input')
ylabel('Output')
subplot(1,3,3)
hold on
input=[0:.1:5]
for i=1:length(input)
  value=spline(rangeUF,downAnalysisUF,input(i));
  plot([value,value],[0 50],'r-')
end
input=[0:.1:5]
for i=1:length(input)
  value=spline(rangeUS,downAnalysisUS,input(i));
  plot([0 50],[value,value],'b-')
end
plot(upAnalysisAS,upAnalysisAF,'k-','LineWidth',2)
axis([0 20 0 20])
grid on
%%
clear all
load data/file/ideaFullModelHisteresis

rangeProtein=[0:.01:80];
calibrationAF=interp1(upAnalysisAF,rangeAF,rangeProtein);
calibrationAS=interp1(upAnalysisAS,rangeAS,rangeProtein);

figure
plot(calibrationAS,calibrationAF)
calibrationFS=[calibrationAS;calibrationAF]
calibrationFS(isnan(calibrationFS))=0
builder=ModelFactoryTestModels;
calibModel=builder.calibratedFullAutoModel(calibrationFS)
[upAnalysis,downAnalysis,range]=performAnalysis(calibModel,9,5,rangeAF(1:10:end),'bx-','bo-');%parameter on model to tweak is 6

plot(upAnalysis,range,downanalysis,range)

function [upAnalysis,downAnalysis,range]=performAnalysis(model,lightIndex,speciesIndex,uRange,spec1,spec2)
modelOde=SolverODE(model);
analyzer=HisteresisAnalysis(modelOde);
analyzer.time=linspace(0,2000,70);
analyzer.speciesIndex=speciesIndex;
analyzer.uRange=uRange;
[upAnalysis,downAnalysis]=analyzer.analyze(lightIndex);
plot(analyzer.uRange,upAnalysis,spec1,analyzer.uRange,downAnalysis,spec2);
range=analyzer.uRange;
end