classdef StateSpaceControl
  properties
    field
  end
  methods
    function obj=StateSpaceInput(field)
      obj.field=field;
    end
    function input=getInput(obj)
      input=@(t,x)field(x+1)
    end
  end
end