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
data=modelFsp.run();
probScorer=ProbabilityScore(modelFsp.dims);
pScore=probScorer.getFSPTrajectoryScore(data.state);
alpha=linspace(0,1,21);
parfor i=1:length(alpha)
optimizer=AlphaTimeControlOptimizer(modelFsp);
optimizer.alpha=alpha(i);
optimizer.initialControler=initialControlLevel;
[alphaProbability{i},control{i}]=optimizer.optimize;
alphaScore{i}=probScorer.getFSPTrajectoryScore(alphaProbability{i});
end
for i=1:500
  subplot(1,2,1)
  pcolorProbability(reshape(alphaProbability{1}(:,i),[50 50]))
  subplot(1,2,2)
  temp=control{1}{i};
  pcolorProbability(temp)
  pause(5)
end
%end
%clearvars -except alphaScore time
%save('workspaceAlphaAnalysis.mat');
