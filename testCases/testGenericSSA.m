clear all
X=GenericSSA;
X.time=[0 200];
X.stoichMatrix=[-1   0 
                 1, -1];
X.initialState=[100;0];
X.rxnRate=@(x,t,u)[1*(x(1)) ; .05*x(2)];
data=X.run();


X.stoichMatrix=[-1   0  1;
                 1, -1  0];
X.rxnRate=@(x,t,u)[1*(x(1)) ; .05*x(2);1];            
X.time=linspace(0,200)
data=X.run();