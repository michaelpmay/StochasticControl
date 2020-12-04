addpath(genpath('utility/'));
clear all
quartiles=[.75 .8 .85 .9];
for k=1:5
parfor i=1:length(quartiles)
  data{i}=getData(quartiles(i));
  makeplot(data{i})
end
for ii=1:length(data)
  score(ii)=data.score(ii)
end
[minVal,minInd]=min(score);
if minInd==1
  quartiles=linspace(quartiles(1),quartiles(2),4);
elseif minInd==2
  quartiles=linspace(quartiles(1),quartiles(3),4);
elseif minInd==3
  quartiles=linspace(quartiles(2),quartiles(3),4);
elseif minInd==4
  quartiles=linspace(quartiles(3),quartiles(4),4);
end
end
function data=getData(quart)
build=ModelFactory;
load data/controlers/FullControlerAutoregulatedModelControler.mat
controlInput(200,200)=0;
time=0:.5:60000;
dT=time(2)-time(1);
model=build.autoregulatedModelWithUniformLight(0);
model.time=[0 dT];
ssaX=SolverSSA(model);
ssaY=SolverSSA(model);
fsp=SolverFSP(model,[50]);
currentX=30;
currentY=10;
currentYPrediction=zeros(50,1);
currentYPrediction(currentY+1)=1;
fsp.model.initialState=currentYPrediction;
historyYPrediction=zeros(length(currentYPrediction),length(time));
historyX=zeros(1,length(time));
historyY=zeros(1,length(time));
for i =1:length(time)
  prediction=quartile(currentYPrediction,quart);
  state=[currentX,prediction];
  input=controlInput(state(1)+1,state(2)+1);
  ssaX.model.parameters(6)=input;
  ssaY.model.parameters(6)=input;
  fsp.model.parameters(6)=input;
  ssaXdata=ssaX.run();
  ssaYdata=ssaY.run();
  fspdata=fsp.run();
  currentX=ssaXdata.node{1}.state(end);
  currentY=ssaYdata.node{1}.state(end);
  currentYPrediction=fspdata.state(:,end);
  ssaX.model.initialState=currentX;
  ssaY.model.initialState=currentY;
  fsp.model.initialState=currentYPrediction;
  historyX(i)=currentX;
  historyY(i)=currentY;
  historyYPrediction(i)=prediction;
  %fprintf("\ntime: %4.2f\ninput: %4.2f\nprediction: %4.2f\n",time(i),input,prediction);
end
Pxy=zeros(60,60);
for i=1:length(historyX)
  Pxy(historyX(i)+1,historyY(i)+1)=Pxy(historyX(i)+1,historyY(i)+1)+1;
end
Pxy=Pxy./sum(sum(Pxy));
score=ProbabilityScore([60 60]);
data.Pxy=Pxy;
data.time=time;
data.X=historyX;
data.Y=historyY;
data.predictionY=historyYPrediction;
data.score=score.getScore(Pxy);
end
function makeplot(data)
AcademicFigure
subplot(1,3,1)
hold on
plot(data.time,data.X)
plot(data.time,data.Y)
plot(data.time,data.predictionY)
subplot(1,3,2)
pcolorProbability(data.Pxy)
xlabel('Species Count Non-Target')
ylabel('Species Count Target')
LabelPlot(num2str(data.score))
subplot(1,3,3)
hold on
histogram(data.Y,'normalization','Probability')
histogram(data.X,'normalization','Probability')
xlabel('Species Count')
ylabel('Probability')
end
function prediction=quartile(probability,ratio)
cprobability=cumsum(probability);
index=find(cprobability>ratio,1);
probability=probability*0;
probability(index)=1;
x=[1:length(probability)]-1;
prediction=x*probability;
prediction=round(prediction);
end
