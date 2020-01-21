addpath classes
clear all;
stepSize=.005;
dims=[40 40]
builder=ModelFactory
model=builder.autoregulatedModelWithoutInput;
model.controlInput=.3*ones(dims);
modelFsp=TwoCellFSP(model,dims);
N=prod(modelFsp.dims);
A=modelFsp.generator.getAMatrix;
B=modelFsp.generator.getBMatrix;
J=eye(N+1);
J=J(:,1:(end-1));
P=modelFsp.getSteadyState;
l=0*ones(N,N);
l(:,N+1)=model.controlInput(:);
X=[P;1];

score=ProbabilityScore(dims);
C=[score.C];
for i=1:50
  P=modelFsp.getSteadyState;
  subplot(1,2,1)
  pcolorProbability(reshape(P,dims));
  currentScore(i)=C'*[P]
  X=[P;1];
  U=l*X;
  L=A+B.*U;
  phi=B.*(l*J*P)'+L;
  %PhiInv=pinv((B.*X)*l+L);
  omega=(B.*P');
  omega=omega(:);
  K=kron(speye(N),phi);
  grad=gmres(K,omega,[],1e-10,90);
  grad=-reshape(grad,[N N]);
  l=l-((C'*grad)'.*X')*stepSize;
  control{i}=l;
  Unew=l*X;
  Unew(Unew<0)=0;
  Unew(Unew>10)=10;
  modelFsp.model.controlInput=reshape(Unew(1:prod(dims)),dims);
  subplot(1,2,2);
  pcolorProbability(modelFsp.model.controlInput);
  colorbar()
  pause(1)
end