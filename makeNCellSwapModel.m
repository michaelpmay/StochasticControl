addpath classes/
N=3;
build=ModelFactory
load inFiles/unregulatedReducedControler.mat
unregControlInput=controlInput;
unregControlInput(200)=0;
load inFiles/autoregulatedReducedControler_110gmres.mat
controlInput(1:10)=.5
autoregControlInput=controlInput;
autoregControlInput(200)=0;
time=linspace(0,1000*3,1000*3);
unregModel=build.nCellUnregulatedSwapModel(N,unregControlInput,time);
autoregModel=build.nCellAutoregulatedSwapModel(N,autoregControlInput,time);
AcademicFigure
makeSwapModelFigure(unregModel,[1,2]);
makeSwapModelFigure(autoregModel,[3,4]);
function makeSwapModelFigure(model,subplotIndex)
modelSSA=SolverSSA(model);
data=modelSSA.run;
parsedData=data.parse(10);
stateMax=max(max(data.node{1}.state));
bins=0:2:stateMax;
%%
subplot(2,2,subplotIndex(2))
hold on
nonTargetData= parsedData.node{1}.state([2,3],1:100)
H11=makeHist(parsedData.node{1}.state(1,1:100),bins,'red')
H12=makeHist(nonTargetData(:),bins,'blue')
%subplot(1,2,2)
hold on
nonTargetData=parsedData.node{1}.state([1,3],101:000);
H21=makeHist(parsedData.node{1}.state(2,101:200),bins,'red')
H22=makeHist(nonTargetData(:),bins,'blue')
%subplot(1,2,2)
hold on
nonTargetData=parsedData.node{1}.state([1,2],201:300);
H31=makeHist(parsedData.node{1}.state(3,201:300),bins,'red')
H32=makeHist(nonTargetData(:),bins,'blue')
subplot(2,2,subplotIndex(1))
hold on
stairs(data.node{1}.time,data.node{1}.state');
plot(data.node{1}.time,30*ones(size(data.node{1}.time)),'k--','LineWidth',2);
plot(data.node{1}.time,10*ones(size(data.node{1}.time)),'k--','LineWidth',2);
plot([1000,1000],[0 80],'k-');
plot([2000,2000],[0 80],'k-');
hold off
tightLayout
end
function histogramFig=makeHist(data,bins,color)
histogramFig=histogram(data,bins,'Normalization','probability');
histogramFig.EdgeAlpha=0;
histogramFig.FaceAlpha=.7;
histogramFig.FaceColor=color;
end
