function setFigureXRange(xRange)
fig=gcf;
axes=fig.Children;
set(axes,'XLim',xRange);
end