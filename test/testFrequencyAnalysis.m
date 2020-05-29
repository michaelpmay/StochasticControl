addpath classes
uModel=UnregulatedPlugin();
aModel=AutoregulatedPlugin();
AcademicFigure
axes=subplot(1,3,1)
numPoints=1000000;
plotFreqAnalysisUsingModel(uModel,1,.4,numPoints,axes);
axes=subplot(1,3,2)
plotFreqAnalysisUsingModel(aModel,1,.4,numPoints,axes);
axes=subplot(1,3,3)
plotFreqAnalysisUsingModel(aModel,.001,.4,numPoints,axes);
function plotFreqAnalysisUsingModel(model,frequency,intensity,numPoints,axes)
model.time=linspace(0,400,numPoints);
model.initialState=[0];
model.input=@(x,t)0;
fAnalysis=FrequencyAnalysis(model)
fAnalysis.frequency=frequency;
fAnalysis.intensity=intensity;
data=fAnalysis.run;
data=data.trimInitial(floor(numPoints*9/10*frequency));
view=ViewODE(data,axes);
view.plotTimeSeries(1)
end