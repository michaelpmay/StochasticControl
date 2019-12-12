addpath classes
clear all
build=ModelFactory;
initialControlLevel=.3*ones([50 50]);
time=linspace(0,500,500);
modelFsp=build.optimizedTwoCellModel;
modelFsp.model.time=time;
tempModel=modelFsp;
tempModel.model.controlInput=initialControlLevel;
modelFsp.model.initialState=tempModel.getSteadyState;
%data=modelFsp.run();
probScorer=ProbabilityScore(modelFsp.dims);
%pScore=probScorer.getFSPTrajectoryScore(data.state);
alpha=linspace(0,1,21);
parfor i=1:length(alpha)
optimizer=AlphaTimeControlOptimizer(modelFsp);
optimizer.alpha=alpha(i);
optimizer.initialControler=initialControlLevel;
[alphaProbability{i},control{i}]=optimizer.optimize;
alphaScore{i}=probScorer.getFSPTrajectoryScore(alphaProbability{i});
end
clearvars -except alphaScore time
save('workspaceAlphaAnalysis.mat');
