addpath classes
%clear all;  
dims=[50 50];
lowerBound=0;
upperBound=3;
dt=.01;
uRange=linspace(lowerBound,upperBound,30);
score=ProbabilityScore(dims);
C=score.C;
builder=ModelFactory;
model=builder.autoregulatedModelWithoutInput;
layer=DataLayer;
data
data=layer.get('ControlInputs_ReducedModels');
optimalControler=data.ReducedControlAutoregulatedModelControler(1:dims(1));
model.controlInput=repmat(optimalControler,[1,dims(2)]);
modelFsp=TwoCellFSP(model,dims);
N=prod(modelFsp.dims);
A=modelFsp.generator.getAMatrix;
B=modelFsp.generator.getBMatrix;
genSet=makeGeneratorSet(uRange,A,B,dt);
scoreTrajectory={}
scoreTrajectoryNoE={}
try
parpool(3)
catch
  %do nothing
end
parfor i=1:3
  scoreTrajectory{i}=simulate(genSet,B,C,dt,N,lowerBound,upperBound,modelFsp,dims,model,optimalControler,uRange,1);
  save
end
parfor i=1:3
  scoreTrajectoryNoE{i}=simulate(genSet,B,C,dt,N,lowerBound,upperBound,modelFsp,dims,model,optimalControler,uRange,0);
  save
end
function score=simulate(genSet,B,C,dt,N,lowerBound,upperBound,modelFsp,dims,model,optimalControler,uRange,FB)
K=3000;
Po=ones(N,1);
Po=Po./sum(Po);
iterFsp=IterableFsp;
iterFsp.state=Po;
J=eye(N+1);
J=J(:,1:(end-1));
Ps=zeros(50);
Ps(31,11)=1;
shiftJ=getJacobian(dims);
L1=0*ones(N,N);
L1(:,N+1)=model.controlInput(:);
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
ERRM=20;
histE=zeros(N,ERRM);
id=1;
for i=1:K
  printLoopIterations(i,K);
  iterFsp=iterFsp.iterateStep(genSet{id},dt);
  Pxyn=reshape(iterFsp.getLastState,dims);
  Px=sum(Pxyn,1);
  Py=sum(Pxyn,2);
  s=sampleFrom(Py(:),1);
  Pxy=zeros(dims);
  Pxy(s+1,:)=Px;
  iterFsp.state(:,end)=Pxy(:);
  indScore=C'*iterFsp.getLastState();
  score(i)=indScore;
  fprintf('score: %3.3f',indScore)
  E=[iterFsp.getLastState-Ps];
  m=mod(i,ERRM)+1;
  histE(:,i)=E;
  sumE=sum(histE,2);
  if FB==true
    L1=-eye(N,N)*.2;
  else
    L1=0;
  end
  U=shiftJ*(L1*E)+optimalControler;
  U(U<lowerBound)=lowerBound;
  U(U>upperBound)=upperBound;
  u=U(s+1)
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
