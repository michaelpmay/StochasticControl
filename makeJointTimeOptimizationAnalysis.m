addpath classes
analizer=JointTimeOptimizer;
analizer.time=linspace(0,500,500); %was 0 50 50 
analizer.deltaTRange=0.1:0.1:20; %was :20
analysis=analizer.analyze();
saveAnalysis(analysis);
