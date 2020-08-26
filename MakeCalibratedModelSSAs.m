addpath(genpath('utility/'));
savepath
clear all
close all
load data/controlers/FullControlerAutoregulatedModelControler.mat
parameters=[1.0000e+00   5.0000e-02   1.0000e+00   4.2060e+00   1.4391e-03   3.1537e-01 2.5842e+01   4.7834e-03]
parameters(2)=parameters(1)/20;
parameters(7)=parameters(6)/5;
build = ModelFactoryTestModels;
numThreads=16;%dont change
repeats=1;
N=numThreads*repeats;
M=1;
maxNumCompThreads(16);
bestRange=1.3928e5;
range=logspace(0,0,N);

%parameters=load('data/parameters/UnrestricedFullModelParameters.mat');
parfor i =1:N
  scaleFactor = range(i);
  controlerInput=controlInput*scaleFactor;
  controlerInput(1000,1000)=0;
  model=build.calibratedFullAutoModelWith2dControl(controlerInput);
  ssa=SolverSSA(model);
  ssa.model.time=linspace(0,1000,2000);
  dataSSA{i}=ssa.run(M);
  state{i}=dataSSA{i}.node{1}.state;
  time{i}=dataSSA{i}.node{1}.time;
end 
save data/file/MakeCalibratedSSAs/workspace
for i=1:length(time)
  dataSSA{i}.node{1}.time=time{i};
  dataSSA{i}.node{1}.state=state{i};
end

scorer=ProbabilityScore([100 100]);
ind=1;
for i=1:N
  probability{i}=zeros(100);
  position=[dataSSA{i}.node{1}.state(5,1000:end);dataSSA{i}.node{1}.state(10,1000:end)];
  for j=1:length(position)
  probability{i}(position(1,j)+1,position(2,j)+1)=probability{i}(position(1,j)+1,position(2,j)+1)+1;
  end
  probability{i}=probability{i}./sum(sum(probability{i}));
  score(i)=scorer.getScore(probability{i});
end

score 


totalProbability=zeros(size(probability{1}));
for i=1:length(probability)
  totalProbability=totalProbability+probability{i}
end
totalProbability=totalProbability/sum(sum(totalProbability));
totalScore=scorer.getScore(totalProbability)

for k=1:5
figure
ind=1;
for i =1:N
  for j=1
    subplot(4,N/4,ind);
    hold on
    plot(dataSSA{ind}.node{1}.time(1000:end),[dataSSA{ind}.node{1}.state(k,1000:end)],'b-');
    plot(dataSSA{ind}.node{1}.time(1000:end),[dataSSA{ind}.node{1}.state(k+5,1000:end)],'r--');
    title(["Scale Factor: ", num2str(range(ind))])
    ind=ind+1;
  end
end
end



ind=1;      
tempX=[];
tempY=[];  
for i =1:N
  for j=1:M
    tempX=[tempX,dataSSA{ind}.node{1}.state(5,1300:end)];
    tempY=[tempY,dataSSA{ind}.node{1}.state(10,1300:end)]; 
    ind=ind+1
  end
end
maxState=max([tempX tempY])+1;
concatData=SSAData()
concatData=concatData.appendNode(ModelData(tempX,tempY))
fullScore=scorer.getSSATrajectoryScore(concatData)
figure
hold on
histogram(tempX,0:2:maxState,'Normalization','probability')
histogram(tempY,0:2:maxState,'Normalization','probability')
title(["Score: ",num2str(score(i))])

figure 
plot(range,score);