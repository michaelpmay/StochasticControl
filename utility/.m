classdef SeparateEquationModelPlugin < ModelPlugin
  properties
    production
    degredation
    input
  end
  methods
    function obj=SeparateEquationModelPlugin()
      obj.rxnRate=obj.getRxnRate();
    end
    function obj=setProductionRate(obj,equation)
      obj.production=equation;
      obj=obj.getRxnRate;
    end
    function obj=setDegredationRate(obj,equation)
      obj.degredation=equation;
      obj=obj.getRxnRate;
    end
    function obj=setInput(obj,equation)
      obj.input=equation;
      obj=obj.getRxnRate;
    end
    function rate=getProductionRate(obj)
      rate=obj.production;
    end
    function rate=getDegredationRate(obj)
      rate=obj.degredation;
    end
    function rate=getInput(obj)
      rate=obj.input;
    end
    function rate=getRxnRate(obj)
      rate=@(t,x)[obj.production(x)+obj.input(t,x);obj.degredation(x)]
    end
  end
end