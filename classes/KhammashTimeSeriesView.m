classdef KhammashTimeSeriesView
  properties
    axes
    realView
    modelView
  end
  methods
    function obj=KhammashTimeSeriesView(solver,axes)
      obj.realView=obj.getRealODEView(axes);
      obj.modelView=obj.getModelODEView(solver,axes);
    end
    function realView=getRealODEView(obj,axes)
      realView=ViewODE(KhammashTimeSeriesData(),axes);
    end
    function modelView=getModelODEView(obj,solver,axes)    
      data=solver.run;
      modelView=ViewODE(data,axes);
    end
    function plotTimeSeries(obj)
      hold on
      obj.realView.plotTimeSeriesScatter(1);
      obj.modelView.plotTimeSeries(1);
      hold off
    end
  end
end