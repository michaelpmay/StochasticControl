function [t] = LabelPlot(label)
t = annotation('textbox');
xl = xlim(); 
yl = ylim(); 
dx=diff(xl);
dy=diff(yl);
[x1,y1]=axxy2figxy(0, yl(2));
[x2,y2]=axxy2figxy(.3*dx,yl(2)-.3*dy);
delx=x2-x1;
dely=y1-y2;
position=get(gcf,'Position');
delxx=delx*position(3);
delyy=delx*position(4);
[del,minInd]=min([delxx,delyy,32]);
delx=del/position(3);
dely=del/position(4);
t.Position=[x1 y1-dely  delx dely];
t.HorizontalAlignment='center';
t.VerticalAlignment ='middle';
t.FontName='Helveteca';
t.FontWeight='Bold';
t.String=label;
t.EdgeColor='none';
t.FontSize=20;
end

