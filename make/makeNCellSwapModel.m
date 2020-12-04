addpath(genpath('utility/'));

N=8;
Z=3;
build=ModelFactory;
%load inFiles/unregulatedReducedControler.mat
%unregControlInput=controlInput;
%unregControlInput(200)=0;
numSwaps=128;
numCells=4;
load data/controlers/ReducedControlerAutoregulatedModelControler.mat
controlInput=controlInput(:,1);
autoregControlInput=controlInput;
autoregControlInput(200)=0;
time=0:1000*numSwaps;

%unregModel=build.nCellUnregulatedSwapModel(N,unregControlInput,time);
autoregModel=build.nCellAutoregulatedSwapModel(numCells,numSwaps,autoregControlInput,time);
AcademicFigure
%makeSwapModelFigure(unregModel,[1,2]);
makeSwapModelFigure(autoregModel,[3,4],autoregControlInput,numCells,numSwaps);
function makeSwapModelFigure(model,subplotIndex,controlInput,numCells,numSwaps)
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
U=controlInput(X+1);
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
initialWindow=1:100
finalWindow=900:1000
initialNonTargetData=[]
finalNonTargetData=[]
initialTargetData=[]
finalTargetData=[]
for i =1:numSwaps
  initialFrame=initialWindow+1000*(i-1);
  finalFrame=finalWindow+1000*(i-1);
  targetCellIndex=mod(i-1,numCells)+1;
  nonTargetCellsIndex=1:numCells;
  nonTargetCellsIndex(nonTargetCellsIndex==targetCellIndex)=[];
initialNonTargetData=[initialNonTargetData,parsedData.node{1}.state(nonTargetCellsIndex,initialFrame)];
finalNonTargetData= [finalNonTargetData,parsedData.node{1}.state(nonTargetCellsIndex,finalFrame)];
initialTargetData= [initialTargetData,parsedData.node{1}.state(targetCellIndex,initialFrame)];
finalTargetData  = [finalTargetData,parsedData.node{1}.state(targetCellIndex,finalFrame)];
end
subplot(2,3,[1 2])
axis1=area(data.node{1}.time(1:length(U)),U,'FaceColor','m');
axis1.EdgeAlpha=0;
tightLayout
xlabel('time(minutes)')
ylabel('Control Input')
(set(gca, 'YGrid', 'off', 'XGrid', 'on'));
LabelPlot('A')
subplot(2,3,[4,5])
hold on
v = [0 0; 1000,0; 1000,60; 0,60];
f = [1 2 3 4];
patch('Faces',f,'Vertices',v,'FaceColor','blue','FaceAlpha',.1)
v = [1000 0; 2000,0; 2000,60; 1000,60];
f = [1 2 3 4];
patch('Faces',f,'Vertices',v,'FaceColor','red','FaceAlpha',.1)
v = [2000 0; 3000,0; 3000,60; 2000,60];
f = [1 2 3 4];
patch('Faces',f,'Vertices',v,'FaceColor','green','FaceAlpha',.1)

plot(data.node{1}.time,30*ones(size(data.node{1}.time)),'k-','LineWidth',1);
plot(data.node{1}.time,10*ones(size(data.node{1}.time)),'k-','LineWidth',1);
stairs(data.node{1}.time,data.node{1}.state(4:end,:)','color',[0 0 0]+.7);
stair1=stairs(data.node{1}.time,data.node{1}.state(1,:)','LineWidth',2);
stair1.Color=[0 0 1]*.9;
stair2=stairs(data.node{1}.time,data.node{1}.state(2,:)','LineWidth',2);
stair2.Color=[1 0 0]*.9;
stair3=stairs(data.node{1}.time,data.node{1}.state(3,:)','LineWidth',2);
stair3.Color=[0 1 0]*.9;
plot([1000,1000],[0 80],'k-');
plot([2000,2000],[0 80],'k-');
axis([0 3000 0 60])
hold off
tightLayout
xlabel('time(minutes)')
ylabel('Species Count')
(set(gca, 'YGrid', 'on', 'XGrid', 'on'));
LabelPlot('B')

subplot(2,3,3)
hold on
makeHist(initialTargetData(:),0:60-.5,[1 .75 0],.6)
makeHist(finalTargetData(:),0:60-.5,'red',.4)
plot((1:50),Py,'g-.','color',[0 0 0]+.1,'linewidth',2)
tightLayout
box on
ylabel('Probability')
xlabel('Species Count')
legend('Initial','Final','Steady State')
LabelPlot('C')
ax=gca;
ax.Position=[0.6916    0.5804    0.2767    0.3626];

subplot(2,3,6)
hold on
makeHist(initialNonTargetData(:),0:60-.5,'cyan',.6)
makeHist(finalNonTargetData(:),0:60-.5,'blue',.4)
plot((1:50),Px,'g-.','color',[0 0 0]+.1,'linewidth',2)
tightLayout
box on
ylabel('Probability')
xlabel('Species Count')
legend('Initial','Final','Steady State')
ax=gca;
ax.Position=[0.6916    0.0967    0.2767    0.3626];
LabelPlot('D')
end
function histogramFig=makeHist(data,bins,color,alpha)
histogramFig=histogram(data,bins,'Normalization','probability');
histogramFig.EdgeAlpha=0;
histogramFig.FaceAlpha=alpha;
histogramFig.FaceColor=color;
histogramFig.LineWidth=2;
end
