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
      hold on
      for i = 1:obj.data.length()
        obj.plotTimeSeries(speciesIndex,i)
      end
      hold off
    end  
    function plotTimeSeries(obj,speciesIndex,sampleIndex)
      timeSeriesData=obj.data.getTimeSeries(speciesIndex,sampleIndex)
      stairs(timeSeriesData.time,timeSeriesData.state);
      xlabel('time')
      ylabel('species count')
    end
    function plotTimeSeriesScatter(obj,speciesIndex,sampleIndex)
      timeSeriesData=obj.data.getTimeSeries(speciesIndex,sampleIndex)
      scatter(timeSeriesData.time,timeSeriesData.state);
      xlabel('time')
      ylabel('speciescount ')
    end
    function plotTimeSeriesHistogram(obj,speciesIndex,timeIndex,nbins)
      timeSeriesData=obj.data.getTimeSeries(speciesIndex,timeIndex);
      hist(timeSeriesData.state,nbins,obj.axes)
      ylabel('species count')
    end
    function plotSnapshotHistogram(obj,speciesIndex,timeIndexRange,nbins)
      snapshotData=[]
      for i=1:length(timeIndexRange)
        snapshot=obj.data.getSnapshot(timeIndexRange(i),speciesIndex);
        snapshotData=[snapshotData,snapshot.state];
      end
      histogram(obj.axes,snapshotData,nbins,'Normalization','probability');
    end
    function plotWindowHistogram(obj,speciesIndex,initialTimeIndex,finalTimeIndex)
      [count,binEdge]=obj.data.getWindowHistogram(speciesIndex,initialTimeIndex,finalTimeIndex);
      bar(binEdge,count);
    end
    function plotAll(obj)
      hold on
      for i=1:obj.data.length
        data=obj.data.getAllTimeSeries(i);
        stairs(data.time,data.state');
      end
    end
  end
end