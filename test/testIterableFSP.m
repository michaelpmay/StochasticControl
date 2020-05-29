fsp=IterableFsp([1;0],0);
stateGenerator=[.9 .1; 
                .1 .9];
for i=1:100
fsp=fsp.iterateStep(stateGenerator,1);
end

data=fsp.run()