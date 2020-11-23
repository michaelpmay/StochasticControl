clear all
addpath(genpath('utility'))
AcademicFigure
cMax=.011
controlMax=230;
gap=[.065 .01]
w=[.08 .08]
h=[.08 .08]
titleFontSize=14;
lineWidth=3;
cmap1=parula;
cmap2=hot;
cmap2=cmap2(15:end,:)
load makeFullUnregModelCalibratedLongTime_UniformControler.mat
[P,Px,Py,score]=getPlotingData(time,state);
subtightplot(3,5,1,gap,h,w);
ax=plotAll(P,Px,Py,score,controlInput,1);
axes(ax(1));
title('FUM-UC','Fontsize',titleFontSize);
ylabel('Species Count')
xlabel('Species Count')
xticks([0 20 40])
xticklabels({'0','20','40'})
yticks([0 10 20 30 40])
yticklabels({'0','10','20','30','40'})
axes(ax(2))
ylabel('Species Count')
xlabel('Species Count')
xticks([0 20 40])
xticklabels({'0','20','40'})
yticks([0 10 20 30 40])
yticklabels({'0','10','20','30','40'})
axes(ax(3))
ylabel('Probability')
xlabel('Species Count')
xticks([0 10 20 30 40 50])
xticklabels({'0' '10' '20' '30' '40' '50'})
yticks(0:.02:.12)
yticklabels({'0' '0.2' '0.4' '0.6' '0.8' '0.10' '0.12'})

load makeFullUnregModelCalibratedLongTime_FullControler.mat
[P,Px,Py,score]=getPlotingData(time,state)
plotAll(P,Px,Py,score,controlInput,2)
load makeFullAutoModelCalibratedLongTime_UniformControler.mat
[P,Px,Py,score]=getPlotingData(time,state)
plotAll(P,Px,Py,score,controlInput,3)
load makeFullAutoModelCalibratedLongTime_FullControler.mat
[P,Px,Py,score]=getPlotingData(time,state)
plotAll(P,Px,Py,score,controlInput,4)
load makeFullAutoModelCalibratedLongTime_ReducedControler.mat
[P,Px,Py,score]=getPlotingData(time,state)
ax=plotAll(P,Px,Py,score,controlInput,5)
axes(ax(1))
cbar1=colorbar()
cbar1.Position=[0.9288    0.6833    0.0111    0.2367]
axes(ax(2))
cbar2=colorbar()
cbar2.Position=[0.9288    0.3817    0.0111    0.2367]
axes(ax(3))
lgnd=legend('Target','Non-Target')
lgnd.Position=[0.8724    0.1440    0.1079    0.0504]

function [probability,Px,Py,score]=getPlotingData(time,state)
addpath(genpath('utility/'))
N=length(time);
targetState=[];
nonTargetState=[]
for k=1:N
  targetState=[targetState,[state{k}(5,2000:1:end)]];
  nonTargetState=[nonTargetState,[state{k}(10,2000:1:end)]];
end
probability=zeros(60);
for i=1:length(targetState)
  probability(targetState(i)+1,nonTargetState(i)+1)=probability(targetState(i)+1,nonTargetState(i)+1)+1;
end
probability=probability./(sum(sum(probability)));
Px=sum(probability,1);
Py=sum(probability,2);
scorer=ProbabilityScore([60 60])
score=scorer.getScore(probability);
end
function ax=plotAll(P,Px,Py,score,controlInput,index)
cMax=.011;
controlMax=230;
gap=[.065 .01]
w=[.05 .08]
h=[.065 .06]
titleFontSize=16;
lineWidth=3;
cmap1=parula;
cmap2=hot;
cmap2=cmap2(15:end,:);
ax(1)=subtightplot(3,5,index,gap,h,w)
pcolorProbability(controlInput(1:50,1:50));
caxis([0,controlMax])
colormap(gca,cmap1)
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
if index==1
title('FUM-CUC','Fontsize',titleFontSize)
elseif index==2
title('FUM-CFC','Fontsize',titleFontSize)
elseif index==3
  title('FAM-CUC','Fontsize',titleFontSize)
elseif index==4
  title('FAM-CFC','Fontsize',titleFontSize)
elseif index==5
  title('FAM-CRC','Fontsize',titleFontSize)
end
ax(2)=subtightplot(3,5,index+5,gap,h,w)
pcolorProbability(P);
caxis([0,cMax])
colormap(gca,cmap2)
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
hold on
blueX=scatter(10,30,30);
blueX.MarkerEdgeColor=[1 1 1];
blueX.LineWidth=2;
ax(3)=subtightplot(3,5,index+10,gap,h,w)
hold on
plot(0:59,Py,'b-','LineWidth',lineWidth)
plot(0:59,Px,'r-.','LineWidth',lineWidth)
hold on
t4=text(35,.1,sprintf('J= %.0f',score));
t4.FontSize=14;
t4.FontWeight='bold';
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
set(gca, 'YGrid', 'on')
plot([10 10],[0 .12],'r--')
plot(10,0,'rp','Markersize',10,'MarkerFaceColor' ,'red')
plot([30 30],[0 .12],'b--')
plot(30,0,'bp','Markersize',10,'MarkerFaceColor','blue')
ylim([0 .12])
box on
end