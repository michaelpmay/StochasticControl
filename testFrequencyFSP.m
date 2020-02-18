factory=ModelFactory;
modelFsp=factory.optimizedTwoCellModel;
A=modelFsp.generator.getAMatrix();
B=modelFsp.generator.getBMatrix();
time=linspace(0,100,100);
iFSP=IterableFsp();
amp=.1;
frq=.001;
dco=.25;
fControlInput=@(amp,frq,dco,t)[(amp*sin(2*pi*frq.*t)+dco)*ones(50,50)]';

figure
u=@(t)fControlInput(amp,frq,dco,t);
modelFsp.model.controlInput=2*u(2/(4*frq));
P0=modelFsp.getSteadyStateReshape();
subplot(1,3,1)
pcolorProbability(P0)
 
u=@(t)fControlInput(amp,frq,dco,t);
modelFsp.model.controlInput=2*u(3/(4*frq));
P1=modelFsp.getSteadyStateReshape();
subplot(1,3,2)
pcolorProbability(P1)

u=@(t)fControlInput(amp,frq,dco,t);
modelFsp.model.controlInput=2*u(1/(4*frq));
P2=modelFsp.getSteadyStateReshape();
subplot(1,3,3)
pcolorProbability(P2)

dT=time(2)-time(1);
P0=P0(:);
iFSP.state=P0;

for i=1:length(time)
  i
  U=u(time(i));
  infGenerator=A+B.*U(:)';
  stateGenerator=expm(infGenerator*dT);
  iFSP=iFSP.iterateStep(stateGenerator,dT);
end
data=iFSP.run();
figure
for i=1:length(time)
  pcolorProbability(reshape(data.state(:,i),[50 50]))
  colorbar
  drawnow
  pause(.5)
end