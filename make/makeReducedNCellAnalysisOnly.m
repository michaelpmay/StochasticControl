addpath classes
analyzer=NCellAnalysis();
load inFiles/autoregulatedReducedControler.mat
controlInput(200)=0;
analyzer.input={}
analyzer.input{1}=@(t,x)controlInput(x(1)+1);
analyzer.nRange=[1,2,4,8,16,32]
analyzer.trim=500;
analyzer.time=linspace(0,20000,20000/500);
for i=1:50
score{i}=analyzer.parallelAnalyze;
score{i}
end  