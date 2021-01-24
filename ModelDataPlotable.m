classdef ModelDataPlotable < Plotable
  methods
    function data=Plotable(data)
      obj.data=data
    end
    function obj=line(obj,ax,varargin)
      obj.plotFunction=@()plot(ax,obj.data.time,obj.data.state,varargin{:})
    end
    function obj=stair(obj)
      obj.plotFunction=@()stair(ax,obj.data.time,obj.data.state,varargin{:})
    end
    function obj=area(obj)
      obj.plotFunction=@()stair(ax,obj.data.time,obj.data.state,varargin{:})
    end
    function obj=histogram(obj)
      obj.plotFunction=@()stair(ax,obj.data.time,obj.data.state,varargin{:})
    end
    
  end
end