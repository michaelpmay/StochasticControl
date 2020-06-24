classdef ModelData < PrintObjects
  % stores state and time data and has a few simple plot methods
  properties
    time
    state
    meta
  end
  methods
    function obj=ModelData(varargin)
      if nargin==0
        
      elseif nargin==2
        obj.time=varargin{1};
        obj.state=varargin{2};
      else
        obj.time=varargin{1};
      	obj.state=varargin{2};
        obj.meta=varargin{3};
      end
    end
    function timeSeriesData=getTimeSeries(obj,speciesIndex)
      timeSeriesData.time=obj.time;
      timeSeriesData.state=obj.state(speciesIndex,:);
    end
    function obj=trimInitial(obj,timeIndex)
      obj.time=obj.time(timeIndex:end);
      obj.state=obj.state(timeIndex:end);
    end
    function save(obj,filename)
      saver=DataSaver;
      saver.save(obj,filename);
    end
  end
end
