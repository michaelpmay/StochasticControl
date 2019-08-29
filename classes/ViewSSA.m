classdef ViewSSA
  properties
    data
    axes
  end
  methods
    
    function obj=ViewSSA(data,axes)
      obj.data=data;
      obj.axes=axes;
    end
    
    function plotAllTimeSeries(obj,speciesIndex)
      for i = 1:obj.data.length()
        hold on
        obj.plotTimeSeries(speciesIndex,i)
        hold off
      end
    end
    
    function plotTimeSeries(obj,speciesIndex,sampleIndex)
      timeSeriesData=obj.data.getTimeSeries(speciesIndex,sampleIndex)
      stairs(timeSeriesData.time,timeSeriesData.state);
    end
    function plotTimeSeriesScatter(obj,speciesIndex,sampleIndex)
      timeSeriesData=obj.data.getTimeSeries(speciesIndex,sampleIndex)
      scatter(timeSeriesData.time,timeSeriesData.state);
    end
    function plotTimeSeriesHistogram(obj,speciesIndex,timeIndex,nbins)
      timeSeriesData=obj.data.getTimeSeries(speciesIndex,timeIndex);
      hist(timeSeriesData.state,nbins,obj.axes)
    end
    function plotSnapshotHistogram(obj,speciesIndex,timeIndex,nbins)
      snapshot=obj.data.getSnapshot(timeIndex,speciesIndex);
      hist(snapshot,nbins,obj.axes);
    end
    function plotWindowHistogram(obj,speciesIndex,initialTimeIndex,finalTimeIndex)
      [count,binEdge]=obj.data.getWindowHistogram(speciesIndex,initialTimeIndex,finalTimeIndex);
      bar(binEdge,count);
    end
  end
end