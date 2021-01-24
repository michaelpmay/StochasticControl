addpath(genpath('utility'))
clear all
titleFontSize=14;
factory=ModelFactory
aModel=factory.autoregulatedModelWithoutInput()
uModel=factory.unregulatedModelWithoutInput()

uuControler=load('data/controlers/UniformControlerUnegulatedModelControler.mat')
ufControler=load('data/controlers/FullControlerUnregulatedModelControler.mat')
auControler=load('data/controlers/UniformControlerAutoregulatedModelControler.mat')
afControler=load('data/controlers/FullControlerAutoregulatedModelControler.mat')

uuModel=uModel;
uuModel.controlInput=uuControler.controlInput;
ufModel=uModel;
ufModel.controlInput=ufControler.controlInput;
auModel=aModel;
auModel.controlInput=auControler.controlInput;
afModel=aModel;
afModel.controlInput=afControler.controlInput;

dims=[50 50]
uuFsp=TwoCellFSP(uuModel,dims);
ufFsp=TwoCellFSP(ufModel,dims);
auFsp=TwoCellFSP(auModel,dims);
afFsp=TwoCellFSP(afModel,dims);

target=[30 10];
AcademicFigure()
ax{1}=plotModel(uuFsp,1,target)

ax{2}=plotModel(ufFsp,2,target)

ax{3}=plotModel(auFsp,3,target)

ax{4}=plotModel(afFsp,4,target)

axes(ax{1}(1))
title({'RUM-UC'},'Fontsize',titleFontSize)
axes(ax{2}(1))
title({'RUM-FC'},'Fontsize',titleFontSize)
axes(ax{3}(1))
title({'RAM-UC'},'Fontsize',titleFontSize)
axes(ax{4}(1))
title({'RAM-FC'},'Fontsize',titleFontSize)

axes(ax{1}(1))
xlabel('Species Count')
ylabel('Species Count')
axes(ax{1}(2))
xlabel('Species Count')
ylabel('Species Count')
axes(ax{1}(3))
xlabel('Species Count')
ylabel('Probability')
axes(ax{4}(3))
lgnd=legend('Target','Non-Target')
lgnd.Position=[0.8673    0.1555    0.1109    0.0537]
function ax=plotModel(model,colNum,target)
subplotIndex=[0 4 8];
gap=[.07 .015];
width=[.06 .08];
height=[.06 .08];
view=ViewTwoCellFSP(model,subtightplot(3,4,subplotIndex(1)+colNum,gap,width,height));
ax(1)=view.plotSampledSumForces(4);
caxis([0 2.5]);
if colNum~=1
  set(gca,'xticklabel',[])
  set(gca,'yticklabel',[])
end
if colNum==4
  cbar1=colorbar
  cbar1.Position=[0.9246   0.6800    0.0152    0.2400]
end
view=ViewTwoCellFSP(model,subtightplot(3,4,subplotIndex(2)+colNum,gap,width,height));
ax(2)=view.plotSteadyStateWithTarget(target);
if colNum~=1
  set(gca,'xticklabel',[])
  set(gca,'yticklabel',[])
end
if colNum==4
  cbar2=colorbar
  cbar2.Position=[0.9246    0.3700    0.0152    0.2400];
end
caxis([0 .04])
view=ViewTwoCellFSP(model,subtightplot(3,4,subplotIndex(3)+colNum,gap,width,height));
ax(3)=view.plotMarginals();
if colNum~=1
  set(gca,'xticklabel',[])
  set(gca,'yticklabel',[])
end
scorer=ProbabilityScore([50 50])
probability=ax(2).Children(2).CData;
score=scorer.getScore(probability);
text(32,.12,sprintf('J= %.0f',score),'FontSize',14,'FontWeight','bold');
ylim([0,.15])
xlim([0 50])
ax(3).YGrid='on';
hold on
plot([30 30],[0 .15],'r--')
plot(30,0,'rp','Markersize',10,'MarkerFaceColor' ,'red')
plot([10 10],[0 .15],'b--')
plot(10,0,'bp','Markersize',10,'MarkerFaceColor','blue')
box on
end