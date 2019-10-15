%makeHisteresisFigure
addpath classes\
build=ModelFactory;
autoModel=build.autoregulatedModelWithUniformInput(0);
unregModel=build.unregulatedModelWithUniformLight(0);
performAnalysis(autoModel,lightIndex);
performAnalysis(unregModel,lightIndex);
function performAnalysis(model,lightIndex)
modelOde=SolverODE(model);
analyzer=HisteresisAnalysis(modelOde);
[upAnalysis,downAnalysis]=analyzer.analyze(lightIndex);
AcademicFigure;
hold on
plot(analyzer.uRange,upAnalysis,'rx-',analyzer.uRange,downAnalysis,'bo-');
end