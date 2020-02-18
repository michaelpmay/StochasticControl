close all
histeresisFigure=openfig('figures/Histeresis.fig','reuse');
ax0=gca;
seesawFigure=openfig('figures/SeeSawInput.fig','reuse');
ax1=gca;
atregFrequencyFigure=openfig('figures/AutoReglatedFrequency.fig','reuse');
ax2=gca;
unregFrequencyFigure=openfig('figures/UnregulatedFrequency.fig','reuse');
ax3=gca;
Figure=AcademicFigure;
s0=subplot(1,2,1);
s1=subplot(3,2,2);
s2=subplot(3,2,4);
s3=subplot(3,2,6);
copyobj(get(ax0,'children'),s0)
copyobj(get(ax1,'children'),s1)
copyobj(get(ax2,'children'),s2)
copyobj(get(ax3,'children'),s3)