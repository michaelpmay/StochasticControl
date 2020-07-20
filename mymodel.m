name = '';
description = '';
parameters = [1 1];
stoichMatrix = [1 -1];
rxnRate = @(t,x,p)[p(1);p(2)*x(1)];
time = 0:2.004008e-01:100;
initialState = 0;
