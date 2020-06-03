addpath classes/
addpath classes/parallel/
addpath utility/
analyzer=NCellAnalysis();
load data/controlers/ReducedControlerAutoregulatedModelControler
reducedControlInput(200)=0;
analyzer.input{2}=@(t,x)reducedControlInput(x(1)+1);
analyzer.time=linspace(0,200,100);
load data/controlers/FullControlerAutoregulatedModelControler
controlInput(1000,1000)=0;
uEx=getUEx;
uMx=getUMx;
analyzer.input{3}=@(t,x)controlInput(x(1)+1,x(2)+1);
analyzer.input{4}=@(t,x)controlInput(x(1)+1,round(mean(x(2:end)))+1);
analyzer.input{5}=@(t,x)mean(controlInput(x(1)+1,x(2:end)+1));
analyzer.input{6}=@(t,x)uEx(x(1)+1);
analyzer.input{7}=@(t,x)uMx(x(1)+1);
analyzer.nRange=[32 16 8 4 2 1]
for i=1:10
score{i}=analyzer.analyze();
end


function u=getUEx()
load data/controlers/FullControlerAutoregulatedModelControler
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
load data/controlers/FullControlerAutoregulatedModelControler
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
