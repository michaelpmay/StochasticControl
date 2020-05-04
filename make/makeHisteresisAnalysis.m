%makeHisteresisFigure
addpath classes
build=ModelFactory;
autoModel=build.autoregulatedModelWithUniformInput(0);
unregModel=build.unregulatedModelWithUniformLight(0);
AcademicFigure;
hold on
performAnalysis(autoModel,6,'rx-','bo-');%parameter on model to tweak is 6
performAnalysis(unregModel,3,'kx-','ko-');%parameter on model to tweak is 3

function performAnalysis(model,lightIndex,spec1,spec2)
modelOde=SolverODE(model);
analyzer=HisteresisAnalysis(modelOde);
[upAnalysis,downAnalysis]=analyzer.analyze(lightIndex);
plot(analyzer.uRange,upAnalysis,spec1,analyzer.uRange,downAnalysis,spec2);
end