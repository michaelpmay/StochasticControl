classdef ModelPlugin
  %this object describes models for other objects to borrow from.
  properties
    parameters
    rxnRate=@(t,x,p)[]
    stoichMatrix
    initialState
    time
    name=''
    description=''
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
    function save(obj)
      mFormater=ModelMatFormater;
      mFormater.save(obj);
    end
    function model=load(obj)
      mFormater=ModelMatFormater;
      model=mFormater.load(obj);
    end
  end
end