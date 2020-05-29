classdef GenericCMEData < PrintObjects
  % stores state and time data and has a few simple plot methods
  properties
    time
    state
    meta
  end
  methods
    function obj=GenericCMEData(varargin)
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
    function save(obj,fileName)
      saveObject=obj.getSaveState();
      save(filename,saveObject);
    end
    function object=getSaveState(obj)
      object.time=obj.time;
      object.state=obj.state;
      object.meta=meta;
    end
    function obj=loadSaveState(obj,object)
      obj.time=object.time;
      obj.state=object.state;
      obj.meta=object.meta;
    end
  end
end
