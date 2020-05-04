X=GenericFSP;
X.time=linspace(0,5,100);
X.initialState=[1 0 0]';
X.infGenerator=[-3  1  0;
            3 -4  2
            0  3 -2];
data=X.run();