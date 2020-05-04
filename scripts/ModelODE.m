classdef ModelODE < GenericODE
  properties
    parameters
    timeRange=[0,780]
    timeSteps=1000
    inputSignal
  end
  methods
    function obj=ModelODE(parameters)
      obj.parameters=parameters;
      obj.initialState=0;
      obj.time=linspace(obj.timeRange(1),obj.timeRange(2),obj.timeSteps)
      obj.stoichMatrix=[1,-1];
    end
    function rateEquation=getRateEquation(obj)
      productionRate=obj.parameters.getProductionRate()
      degredationRate=obj.parameters.getDegredationRate()
      rateEquation=@(t,x)productionRate(x)-degredationRate(x)+obj.inputSignal(t,x);
    end
  end
end