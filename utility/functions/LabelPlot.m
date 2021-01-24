function [t] = LabelPlot(label)
t = annotation('textbox');
xl = xlim(); 
yl = ylim(); 
dx=diff(xl);
dy=diff(yl);
[x1,y1]=axxy2figxy(xl(1), yl(2));
del=.1;
position=get(gcf,'Position');
delx=del*position(3);
dely=del*position(4);
del=min([delx,dely]);
del=min([del,40]);
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

