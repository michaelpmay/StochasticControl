classdef ModelPlugin
  properties
    parameters
    rxnRate=@(t,x,p)[]
    stoichMatrix
    initialState
    time
  end
  methods
    function obj=setParameters(obj,parameters)
      obj.parameters=parameters;
    end
    function parameters=getParameters(obj)
      parameters=obj.parameters;
    end
    function rxnRate=getRxnRate(obj)
      rxnRate=obj.rxnRate;
    end
    function stoichMat=getStoichMat(obj)
      stoichMat=obj.stoichMatrix;
    end
    function rate=getRateEquation(obj)
      rate=@(t,x)obj.stoichMatrix*obj.rxnRate(t,x,obj.parameters);
    end
    function propensity=evaluateRateEquation(obj,t,x)
      propensity=obj.rxnRate(t,x,obj.parameters);
    end
  end
end