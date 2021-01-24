syms Tn Tc T g P gamma k1 k2 k3 k4 k5 k6 h1 h2 h3 h4 h5 h6 y G
STN=solve([Tn*(h1*(h2+k3*Tn)+k3*(k2+h3*T))-(k1+h3*T)*(h2+k3*Tn)==Tn],Tn)
STC=solve([Tc*(h2*(h1+k3*Tc)+k3*(k1+h3*T))-(k2+h3*T)*(h1+k3*Tc)==Tc],Tc)
STG=(G*T*k4)/(h4 + T*k4);
STT=solve([(k3*STN(1)*STC(1)+h4*STG)==T],T)

%%
clear all
k1=1;
k2=2;
k3=3;
k4=4;
h1=5;
h2=6;
h3=7;
h4=8;
G=3;
F1=@(x)[x(1)*(h1*(h2+k3*x(1))+k3*(k2+h3*x(3)))-(k1+h3*x(3))*(h2+k3*x(1))-x(1);
        x(2)*(h2*(h1+k3*x(2))+k3*(k1+h3*x(3)))-(k2+h3*x(3))*(h1+k3*x(2))-x(2);
        (G*x(3)*k4)/(h4 + x(3)*k4);
        (k4*x(3)*G)/(k4*x(3)+h4)]
options = optimoptions('fsolve');
options.MaxIterations= 40000000
STN=fsolve(F1,[1 1 1 1])

