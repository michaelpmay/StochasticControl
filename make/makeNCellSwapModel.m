addpath(genpath('utility/'));
N=8;
Z=3;
build=ModelFactory
%load inFiles/unregulatedReducedControler.mat
%unregControlInput=controlInput;
%unregControlInput(200)=0;
load data/controlers/ReducedControlerAutoregulatedModelControler.mat
controlInput=controlInput(:,1);
autoregControlInput=controlInput;
autoregControlInput(200)=0;
time=0:1000*N;
%unregModel=build.nCellUnregulatedSwapModel(N,unregControlInput,time);
autoregModel=build.nCellAutoregulatedSwapModel(N,autoregControlInput,time);
AcademicFigure
%makeSwapModelFigure(unregModel,[1,2]);
makeSwapModelFigure(autoregModel,[3,4],autoregControlInput);
function makeSwapModelFigure(model,subplotIndex,controlInput)
modelSSA=SolverSSA(model);
data=modelSSA.run;
parsedData=data.parse(1);
stateMax=max(max(data.node{1}.state));
bins=0:2:stateMax;
L=1:1000;
X=[]
for i=1:3
  X=[X,data.node{1}.state(i,L)];
  L=L+1000;
end
U=controlInput(X)
L=length(U)
subplot(2,3,[1 2])
plot(data.node{1}.time(1:L),U)
tightLayout
%%
build=ModelFactory;
model=build.autoregulatedModelWithoutInput;
load data/controlers/ReducedControlerAutoregulatedModelControler.mat
model.controlInput=controlInput
fsp=TwoCellFSP(model,[50 50])
probability=fsp.getSteadyStateReshape()
Px=sum(probability,1)
Py=sum(probability,2)
%%
% subplot(2,2,subplotIndex(2))
% hold on
nonTargetData= [parsedData.node{1}.state([2:end],800:1000),parsedData.node{1}.state([1,3:end],1800:2000),parsedData.node{1}.state([1:2,4:end],2800:3000),parsedData.node{1}.state([1:3,5:end],3800:4000),parsedData.node{1}.state([1:4,6:end],4800:5000)]
targetData= [parsedData.node{1}.state([1],800:1000),parsedData.node{1}.state(2,1800:2000),parsedData.node{1}.state(3,2800:3000),parsedData.node{1}.state(4,3800:4000)]
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
plot(data.node{1}.time,30*ones(size(data.node{1}.time)),'k-','LineWidth',1);
plot(data.node{1}.time,10*ones(size(data.node{1}.time)),'k-','LineWidth',1);

stairs(data.node{1}.time,data.node{1}.state(4:end,:)','color',[0 0 0]+.7);
stairs(data.node{1}.time,data.node{1}.state(1:3,:)','LineWidth',2);
plot([1000,1000],[0 80],'k-');
plot([2000,2000],[0 80],'k-');


axis([0 3000 0 60])
hold off
tightLayout
subplot(2,3,6)
hold on
makeHist(nonTargetData(:),0:60-.5,'blue')
plot((1:50),Px,'k-','color',[0 0 0]+.5)
makeHist(targetData(:),0:60-.5,'red')
plot((1:50),Py,'k-','color',[0 0 0]+.5)
axis([0 60 0 .2])
view(-90, 90)
tightLayout
end
function histogramFig=makeHist(data,bins,color)
histogramFig=histogram(data,bins,'Normalization','probability');
histogramFig.EdgeAlpha=0;
histogramFig.FaceAlpha=.7;
histogramFig.FaceColor=color;
end
