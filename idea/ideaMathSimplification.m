clear all
L=[5 8]
Sij1=[-1 0 0;1 -1 0 ;0 1 0]
Sij2=[0 1 0; 0 -1 2; 0 0 -2]
Pss=null(L(1)*Sij1+L(2)*Sij2)
Pss=Pss./sum(Pss)

L=null([Sij1*Pss,Sij2*Pss])
L=L/L(1)


P(:,1)=[.3333 ;.3333; .3333]
t=linspace(0,.1,20000)
for i=1:length(t)
  P(:,i+1)=expm((L(1)*Sij1+L(2)*Sij2)*t(i))*P(:,1);
end
dt=t(2)-t(1);
for i=1:length(t)
  dP(:,i)=(P(:,i+1)-P(:,i));
  dP(:,i)=dP(:,i)+0.05*norm(dP(:,i))*(.5-rand(3,1));
  mP(:,i)=(P(:,i+1)+P(:,i))/2;
  k(:,i)=pinv([Sij1*mP(:,i),Sij2*mP(:,i)])*dP(:,i);
  k(:,i)=k(:,i)./k(1,i)*5;
end

plot(t,k')
%%

clear all
L=[5 2 5 12 1 2]
Sij1=[-1 0 0 0;1 0 0 0;0 0 0 0;0 0 0 0]
Sij2=[0 0 0 0;0 -1 0 0;0 1 0 0;0 0 0 0]
Sij3=[0 0 0 0;0 0 0 0;0 0 -1 0;0 0 1 0]
Sij4=[0 1 0 0;0 -1 0 0;0 0 0 0;0 0 0 0]
Sij5=[0 0 0 0;0 0 1 0;0 0 -1 0;0 0 0 0]
Sij6=[0 0 0 0;0 0 0 0;0 0 0 1;0 0 0 -1]
Pss=null(L(1)*Sij1+L(2)*Sij2+L(3)*Sij3+L(4)*Sij4+L(5)*Sij5+L(6)*Sij6)
Pss=Pss./sum(Pss)
L=null([Sij1*Pss(1)+Sij2*Pss(2)+Sij3*Pss(3)+Sij4*Pss(4)+Sij5*Pss(5)+Sij6*Pss(6)])
L=L/L(1)
P(:,1)=[1;0;0;0]
t=linspace(0,.1,20000)
for i=1:length(t)
  P(:,i+1)=expm((L(1)*Sij1)*t(i))*P(:,1);
end
dt=t(2)-t(1);
for i=1:length(t)
  dP(:,i)=(P(:,i+1)-P(:,i));
  mP(:,i)=(P(:,i+1)+P(:,i))/2;
  k(:,i)=pinv([Sij1*mP(:,i)])*dP(:,i);
  k(:,i)=k(:,i)./k(1,i);
end