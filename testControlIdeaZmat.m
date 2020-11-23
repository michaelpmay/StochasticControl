addpath(genpath('utility/'))
clear all
n=[50 50];
N=[2500]
X=ones(N,1);
X=X./sum(X);
Z2=zeros(50,50);
Z2(1:30,:)=1;
Z1=0;
Z=[Z1,Z2(:)'];
Z=Z(:)';
Y=[1;X];
build=ModelFactory;
model=build.autoregulatedModelWithoutInput;
fsp=TwoCellFSP(model,[50 50])
fsp.model.controlInput=zeros(50);
A=fsp.getInfGenerator;
B=fsp.generator.getBMatrix;
RateEqn=@(t,X)(A+B.*(Z*[1;X])')*X;
RateEqn(0,X);
scorer=ProbabilityScore([50 50]);
C=scorer.makeC([50 50]);
J=[zeros(2500,1),eye(2500)];
OptEqn=@(X)(C'*(pinv(A+B.*(Z*[1;X])'+(B.*(Z*J')).*X')*(B*X)))*[1;X]';
OptEqn(X);
Xo=ones(50);
Xo=Xo(:)./sum(sum(Xo));
tStep=[0,50];
dx=.05;
Xo=getSS(Z,Xo,tStep*10);
for i=1:500
  Xo=getSS(Z,Xo,tStep);
  OptEqn=@(X)(C'*(pinv(A+B.*(Z*[1;X])'+(B.*(Z*J')).*X')*(B*X)))*[1;X]';
  DZ=OptEqn(Xo)
  DZ(DZ<-10)=-10;
  DZ(DZ>10)=10;
  dx=dx*.95;
  if dx<.05;
    dx=.05;
  end
  Z=Z-DZ*dx;
  Z(Z<-10)=-10;
  Z(Z>10)=10;
end
save testControlledIdeaZMatrix
function X=getSS(Z,Xo,t)
build=ModelFactory;
model=build.autoregulatedModelWithoutInput;
fsp=TwoCellFSP(model,[50 50])
fsp.model.controlInput=zeros(50);
A=fsp.getInfGenerator;
B=fsp.generator.getBMatrix;
RateEqn=@(t,X)(A+B.*(Z*[1;X])')*X;
[t,X]=ode45(RateEqn,t,Xo);
X=X(end,:)';
end

function optEqn(X,A,B,Z)
partial=gmres(A+B.*(Z*[1;X])'+(B.*(Z*J')).*X',(B*X))
grad=-c*partial*[1;X]';
grad(grad<-10)=-10;
  grad(grad>10)=10;
end