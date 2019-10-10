%clear all
addpath classes
build=ModelFactory;
modelFsp=build.optimizedTwoCellModel;
modelFsp.model.time=linspace(0,1000,500);
modelFsp.model.time=linspace(0,100,100);
initialModel=modelFsp;
initialModel.model.controlInput=.3*ones([50 50]);
modelFsp.model.initialState=initialModel.getSteadyState;
optimizer=AlphaTimeControlOptimizer(initialModel);
[probability,control]=optimizer.optimize;
%data=modelFsp.run();
probScorer=ProbabilityScore(modelFsp)
for i=1:length(data.time)
  badScore(i)=probScorer.getScore(data.state(:,i));
end
for i=1:length(modelFsp.model.time)
  goodScore(i)=probScorer.getScore(probability{i});
end
hold on
plot(linspace(0,100,50),badScore,'r-')
plot(initialModel.model.time,goodScore,'b-')
hold off
