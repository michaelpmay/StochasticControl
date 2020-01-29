clear all
addpath classes/
stepSize=5;
dims=[50 50];
lowerBound=0;
upperBound=20;
Z=500;
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
iterFsp.state=Po;
E=[Po-Ps];
Ep=.5*ones(N,1);
U=modelFsp.model.controlInput(:);
dt=.1
for i=1:Z
  iterFsp=iterFsp.iterateStep(expm(A+B.*(U(:)')),dt);
  Pxyn=reshape(iterFsp.getLastState,dims);
  Px=sum(Pxyn,1);
  Py=sum(Pxyn,2);
  s=sampleFrom(Py(:),1);
  Pxy=zeros(dims);
  Pxy(s+1,:)=Px;
  iterFsp.state(:,end)=Pxy(:);
  scoreWithE(i)=C'*iterFsp.getLastState()
  E=[iterFsp.getLastState-Ps];
  l=[-(C'*(B.*iterFsp.getLastState'))'.*E'*5];
  U=shiftJ*l*E+optimalControler;
  U(U<lowerBound)=lowerBound;
  U(U>upperBound)=upperBound;
  U=squareify(U,dims);
  U=U(:);
end
clearvars -except dt Po model Ps scoreWithE A B Z dims C
iterFsp=IterableFsp;
iterFsp.state=Po;
E=[Po-Ps]
U=model.controlInput;
U=U(:);
for i=1:Z
  iterFsp=iterFsp.iterateStep(expm(A+B.*(U(:)')),dt);
  Pxyn=reshape(iterFsp.getLastState,dims);
  Px=sum(Pxyn,1);
  Py=sum(Pxyn,2);
  s=sampleFrom(Py(:),1);
  Pxy=zeros(dims);
  Pxy(s+1,:)=Px;
  iterFsp.state(:,end)=Pxy(:);
  scoreWithoutE(i)=C'*iterFsp.getLastState()
end
save('matlab2.mat')
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
