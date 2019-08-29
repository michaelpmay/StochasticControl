classdef ViewODE
  properties
    data
    axes
  end
  methods
    
    function obj=ViewODE(data,axes)
      obj.data=data;
      obj.axes=axes;
    end
     
    function plotTimeSeries(obj,speciesIndex)
      timeSeriesData=obj.data.getTimeSeries(speciesIndex)
      plot(timeSeriesData.time,timeSeriesData.state);
    end
    function plotTimeSeriesScatter(obj,speciesIndex)
      timeSeriesData=obj.data.getTimeSeries(speciesIndex);
      scatter(timeSeriesData.time,timeSeriesData.state);
    end
  end
end