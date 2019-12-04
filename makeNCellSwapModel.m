addpath classes/
N=3;
build=ModelFactory
load inFiles/autoregulatedReducedControler.mat
controlInput(200)=0;
controlInput(1:10)=.5;
model=build.nCellAutoregulatedSwapModel(N,controlInput,linspace(0,10000*3,10000*3));
modelSSA=SolverSSA(model);
data=modelSSA.run;
parsedData=data.parse(10);
view=ViewSSA(data,subplot(1,1,1));
stateMax=max(max(data.node{1}.state));
bins=0:2:stateMax
%%
AcademicFigure
subplot(2,1,2)
hold on
nonTargetData= parsedData.node{1}.state([2,3],1:1000)
H11=makeHist(parsedData.node{1}.state(1,1:1000),bins,'red')
H12=makeHist(nonTargetData(:),bins,'blue')
%subplot(1,2,2)
hold on
nonTargetData=parsedData.node{1}.state([1,3],1001:2000);
H21=makeHist(parsedData.node{1}.state(2,1001:2000),bins,'red')
H22=makeHist(nonTargetData(:),bins,'blue')
%subplot(1,2,2)
hold on
nonTargetData=parsedData.node{1}.state([1,2],2001:3000);
H31=makeHist(parsedData.node{1}.state(3,2001:3000),bins,'red')
H32=makeHist(nonTargetData(:),bins,'blue')
subplot(2,1,1)
hold on
stairs(data.node{1}.time,data.node{1}.state');
plot(data.node{1}.time,30*ones(size(data.node{1}.time)),'k--','LineWidth',2);
plot(data.node{1}.time,10*ones(size(data.node{1}.time)),'k--','LineWidth',2);
plot([10000,10000],[0 80],'k-');
plot([20000,20000],[0 80],'k-');
hold off
function histogram=makeHist(data,bins,color)
hist(data,bins);
histogram= findobj(gca,'Type','patch');
histogram(1).EdgeAlpha=1;
histogram(1).FaceAlpha=0;
histogram(1).EdgeColor=color;
end
