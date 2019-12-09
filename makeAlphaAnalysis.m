addpath classes
clear all
build=ModelFactory;
initialControlLevel=.3*ones([50 50]);
modelFsp=build.optimizedTwoCellModel;
modelFsp.model.time=linspace(0,500,500);
tempModel=modelFsp;
tempModel.model.controlInput=initialControlLevel;
modelFsp.model.initialState=tempModel.getSteadyState;
data=modelFsp.run();
probScorer=ProbabilityScore(modelFsp.dims);
pScore=probScorer.getFSPTrajectoryScore(data.state);
alpha=linspace(0,1,5)
for i=1:length(alpha)
optimizer=AlphaTimeControlOptimizer(modelFsp);
optimizer.alpha=alpha(i);
optimizer.initialControler=initialControlLevel;
[alphaProbability{i},control]=optimizer.optimize;
alphaScore{i}=probScorer.getFSPTrajectoryScore(alphaProbability{i});
end
%% badmodel
optimizer.alpha=1;
optimizer.aDegredation=0;
[localProbability,localControl]=optimizer.optimize;
localScore=probScorer.getFSPTrajectoryScore(localProbability);
%%

%%
figure
hold on
plot(modelFsp.model.time,pScore,'r-')
for i=1:length(alphaScore)
plot(modelFsp.model.time,alphaScore{i},'b-')
end
plot(modelFsp.model.time,localScore,'g-')
hold off
