load fullAutoregulatedModel3CellSwapAnalysis_16.mat
addpath(genpath('utility/'))
trajectoryIndex1=1
trajectoryIndex2=15
fig1=AcademicFigure()
hold on
ax12=subplot(4,3,[4 5])
plot(time{5},state{trajectoryIndex1}([5 10 15],:),'LineWidth',2)
ax22=subplot(4,3,[10 11])
plot(time{5},state{trajectoryIndex2}([5 10 15],:),'LineWidth',2)
ax4=subplot(1,3,3)
for k=1:5 
  figure
for i=1:16
 
  subplot(4,4,i)
  plot(time{i},state{i}(k+[0,5,10],:))
  sAx{i}=gca;
end
end
totalStateT=[];
totalStateR=[];
stateN=[];

R1=1000:2000+1000
R2=3000:4000+1000
R3=5000:6000+1000
for i=1:16
  stateT{i}=[state{i}(5,1:3000),state{i}(10,3001:5000),state{i}(15,5001:end)]
  totalStateT=[totalStateT,state{i}(5,R1),state{i}(10,R2),state{i}(15,R3)];
  totalStateR=[totalStateR,[state{i}(10,R1);state{i}(15,R1)],...
    [state{i}(5,R2);state{i}(15,R2)],...
    [state{i}(5,R3);state{i}(10,R3)]];
  stateN=[stateN,state{i}(10,R1),state{i}(15,R1),state{i}(5,R2),state{i}(15,R2),state{i}(5,R3),state{i}(10,R3)];
end

probability=zeros(70)
for i=1:length(totalStateT)
  for j=1:2
  probability(totalStateT(i)+1,totalStateR(j,i)+1)=probability(totalStateT(i)+1,totalStateR(j,i)+1)+1;
  end
end
probability=probability./sum(sum(probability));
load data/controlers/ReducedControlerAutoregulatedModelControler.mat
for i=1:length(stateT)
  swapControlInput{i}=fullModelCalibration(controlInput(stateT{i}+1));
end
set(0,'CurrentFigure',fig1)
ax11=subplot(4,3,[1 2])
x = [time{trajectoryIndex1};time{trajectoryIndex1}];
y = [swapControlInput{trajectoryIndex1};swapControlInput{trajectoryIndex1}];
areaPlot1=area(x([2:end end]),y(1:end));
areaPlot1.EdgeAlpha=0;
xlim([-500 3000]);
ax21=subplot(4,3,[7 8])
x = [time{trajectoryIndex2};time{trajectoryIndex2}];
y = [swapControlInput{trajectoryIndex2};swapControlInput{trajectoryIndex2}];
areaPlot2=area(x([2:end end]),y(1:end));
areaPlot2.EdgeAlpha=0;
xlim([-500 3000]);
maxT=max(totalStateT);
maxR=max(stateN);

scorer=ProbabilityScore([70 70]);
score=scorer.getScore(probability)

subplot(1,3,3)
hold on
h1=histogram(ax4,totalStateT,0:2:maxT,'normalization','probability')
h1.EdgeAlpha=0
hold on
h2=histogram(ax4,stateN,0:2:maxR,'normalization','probability')
h2.EdgeAlpha=0
box
title(num2str(score))

