load autoregulatedReducedControler_110gmres.mat
controlInput=ones(1,50).*controlInput
reducedScore=getFigure(controlInput);
load inFiles/controlInput.mat
fullScore=getFigure(controlInput)

function score=getFigure(controlInput)
build=ModelFactory;
build.optimizedTwoCellModel;
modelFsp=build.optimizedTwoCellModel;
modelFsp.model.controlInput=controlInput;
Pss=modelFsp.getSteadyStateReshape
xMarginal=sum(Pss,1);
yMarginal=sum(Pss,2);
figure
hold on
plot([0:49],xMarginal);
plot([0:49],yMarginal);
score=ProbabilityScore([50 50]);
score=score.getScore(Pss);
end