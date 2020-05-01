clear all
build=ModelFactory;
modelFsp=build.optimizedTwoCellModel();
A=modelFsp.generator.getAMatrix();
B=modelFsp.generator.getBMatrix();
O=modelFsp.model.controlInput(:);
U=rand(size(O))*.001;
V=rand(size(O))*.001;
Inf1=A+B.*(O');
Inf2=A+B.*(O'+U');
Inf3=A+B.*(O'+U'+V');
Inf4=A+B.*(O'+V');
dT=.001;
E1=expm(Inf1*dT);
E2=expm(Inf2*dT);
E3=expm(Inf3*dT);
E4=expm(Inf4*dT);
timeVec=linspace(0,500,50);
Po=null(Inf1);
Po=Po./sum(Po);
ET1=eye(size(E1));
ET2=eye(size(E2));
ET3=eye(size(E3));
ET4=eye(size(E4));
for i=1:50
ET1=ET1*E1;
ET2=ET2*E2;
ET3=ET3*E3;
ET4=ET4*E4;
Pc=(ET1)*(ET4)*(ET3)*(ET2)*Po;
curvature{i}=Po-Pc
end
for i=1:50
  pcolorProbability(reshape(curvature{i},[50 50]))
  title(['i : ',num2str(i)])
  caxis([-1e6 1e-6])
  colorbar()
  drawnow()
  pause(.5);
end

ET19=E1^9;
ET29=E2^9;
ET39=E3^9;
ET49=E4^9;
for i=1:50
  if i==1
    Pc9{i}=(ET19)*(ET49)*(ET39)*(ET29)*Po;
  else
    Pc9{i}=(ET19)*(ET49)*(ET39)*(ET29)*Pc9{i-1};
  end
  curvature2{i}=Po-Pc9{i}
end

for i=1:50
  if i==1
    Pc9{i}=(E1)*(E4)*(E3)*(E2)*Po;
  else
    Pc9{i}=(E1)*(E4)*(E3)*(E2)*Pc9{i-1};
  end
  curvature3{i}=Po-Pc9{i}
end

for i=1:50
  pcolorProbability(reshape(curvature3{i},[50 50]))
  title(['i : ',num2str(i)])
  caxis([-1e-5 1e-5])
  colorbar()
  drawnow()
  pause(.5);
end