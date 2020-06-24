addpath(genpath('utility/'));
savepath
clear all
close all
load data/controlers/FullControlerAutoregulatedModelControler.mat
build = ModelFactory;
numThreads=16;%dont change
repeats=2;
N=numThreads*repeats;
M=1;
maxNumCompThreads(16);
range=logspace(-1,9,N);
parameters=load('data/parameters/UnrestricedFullModelParameters.mat');
for i =1:N
  scaleFactor = range(i);
  controlerInput=controlInput*scaleFactor;
  controlerInput(500,500)=0;
  model=build.khammashAutoregModel2WithControlInput(controlerInput);
  ssa=SolverSSA(model);
  ssa.model.time=linspace(0,20000,40000);
  dataSSA{i}=ssa.run(M);
  state{i}=dataSSA{i}.node{1}.state;
  time{i}=dataSSA{i}.node{1}.time;
end
save data/workspaces/workspaceKhammashAutoregulationSSAsUnrestricted 
for i=1:length(time)
  dataSSA{i}.node{1}.time=time{i};
  dataSSA{i}.node{1}.state=state{i};
end

scorer=ProbabilityScore([50 50]);
ind=1;
for i=1:N
  probability{i}=zeros(50);
  position=[dataSSA{i}.node{1}.state(5,200:end);dataSSA{i}.node{1}.state(10,200:end)];
  for j=1:length(position)
  probability{i}(position(:,j)+1)=probability{i}(position(:,j)+1)+1;
  end
  probability{i}=probability{i}./sum(sum(probability{i}));
  score(i)=scorer.getScore(probability{i});
end


for k=1:5
figure
ind=1;
for i =1:N
  for j=1
    subplot(4,N/4,ind);
    hold on
    plot(dataSSA{ind}.node{1}.time,[dataSSA{ind}.node{1}.state(k,:)],'b-');
    plot(dataSSA{ind}.node{1}.time,[dataSSA{ind}.node{1}.state(k+5,:)],'r--');
    title(["Scale Factor: ", num2str(range(ind))])
    ind=ind+1;
  end
end
end


figure
ind=1;    
tempX=[];
tempY=[];
for i =1:N
  for j=1:M
    tempX=[tempX,dataSSA{ind}.node{1}.state(5,200:end)];
    tempY=[tempY,dataSSA{ind}.node{1}.state(10,200:end)];
    maxState=max([tempX tempY])+1;
    subplot(4*2,4,ind)
    hold on
    histogram(tempX,0:2:maxState,'Normalization','probability')
    histogram(tempY,0:2:maxState,'Normalization','probability')
    title(["Score: ",num2str(score(i))])
    ind=ind+1;
  end
end

figure 
plot(range,score);