realData=KhammashTimeSeriesData()
fig=AcademicFigure();
[ax]=subplot(1,1,1);
myVisual=ViewODE(realData,ax);
myVisual.plotTimeSeriesScatter(1);
