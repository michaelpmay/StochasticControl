addpath classes/
addpath utility/
clear all
close all
load data/workspaces/workspaceMakeArrayFigOptimization.mat
build = ModelFactory;
N=16;
M=1;
maxNumCompThreads(16);
range=logspace(2,4,N);
parfor i =1:N
  scaleFactor = range(i);
  controlInput=controlerInput{2,1}*scaleFactor;
  controlInput(500,500)=0;
  model=build.khammashAutoregModel2WithControlInput(controlInput);
  ssa=SolverSSA(model);
  ssa.model.time=linspace(0,2000,4000);
  dataSSA{i}=ssa.run(M);
end
beepbeep

% for i =1:N
%   for j=1:M
%     hold on
%     figure
%     plot(dataSSA{i}.node{j}.time,[dataSSA{i}.node{j}.state(5,:)],'b-');
%     plot(dataSSA{i}.node{j}.time,[dataSSA{i}.node{j}.state(10,:)],'r--');
%   end
% end
% figure
% for i =1:N
%   for j=1:M
%     hold on
%     plot(dataSSA{i}.node{j}.time,[dataSSA{i}.node{j}.state(1:5,:)],'b-');
%     plot(dataSSA{i}.node{j}.time,[dataSSA{i}.node{j}.state(6:10,:)],'r--');
%   end
% end

for i =1:N
  for j=1:M
    tempX=[];
    tempY=[];
    tempX=[tempX,dataSSA{i}.node{j}.state(5,200:end)];
    tempY=[tempY,dataSSA{i}.node{j}.state(10,200:end)];
    maxState=max([tempX tempY])+1;
    figure
    hold on
    histogram(tempX,0:2:maxState-.5,'Normalization','probability')
    histogram(tempY,0:2:maxState-.5,'Normalization','probability')
  end
end

score=ProbabilityScore([100, 100])
for i =1:N
  for j=1:M
    Pxy{i,j}=zeros(100);
    tempX=[];
    tempY=[];
    tempX=[tempX,dataSSA{i}.node{j}.state(5,500:end)];
    tempY=[tempY,dataSSA{i}.node{j}.state(10,500:end)];
    for k=1:length(tempX)
      Pxy{i,j}(tempX(k)+1,tempY(k)+1)=Pxy{i,j}(tempX(k)+1,tempY(k)+1)+1;
    end
    pScore(i,j)=score.getScore(Pxy{i,j})
  end
end