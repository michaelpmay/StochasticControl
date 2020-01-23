addpath classes
clear all;
stepSize=5;
dims=[40 40];
lowerBound=0;
upperBound=20;
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

score=ProbabilityScore(dims);
C=[score.C];
dt=1;
% for i=1
%   U=l*E;
%   U(U<lowerBound)=lowerBound;
%   U(U>upperBound)=upperBound;
%   iterFsp=iterFsp.iterateStep(expm(A+B.*(U')),dt);
%   P=iterFsp.getLastState;
%   subplot(1,2,1)
%   pcolorProbability(reshape(P,dims));
%   currentScore(i)=C'*[P]
%   E=[P-Ps;1];
%   U=l*E;
%   L=A+B.*U';
%   phi=B.*(l*J*P)'+L;
%   %PhiInv=pinv((B.*X)*l+L);
%   omega=(B.*P');
%   omega=omega(:);
%   K=kron(speye(N),phi);
%   grad=gmres(K,omega,[],1e-10,60);
%   grad=-reshape(grad,[N N]);
%   l=l-((C'*grad)'.*E')*stepSize;
% hold on
% plot(scoreWithE)
% plot(scoreNoE)*(B.*P))'.*E'
%   
%   control{i}=l;
%   U=l*E;
%   U(U<lowerBound)=lowerBound;
%   U(U>upperBound)=upperBound;
%   
%   modelFsp.model.controlInput=reshape(U(1:prod(dims)),dims);
%   
%   subplot(1,2,2);
%   pcolorProbability(modelFsp.model.controlInput);
%   colorbar()
%   pause(1)
% end
Po=zeros(N,1);
Po(5)=1;
Pu=ones(N,1);
Pu=Pu./sum(Pu);
iterFsp=IterableFsp;
iterFsp.state=Po;
E=[Po-Ps];
Ep=.5*ones(N,1);
U=modelFsp.model.controlInput(:);
for i=1:500
  iterFsp=iterFsp.iterateStep(expm(A+B.*(U')),dt);
  scoreWithE(i)=C'*iterFsp.getLastState()
  E=[iterFsp.getLastState-Ps];
  l=[-(C'*(B.*iterFsp.getLastState'))'.*E'*5];
  U=shiftJ*l*E+optimalControler;
  U(U<lowerBound)=lowerBound;
  U(U>upperBound)=upperBound;
  U=squareify(U,dims);
  U=U(:);
  subplot(1,2,1)
  pcolorProbability(reshape(U,dims))
  colorbar()
  subplot(1,2,2)
  pcolorProbability(reshape(iterFsp.getLastState,dims))
  colorbar()
  drawnow()
end

iterFsp=IterableFsp;
iterFsp.state=Po;
U=modelFsp.model.controlInput(:);  
U(U<lowerBound)=lowerBound;
U(U>upperBound)=upperBound;
Em=expm(A+B.*(U'));
for i=1:500
  iterFsp=iterFsp.iterateStep(Em,dt);
  scoreNoE(i)=C'*iterFsp.getLastState;
  E=[iterFsp.getLastState-Ps;1];
  pcolorProbability(reshape(iterFsp.getLastState,dims));
end
figure
hold on
plot(scoreWithE)
plot(scoreNoE)
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