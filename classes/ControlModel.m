classdef ControlModel < ModelPlugin
  properties
    controlInput
  end
  methods
    function input=getInput(obj)
      input=obj.controlInput;
    end
  end
end