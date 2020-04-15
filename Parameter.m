classdef Parameter
  properties
    name
    value
  end
  methods
    function obj=Parameter(name,value)
      obj.name=string(name);
      obj.value=value;
    end
    function value=getValue(obj)
      value=obj.value;
    end
    function name=getName(obj)
      name=obj.name;
    end
    function obj=setValue(obj,value)
      obj.value=value;
    end
  end
end