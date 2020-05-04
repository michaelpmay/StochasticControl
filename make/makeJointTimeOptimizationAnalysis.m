addpath classes
analizer=JointTimeOptimizer;
analizer.time=linspace(0,2000,2000); %was 0 50 50 
analizer.deltaTRange=0.1:0.1:1; %was :20
analysis=analizer.analyze();
save analysis
