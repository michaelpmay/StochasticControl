clear all
addpath classes/
stepSize=5;
dims=[50 50];
lowerBound=0;
upperBound=5;
Z=2000;
a=[.3 .2 .1];
dt=.01;
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
Po=ones(N,1);
Po=Po./sum(Po);
J=eye(N+1);
J=J(:,1:(end-1));
Ps=modelFsp.getSteadyState;
shiftJ=getJacobian(dims);
L=(a(1)*B-a(2)*eye(size(B))+a(3)*B');
Po=zeros(N,1);
Po(5)=1;
Pu=ones(N,1);
Pu=Pu./sum(Pu);
E=[Po-Ps];
sumP=zeros(size(Ps));
sumE=zeros(size(E));
Ep=.5*ones(N,1);
U=modelFsp.model.controlInput(:);
u=0;
for k=1:5
iterFsp=IterableFsp;
iterFsp.state=Po;
for i=1:Z
  iterFsp=iterFsp.iterateStep(expm(A+B.*(ones(1,N).*u)),dt);
  Pxyn=reshape(iterFsp.getLastState,dims);
  Px=sum(Pxyn,1);
  Py=sum(Pxyn,2);
  s=sampleFrom(Py(:),1);
  Pxy=zeros(dims);
  Pxy(s+1,:)=Px;
  iterFsp.state(:,end)=Pxy(:);
  scoreWithE(i)=C'*iterFsp.getLastState()
  E=[iterFsp.getLastState-Ps];
  U=shiftJ*(L*E)+optimalControler;
  
  U(U<lowerBound)=lowerBound;
  U(U>upperBound)=upperBound;
  u=U(s+1)
  U=squareify(U,dims);
  subplot(1,2,1)
  pcolorProbability(U)
  subplot(1,2,2)
  pcolorProbability(reshape(iterFsp.getLastState,[50 50]))
  drawnow()
  U=U(:);
  
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
