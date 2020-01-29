classdef SimpleFeedbackControlArray < ControlInputArray
  properties
    ssInput
  end
  methods
    function input=getInput(obj,error)
      input=obj.array*error(:)+obj.ssInput(:);
      input=obj.trim(input);
    end
  end
end