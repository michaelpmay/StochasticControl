clear all
%close all 
addpath(genpath('utility/'))
load fullAutoregulatedModel3CellSwapAnalysis_16.mat
load data/file/makeFullAutoregulatedModel3CellSwap/workspace_16.mat
fig1=AcademicFigure()
hold on
ax1=subplot(3,3,[1 2])
plot(time{5},state{1}([5 10 15],:),'LineWidth',2)
ax2=subplot(3,3,[4 5])
plot(time{5},state{15}([5 10 15],:),'LineWidth',2)
ax3=subplot(3,3,[7 8])
plot(time{5},state{2}([5 10 15],:),'LineWidth',2)
ax4=subplot(1,3,3)
for k=1:5 
  figure
for i=1:16
  subplot(4,4,i)
  plot(time{i},state{i}(k+[0,5,10],:))
  sAx{i}=gca;
end
end
for i=1:16
  time{i}=time{i}(1001:end)
  state{i}=state{i}(:,1001:end)
end
stateT=[];
stateR=[];
stateR2={};
R1=1500:2000;
R2=3500:4000;
R3=5500:6000;
for i=1:16
  stateT=[stateT,state{i}(5,R1),state{i}(10,R2),state{i}(15,R3)];
  stateR=[stateR,state{i}(10,R1),state{i}(15,R1),state{i}(5,R2),state{i}(15,R2),state{i}(5,R3),state{i}(10,R3)];
  stateR2{i}=[[state{i}(10,R1);state{i}(15,R1)],[state{i}(5,R2);state{i}(15,R2)],[state{i}(5,R3);state{i}(10,R3)]];
end

probability=zeros(60);
for i=1:length(stateT)
  probability(stateT(i)+1,stateR(:,i)+1)=probability(stateT(i)+1,stateR(:,i)+1)+1;
end
probability=probability./sum(sum(probability));

scorer=ProbabilityScore([60,60]);
score=scorer.getScore(probability);

meanState=zeros(size(state{1}));
for i=1:length(state)
  meanState=meanState+state{i};
end
meanState=meanState/length(state);

maxT=max(stateT);
maxR=max(stateR);
set(0,'CurrentFigure',fig1)
hold on
h1=histogram(ax4,stateT,0:2:maxT,'normalization','probability')
h1.EdgeAlpha=0
h2=histogram(ax4,stateR,0:2:maxR,'normalization','probability')
h2.EdgeAlpha=0
box


figure 
plot(time{1},[meanState(5,:);meanState(10,:);meanState(15,:)])
figure
hold on
pcolorProbability(probability)
plot(10,30,'ro')
