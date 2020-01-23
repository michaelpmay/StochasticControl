Po=zeros(N,1);
Po(5)=1;
Pu=ones(N,1);
Pu=Pu./sum(Pu);
iterFsp=IterableFsp;
iterFsp.state=Ps;
E=[Ps-Ps];
Ep=.5*ones(N,1);
U=modelFsp.model.controlInput(:);
dt=.1
for i=1:500
  iterFsp=iterFsp.iterateStep(expm(A+B.*(U(:)')),dt);
  subplot(1,3,1)
  pcolorProbability(reshape(iterFsp.getLastState,dims));
  Pxyn=reshape(iterFsp.getLastState,dims);
  Px=sum(Pxyn,1);
  Py=sum(Pxyn,2);
  s=sampleFrom(Py(:),1);
  Pxy=zeros(dims);
  Pxy(s+1,:)=Px;
  iterFsp.state(:,end)=Pxy(:);
  scoreWithE(i)=C'*iterFsp.getLastState();
  E=[iterFsp.getLastState-Ps];
  l=[-(C'*(B.*iterFsp.getLastState'))'.*E'*5];
  U=shiftJ*l*E+optimalControler;
  U(U<lowerBound)=lowerBound;
  U(U>upperBound)=upperBound;
  U=squareify(U,dims);
  U=U(:);
  subplot(1,3,2)
  pcolorProbability(reshape(U,dims))
  colorbar()
  subplot(1,3,3)
  pcolorProbability(reshape(iterFsp.getLastState,dims))
  colorbar()
  drawnow()
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