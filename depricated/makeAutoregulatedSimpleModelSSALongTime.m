
addpath(genpath('utility'))
build=ModelFactoryTestModels;
load data/controlers/ReducedControlerAutoregulatedModelControler.mat
controlInput=controlInput(1:end,:)
controlInput(1000)=0;
model=build.nCellAutoregulatedModel(2,@(t,x)controlInput(x(1)+1))
ssa=SolverSSA(model);
ssa.model.time=linspace(0,10000,10000*2+1);
bucket=ParallelMenu
for i=1:16
  bucket=bucket.add(@ssa.run,{})
end
data=bucket.run
for i=1:16
  time{i}=data{i}.node{1}.time
  state{i}=data{i}.node{1}.state
end
save makeAutoregulatedSimpleModelSSALongTime_ReducedaControler.mat




%%%%%%%
scorer=ProbabilityScore([50 50])
C=scorer.makeCMatrix([100 100])
load makeAutoregulatedSimpleModelSSALongTime.mat
scoreT1=[]
xV=2000:length(state{1});
probability1=zeros(100);
integralScore=0;
dt=.5
for i=1:16
  integralScore1{i}=0;
  for j=1:(xV)
  score1{i}(j)=C(state{i}(1,xV(j))+1,state{i}(2,xV(j))+1);
  integralScore1{i}=integralScore1{i}+score1{i}(j)*dt;
  probability1(state{i}(1,xV(j))+1,state{i}(2,xV(j))+1)=probability1(state{i}(1,xV(j))+1,state{i}(2,xV(j))+1)+1;
  end
  scoreT1=[scoreT1,score1{i}];
end
probability1=probability1./sum(sum(probability1));

load makeFullAutoModelCalibratedLongTime.mat
scoreT2=[]
xV=2000:length(state{1});
probability2=zeros(100)
for i=1:16
  integralScore2{i}=0;
  for j=1:(xV)
  score2{i}(j)=C(state{i}(5,xV(j))+1,state{i}(10,xV(j))+1);
  integralScore2{i}=integralScore2{i}+score1{i}(j)*dt;
  probability2(state{i}(5,xV(j))+1,state{i}(10,xV(j))+1)=probability2(state{i}(5,xV(j))+1,state{i}(10,xV(j))+1)+1;
  end
  
  scoreT2=[scoreT2,score2{i}];
end
probability2=probability2./sum(sum(probability2));
figure()
histogram(scoreT2,'normalization','probability')
hold on
histogram(scoreT1,'normalization','probability')
figure
subplot(1,2,1)
pcolorProbability(probability1)
subplot(1,2,2)
pcolorProbability(probability2)