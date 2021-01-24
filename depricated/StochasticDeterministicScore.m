addpath(genpath('utility/'))
build=ModelFactoryTestModels
model=build.autoregulatedModelWithUniformLight(.4)
ssa=SolverSSA(model)
ode=SolverODE(model)

ssaData=ssa.run
odeData=ode.run
AcademicFigure
subplot(1,2,1)
hold on
plot(ssaData.node{1}.time,ssaData.node{1}.state,'Linewidth',3)
plot(odeData.time,odeData.state,'Linewidth',3)
plot(odeData.time,ones(size(odeData.time))*30,'r--','Linewidth',3)
xlabel('time (minutes)')
ylabel('Species Count')

ax2=subplot(1,2,2)
score=ProbabilityScore([50 50])
pcolorProbability(score.makeCMatrix([50 50]))
cmap=bone;
colormap(ax2,cmap(90:end,:))
colorbar()
hold on
plot([20 10],[5 30],'k.-.','Linewidth',3,'MarkerSize',36)
plot([10],30,'r.','MarkerSize',36)
plot(20,5,'b.','MarkerSize',36)
xlabel('Species Count')
ylabel('Species Count')
