addpath classes/
addpath utility/
clear all
close all
load data/controlers/FullControlerAutoregulatedModelControler.mat
build = ModelFactory;
N=16;
M=1;
maxNumCompThreads(16);
range=linspace(400,600,N);
parfor i =1:N
  scaleFactor = range(i);
  controlerInput=controlInput*scaleFactor;
  controlerInput(500,500)=0;
  model=build.khammashAutoregModel2WithControlInput(controlerInput);
  ssa=SolverSSA(model);
  ssa.model.time=linspace(0,5000,10000);
  dataSSA{i}=ssa.run(M);
  state{i}=dataSSA{i}.node{1}.state;
  time{i}=dataSSA{i}.node{1}.time;
end
save data/workspaces/workspaceKhammashAutoregulationSSAs_400to600


% for i=1:length(time)
%   dataSSA{i}.node{1}.time=time{i};
%   dataSSA{i}.node{1}.state=state{i};
% end
% for k=1:5
% figure
% ind=1;
% for i =1:4
%   for j=1:4
%     subplot(4,4,ind);
%     hold on
%     plot(dataSSA{ind}.node{1}.time,[dataSSA{ind}.node{1}.state(k,:)],'b-');
%     plot(dataSSA{ind}.node{1}.time,[dataSSA{ind}.node{1}.state(k+5,:)],'r--');
%     ind=ind+1;
%   end
% end
% end
% 
% figure
% ind=1;    
% tempX=[];
% tempY=[];
% for i =1:N
%   for j=1:M
% 
%     tempX=[tempX,dataSSA{ind}.node{1}.state(5,200:end)];
%     tempY=[tempY,dataSSA{ind}.node{1}.state(10,200:end)];
%     maxState=max([tempX tempY])+1;
%     subplot(4,4,ind)
%     
%     ind=ind+1;
%   end
% end
% hold on
% histogram(tempX,0:2:maxState,'Normalization','probability')
%     histogram(tempY,0:2:maxState,'Normalization','probability')
%     
% score=ProbabilityScore([100, 100])
% for i =1:N
%   for j=1:M
%     Pxy{i,j}=zeros(100);
%     tempX=[];
%     tempY=[];
%     tempX=[tempX,dataSSA{i}.node{j}.state(5,500:end)];
%     tempY=[tempY,dataSSA{i}.node{j}.state(10,500:end)];
%     for k=1:length(tempX)
%       Pxy{i,j}(tempX(k)+1,tempY(k)+1)=Pxy{i,j}(tempX(k)+1,tempY(k)+1)+1;
%     end
%     pScore(i,j)=score.getScore(Pxy{i,j})
%   end
% end
