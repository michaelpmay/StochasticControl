classdef KhammashTimeSeriesView
  properties
    axes
    realView
    modelView
    startTime=270
    scale=20
  end
  methods
    function obj=KhammashTimeSeriesView(solver,axes)
      obj.realView=obj.getRealODEView(axes);
      obj.modelView=obj.getModelODEView(solver,axes);
    end
    function realView=getRealODEView(obj,axes)
      realView=ViewODE(TrimKhammashTimeSeriesData(),axes);
    end
    function view=getScaledView(obj,axes)
      data=TrimKhammashTimeSeriesData();
      data.state=data.state/data.state(1)*obj.scale;
      view=ViewODE(data,obj.axes);
    end
    function modelView=getModelODEView(obj,solver,axes)    
      data=solver.run;
      N=sum(data.time<=obj.startTime);
      data.time=data.time(N:end);
      data.time=data.time-data.time(1);
      data.state=data.state(N:end);
      modelView=ViewODE(data,axes);
    end
    function plotTimeSeries(obj)
      scaleView=obj.getScaledView();
      hold on
      yyaxis left
      obj.realView.plotTimeSeriesScatter(1);
      yyaxis right
      scaleView.plotTimeSeriesScatter(1);
      yyaxis left
      obj.modelView.plotTimeSeries(1);
      hold off
    end
  end
end