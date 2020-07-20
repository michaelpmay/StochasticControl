%makeHisteresisFigure
addpath(genpath('utility'))
build=ModelFactoryTestModels;
autoModel=build.autoregulatedModelWithUniformLight(0);
fullAutoModel=build.fullAutoModelWithUniformLight(0);
ode=SolverODE(fullAutoModel)
data=ode.run()
AcademicFigure;
hold on
[upAnalysisAS,downAnalysisAS,rangeAS]=performAnalysis(autoModel,6,1,0:.01:2,'bx-','bo-');%parameter on model to tweak is 6
[upAnalysisAF,downAnalysisAF,rangeAF]=performAnalysis(fullAutoModel,13,5,0:1:1000,'kx-','ko-');%parameter on model to tweak is 3
%[upAnalysisUS,downAnalysisUS,rangeUS]=performAnalysis(unregModel,3,1,'gx-','go-');%parameter on model to tweak is 6
%[upAnalysisUF,downAnalysisUF,rangeUF]=performAnalysis(fullModel,9,5,'rx-','ro-');%parameter on model to tweak is 3
save data/file/ideaFullModelHisteresis
function [upAnalysis,downAnalysis,range]=performAnalysis(model,lightIndex,speciesIndex,uRange,spec1,spec2)
modelOde=SolverODE(model);
analyzer=HisteresisAnalysis(modelOde);
analyzer.time=linspace(0,1500,1500);
analyzer.speciesIndex=speciesIndex;
analyzer.uRange=uRange;
[upAnalysis,downAnalysis]=analyzer.analyze(lightIndex);
plot(analyzer.uRange,upAnalysis,spec1,analyzer.uRange,downAnalysis,spec2);
range=analyzer.uRange;
end