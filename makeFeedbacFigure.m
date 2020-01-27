addpath classes
build=ModelFactory
model=build.autoregulatedModelWithoutInput;
load inFiles/autoregulatedReducedControler_110gmres.mat
model.controlInput=repmat(controlInput,[1 50]);
modelFsp=TwoCellFSP(model,[50 50]);
score=ProbabilityScore([50 50]);
p=modelFsp.getSteadyStateReshape
score.getScore(p)

load workspaceCorrectingTrajectories.mat
meanTrajectory=zeros(size(scoreTrajectory{1}));
time=(.1:.1:100);
subplot(1,3,1)
hold on
for i=1:length(scoreTrajectory)
  plot(time,scoreTrajectory{i})
  meanTrajectory=meanTrajectory+scoreTrajectory{i};
end
meanTrajectory=meanTrajectory./length(scoreTrajectory);
meanMeanTrajectory=mean(meanTrajectory);
noFeedbackScore=getReducedSSScore;
subplot(1,3,2)
hold on
plot(time,meanTrajectory)
plot(time,noFeedbackScore*ones(size(meanTrajectory)))
plot(time,meanMeanTrajectory*ones(size(meanTrajectory)))

function score=getReducedSSScore()
  load inFiles/autoregulatedReducedControler_110gmres.mat
  build=ModelFactory();
  model=build.autoregulatedModelWithoutInput;
  model.controlInput=repmat(controlInput,[1,50]);
  modelFsp=TwoCellFSP(model,[50 50]);
  p=modelFsp.getSteadyStateReshape;
  pScore=ProbabilityScore([50 50]);
  score=pScore.getScore(p);
end