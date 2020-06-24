classdef SaveAsDataM
  properties
  end
  
  methods
    function save(obj,data,fileName)
      time=data.time;
      state=data.state;
      save(fileName,'time','state');
    end
  end
end
