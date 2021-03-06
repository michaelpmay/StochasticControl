addpath classes
%clear all;  
dims=[50 50];
lowerBound=0;
upperBound=20;
dt=.1;
uRange=linspace(0,2,11);
score=ProbabilityScore(dims);
C=score.C;
V=10;
builder=ModelFactory;
model=builder.autoregulatedModelWithoutInput;
optimalControler=load('data/controlers/ReducedControlerAutoregulatedModelControler.mat');
optimalControler=optimalControler.controlInput(1:dims(1));
model.controlInput=repmat(optimalControler,[1,dims(2)]);
modelFsp=TwoCellFSP(model,dims);
N=prod(modelFsp.dims);
A=modelFsp.generator.getAMatrix;
B=modelFsp.generator.getBMatrix;
genSet=makeGeneratorSet(uRange,A,B,dt);
scoreTrajectory={}
scoreTrajectoryNoE={}
beta=87.67;
for i=1:V
  scoreTrajectory{i}=simulate(genSet,B,C,dt,N,lowerBound,upperBound,modelFsp,dims,model,optimalControler,uRange,1,beta);
  save
end
% for i=1:V
%   scoreTrajectoryNoE{end+1}=simulate(genSet,B,C,dt,N,lowerBound,upperBound,modelFsp,dims,model,optimalControler,uRange,0);
%   save
% end
function score=simulate(genSet,B,C,dt,N,lowerBound,upperBound,modelFsp,dims,model,optimalControler,uRange,FB,beta)
K=5000;
a=[.3 .2 .1];
Po=ones(N,1);
Po=Po./sum(Po);
iterFsp=IterableFsp;
iterFsp.state=Po;
J=eye(N+1);
J=J(:,1:(end-1));
Ps=modelFsp.getSteadyState;
shiftJ=getJacobian(dims);
L=diag(C)*(a(1)*B-a(2)*eye(size(B))+a(3)*B')./50;
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
score=zeros(K,1);
for i=1:K
  printLoopIterations(i,K)
  iterFsp=iterFsp.iterateStep(genSet{id},dt);
  if mod(i-1,4)==0
    Pxyn=reshape(iterFsp.getLastState,dims);
    Px=sum(Pxyn,1);
    Py=sum(Pxyn,2);
    s=sampleFrom(Py(:),1);
    Pxy=zeros(dims);
    Pxy(s+1,:)=Px;
    iterFsp.state=Pxy(:);
    iterFsp.time=iterFsp.time(end);
  else
    iterFsp.state=iterFsp.state(:,end);
    iterFsp.time=iterFsp.time(end);
  end
  score(i)=C'*iterFsp.getLastState();
  fprintf("score: %3.3f\n",score(i))
  E=[iterFsp.getLastState-Ps];
  if FB==true
    L=L;
  else
    L=0*L;
  end
  U=shiftJ*L*E+optimalControler;
  U(U<lowerBound)=lowerBound;
  U(U>upperBound)=upperBound;
  U=squareify(U,[1,dims(2)]);
  u=U(:)'*iterFsp.getLastState;
  [ u, id ] = min( abs( uRange-u ) );
  inputHistory(i)=u;
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
