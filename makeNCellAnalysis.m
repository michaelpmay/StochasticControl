addpath classes
analyzer=NCellAnalysis();
load inFiles/autoregulatedReducedControler_110gmres.mat
controlInput(200)=0;
analyzer.input{2}=@(t,x)controlInput(x(1)+1);
analyzer.time=linspace(0,50000,50000);
load inFiles/controlInput.mat
controlInput(200,200)=0;
uEx=getUEx;
uMx=getUMx;
analyzer.input{3}=@(t,x)controlInput(x(1)+1,x(2)+1);
analyzer.input{4}=@(t,x)controlInput(x(1)+1,round(mean(x(2:end)))+1);
analyzer.input{5}=@(t,x)mean(controlInput(x(1)+1,x(2:end)+1));
analyzer.input{6}=@(t,x)uEx(x(1)+1);
analyzer.input{7}=@(t,x)uMx(x(1)+1);
analyzer.nRange=[64 32 16 8 4 2 1]
list={[1,1],[1,2],[1,3],[1,4],[1,5],[1,6],[1,7]};
score=analyzer.parallelAnalyze(list);  


function u=getUEx()
load inFiles/controlInput.mat
build=ModelFactory;
modelFsp=build.optimizedTwoCellModel;
Pss=modelFsp.getSteadyState;
Pss=reshape(Pss,[50 50]);
for i=1:50
  y(i)=round(Pss(i,:)/sum(Pss(i,:))*[0:49]');
  x(i)=i-1;
  u(i)=controlInput(x(i)+1,y(i)+1);
end
u(200)=0;
end
function u=getUMx()
load inFiles/controlInput.mat
build=ModelFactory;
modelFsp=build.optimizedTwoCellModel;
Pss=modelFsp.getSteadyState;
Pss=reshape(Pss,[50 50]);
for i=1:50
  [m,yInd]=max(Pss(i,:)/sum(Pss(i,:)));
  y(i)=yInd-1;
  x(i)=i-1;
  u(i)=controlInput(x(i)+1,y(i)+1);
end
u(200)=0;
end
