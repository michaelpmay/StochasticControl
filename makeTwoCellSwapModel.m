addpath(genpath('utility/'));
clear all
N=8;
Z=3;
build=ModelFactory
%load inFiles/unregulatedReducedControler.mat
%unregControlInput=controlInput;
%unregControlInput(200)=0;
load data/controlers/FullControlerAutoregulatedModelControler.mat
controlInput(200,200)=0;
time=0:1000*N;
%unregModel=build.nCellUnregulatedSwapModel(N,unregControlInput,time);
autoregModel=build.twoCellAutoregulatedSwapModel(N,controlInput,time);
AcademicFigure
%makeSwapModelFigure(unregModel,[1,2]);
makeSwapModelFigure(autoregModel,controlInput);
function makeSwapModelFigure(model,controlInput)
modelSSA=SolverSSA(model);
data=modelSSA.run;
parsedData=data.parse(1);
stateMax=max(max(data.node{1}.state));
color1=[100, 149, 237]./255;
color2=[237,120,100]./255;
color3=[218,237,100]./255;
bins=0:2:stateMax;
L=1:1000;
X=[]
for i=1:8
  if mod(i,2)==1
    X=[X,[data.node{1}.state(1,L);data.node{1}.state(2,L)]]
  else 
    X=[X,[data.node{1}.state(2,L);data.node{1}.state(1,L)]];
  end
  L=L+1000;
end
for i=1:length(X)
  U(i)=controlInput(X(1,i),X(2,i));
end
L=length(U);
subplot(2,3,[1 2]);
axis1=area(data.node{1}.time(1:3000),U(1:3000))
axis1.EdgeAlpha=0;
xlabel('time(seconds)')
ylabel('Control Input')
tightLayout
%%
build=ModelFactory;
model=build.autoregulatedModelWithoutInput;
model.controlInput=controlInput(1:50,1:50);
fsp=TwoCellFSP(model,[50 50]);
probability=fsp.getSteadyStateReshape();
Px=sum(probability,1);
Py=sum(probability,2);
%%
% subplot(2,2,subplotIndex(2))
% hold on
targetData=    [parsedData.node{1}.state(1,500:1000),parsedData.node{1}.state(2,1500:2000),parsedData.node{1}.state(1,2500:3000),parsedData.node{1}.state(2,3500:4000)];
nonTargetData= [parsedData.node{1}.state(2,500:1000),parsedData.node{1}.state(1,1500:2000),parsedData.node{1}.state(2,2500:3000),parsedData.node{1}.state(1,3500:4000)];
 % H11=makeHist(parsedData.node{1}.state(1,1:100),bins,'red')
% H12=makeHist(nonTargetData(:),bins,'blue')
% %subplot(1,2,2)
% hold on
% nonTargetData=parsedData.node{1}.state([1,3],101:000);
% H21=makeHist(parsedData.node{1}.state(2,101:200),bins,'red')
% H22=makeHist(nonTargetData(:),bins,'blue')
% %subplot(1,2,2)
% hold on
% nonTargetData=parsedData.node{1}.state([1,2],201:300);
% H31=makeHist(parsedData.node{1}.state(3,201:300),bins,'red')
% H32=makeHist(nonTargetData(:),bins,'blue')
subplot(2,3,[4,5])
hold on
box on
p1=patch([0 1000 1000 0], [60 60 0 0],color1)
p2=patch([1000 2000 2000 1000], [60 60 0 0],color2)
p3=patch([2000 3000 3000 2000], [60 60 0 0],color1)
alpha(.3)
plot(data.node{1}.time,30*ones(size(data.node{1}.time)),'k-','LineWidth',1);
plot(data.node{1}.time,10*ones(size(data.node{1}.time)),'k-','LineWidth',1);

stairs(data.node{1}.time,data.node{1}.state(1,:)','LineWidth',2,'color',[0 0.4470 0.7410]);
stairs(data.node{1}.time,data.node{1}.state(2,:)','LineWidth',2,'color',[0.8500 0.3250 0.0980]);
plot([1000,1000],[0 80],'k-');
plot([2000,2000],[0 80],'k-');


axis([0 3000 0 60])
hold off
tightLayout
xlabel('time(seconds)')
ylabel('Species Count')
subplot(2,3,6)
hold on
box on
makeHist(nonTargetData(:),0:60-.5,'blue')
plot((1:50),Px,'k-','color',[0 0 0]+.5)
makeHist(targetData(:),0:60-.5,'red')
plot((1:50),Py,'k-','color',[0 0 0]+.5)
axis([0 60 0 .25])
view(-90, 90)
tightLayout
end
function histogramFig=makeHist(data,bins,color)
histogramFig=histogram(data,bins,'Normalization','probability');
histogramFig.EdgeAlpha=0;
histogramFig.FaceAlpha=.7;
histogramFig.FaceColor=color;
end
