addpath classes
clear all;
dims=[50 50];
lowerBound=0;
upperBound=20;
dt=.1;
uRange=linspace(0,2,101);
score=ProbabilityScore(dims);
C=score.C;
builder=ModelFactory;
model=builder.autoregulatedModelWithoutInput;
optimalControler=load('inFiles/autoregulatedReducedControler_110gmres.mat');
optimalControler=optimalControler.controlInput(1:dims(1));
optimalControler(1:10)=1;
model.controlInput=repmat(optimalControler,[1,dims(2)]);
modelFsp=TwoCellFSP(model,dims);
N=prod(modelFsp.dims);
A=modelFsp.generator.getAMatrix;
B=modelFsp.generator.getBMatrix;
genSet=makeGeneratorSet(uRange,A,B,dt);
for i=1:30
  scoreTrajectory{end+1}=simulate(genSet,B,C,dt,N,lowerBound,upperBound,modelFsp,dims,model,optimalControler,uRange,1);
end
for i=1:30
  scoreTrajectoryNoE{end+1}=simulate(genSet,B,C,dt,N,lowerBound,upperBound,modelFsp,dims,model,optimalControler,uRange,0);
end
function score=simulate(genSet,B,C,dt,N,lowerBound,upperBound,modelFsp,dims,model,optimalControler,uRange,FB)
K=1000;
Po=ones(N,1);
Po=Po./sum(Po);
iterFsp=IterableFsp;
iterFsp.state=Po;
J=eye(N+1);
J=J(:,1:(end-1));
Ps=modelFsp.getSteadyState;
shiftJ=getJacobian(dims);
l=0*ones(N,N);
l(:,N+1)=model.controlInput(:);
E=[Po-Ps;1];
Po=zeros(N,1);
Po(5)=1;
Pu=ones(N,1);
Pu=Pu./sum(Pu);
iterFsp=IterableFsp;
iterFsp.state=Ps;
E=[Ps-Ps];
Ep=.5*ones(N,1);
U=modelFsp.model.controlInput(:);
id=1;
for i=1:K
  printLoopIterations(i,K)
  iterFsp=iterFsp.iterateStep(genSet{id},dt);
  Pxyn=reshape(iterFsp.getLastState,dims);
  Px=sum(Pxyn,1);
  Py=sum(Pxyn,2);
  s=sampleFrom(Py(:),1);
  Pxy=zeros(dims);
  Pxy(s+1,:)=Px;
  iterFsp.state(:,end)=Pxy(:);
  score(i)=C'*iterFsp.getLastState();
  E=[iterFsp.getLastState-Ps];
  if FB==true
    l=[-(C'*(B.*iterFsp.getLastState'))'.*E'*5];
  else
    l=0*[-(C'*(B.*iterFsp.getLastState'))'.*E'*5];
  end
  U=shiftJ*l*E+optimalControler;
  U(U<lowerBound)=lowerBound;
  U(U>upperBound)=upperBound;
  u=U(s+1);
  [ u, id ] = min( abs( uRange-u ) );
end
end
function generatorSet=makeGeneratorSet(uRange,A,B,dt)
N=length(uRange)
for i=1:N
  printLoopIterations(i,N);
  generatorSet{i}=expm(dt.*(A+B.*uRange(i)));
end
end
function J=getJacobian(dims)
  for i=1:dims(1)
    X=zeros(dims);
    X(i,:)=1;
    J(i,:)=X(:);
  end
end

function square=squareify(vector,dims)
square=repmat(vector,[1,dims(2)]);
end