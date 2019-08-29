classdef FrequencyAnalysis
  properties
    model
    frequency
    intensity
  end
  methods
    function obj=FrequencyAnalysis(model)
      obj.model=model;
    end
    function odeData=run(obj)
      obj.model.input=obj.getFrequencyInput;
      ode=GenericODE(obj.model);
      odeData=ode.run;
    end
    function input=getFrequencyInput(obj)
      input=@(x,t,u)obj.intensity*(sin(obj.frequency*pi*t).^2);
    end
    
  end
end