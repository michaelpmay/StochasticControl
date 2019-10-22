addpath classes
analyzer=NCellAnalysis();
load inFiles/reducedControlInput.mat
controlInput(200)=0;
analyzer.input{2}=@(t,x)controlInput(x(1)+1);
load inFiles/controlInput.mat
controlInput(200,200)=0
analyzer.input{3}=@(t,x)controlInput(x(1)+1,x(2)+1)
analyzer.input{4}=@(t,x)controlInput(x(1)+1,round(mean(x(2:end)))+1)
score=analyzer.analyze;  