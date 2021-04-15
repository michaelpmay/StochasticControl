man caddpath(genpath('utility'))
factory=ModelFactory;
layer=DataLayer();
controls=layer.get('ControlInputs_ReducedModels');
model=factory.autoregulatedModelWithoutInput();
model.controlInput=zeros(50);
fsp=TwoCellFSP(model,[50 50]);
Z=[ones([1 2500])/2500^2]/10000;
A=sparse(fsp.generator.getAMatrix());
B=sparse(fsp.generator.getBMatrix());
P=ones(50)./50^2;
P=P(:);
P=getP(A,B,Z,P,10);
scorer=ProbabilityScore([50 50]);
C=scorer.makeC([50 50]);
for i=1:1000
P=getP(A,B,Z,P,1);
max(P)
min(P)
grad=gradient(A,B,Z,P,C,5);
Z=Z.*exp(-grad*10);
score=C'*P
end
function P=getP(A,B,Z,P,time)
traj=ode23(@rateEQ,[0 time],P);
P=traj.y(:,end);
  function rate=rateEQ(t,P)
    U=Z*[P(:)];
    U(U<0)=0;
    rate=(A+B*(U))*P(:);
  end
end
function grad=gradient(A,B,Z,P,C,gmresMaxIter)
gmresTolerance=.01;
tolerance=sort(P,'descend');
rando=randperm(length(P));
Pe=P;
Pe(rando(10:end))=0;
Pe=sparse(Pe);
Lambda=sparse(B*(Pe(:)*Z)+A+B*(Z*Pe(:)));
M=kron(sparse(eye(prod([50 50]))),Lambda);
K=((B*Pe)*Pe');
K=K(:);
grad=gmres(M,K,[],gmresTolerance,gmresMaxIter);
grad=grad./norm(grad);
grad=reshape(grad,[prod([50 50]), prod([50 50])]);
grad=C'*grad;
end


