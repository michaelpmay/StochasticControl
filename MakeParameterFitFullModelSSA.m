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
range=linspace(bestRange-100,bestRange+100,N);

%parameters=load('data/parameters/UnrestricedFullModelParameters.mat');
parfor i =1:N
  scaleFactor = range(i);
  controlerInput=controlInput*scaleFactor;
  controlerInput(1000,1000)=0;
  model=build.khammashFullAutoModelWithControlInput(controlerInput,1);
  ssa=SolverSSA(model);
  ssa.model.time=linspace(0,10000,20000);
  dataSSA{i}=ssa.run(M);
  state{i}=dataSSA{i}.node{1}.state;
  time{i}=dataSSA{i}.node{1}.time;
end 
%save data/workspaces/workspaceKhammashAutoregulationSSAsUnrestricted 
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
[minScore,minInd]=min(score);
lRange=range(minInd-2);
uRange=range(minInd+2);
range=logspace(log10(lRange),log10(uRange),N)


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
    subplot(4,4,ind)
    hold on
    histogram(tempX,0:2:maxState,'Normalization','probability')
    histogram(tempY,0:2:maxState,'Normalization','probability')
    title(["Score: ",num2str(score(i))])
    ind=ind+1;
  end
end

figure 
plot(range,score);