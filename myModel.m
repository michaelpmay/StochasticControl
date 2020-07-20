name = '';
description = '';
parameters = [0.8087 0.2591 1.1903 8.8673 0.0028 0.0558 10 0.0148];
stoichMatrix = [1 -1 0 0 -1 1 0 0 0 0 0;0 0 1 -1 -1 1 0 0 0 0 0;0 0 0 0 1 -1 -1 -1 1 0 0;0 0 0 0 0 0 0 1 -1 0 0;0 0 0 0 0 0 0 0 0 1 -1];
rxnRate = @(t,x,p)[p(1);(p(1)/20)*x(1);p(1)*3;(p(1)/20)*x(2);(p(3)+obj.ExperimentalInput(t,x,obj.fullKhammashU))*x(1)*x(2);p(4)*x(3);p(5)*x(3);p(6)*x(3)*(obj.maxGenes-x(4));p(7)*x(4);p(8)*x(4);obj.ga*x(5)];
time = 0:7.878788e+00:780;
initialState = [1;1;0;0;0];
