function batchFullModelControlSSA(N,index)
addpath classes/
addpath utility/
close all
load data/controlers/FullControlerAutoregulatedModelControler.mat
build = ModelFactory;
M=1;
range=logspace(2,4,N);
scaleFactor = range(index);
controlerInput=controlInput*scaleFactor;
controlerInput(500,500)=0;
model=build.khammashAutoregModel2WithControlInput(controlerInput);
ssa=SolverSSA(model);
ssa.model.time=linspace(0,20000,40000);
dataSSA=ssa.run(M);

end