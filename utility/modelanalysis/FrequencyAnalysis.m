classdef FrequencyAnalysis < MixInParameters
  properties
    model
  end
  methods
    function odeData=run(obj)
      modelOde=obj.getModel();
      ode=GenericODE(obj.model);
      odeData=ode.run;
    end
    function input=getFrequencyInput(obj)
      input=@(x,t,u)obj.intensity*(sin(obj.frequency*pi*t).^2);
    end
  end
end