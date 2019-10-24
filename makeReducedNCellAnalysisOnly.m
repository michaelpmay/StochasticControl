addpath classes
analyzer=NCellAnalysis();
load inFiles/autoregulatedReducedControler.mat
controlInput(200)=0;
analyzer.input={}
analyzer.input{1}=@(t,x)controlInput(x(1)+1);
analyzer.parallelAnalyze;