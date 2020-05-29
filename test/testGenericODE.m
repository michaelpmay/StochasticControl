ode=GenericODE;
ode.time=linspace(0,5,100);
ode.initialState=[5 5];
ode.rxnRate=@(x,t)[5*x(1)^2;x(2)];
ode.stoichMatrix=[-1 1;0 -1];
data=ode.run();