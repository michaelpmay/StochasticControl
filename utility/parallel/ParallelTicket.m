classdef ParallelTicket
  properties
    runable
    input
  end
  methods
    function obj=ParallelTicket(runable,input)
      obj.runable=runable;
      obj.input=input;
    end
    function output=run(obj)
      output=obj.runable(obj.input{:});
    end
  end
end