classdef ParameterOptimizer
  properties
    data % data object must have state and time
    strategy = ParameterOptimizerPseudoRandom %optimization strategy
    index
  end
  methods
    function [solver,error]=visit(obj,solver)
      [solver,error]=obj.optimize(solver);
    end
    function [solver,error]=optimize(obj,solver)
      [solver,error]=obj.strategy.optimize(solver,obj.data,obj.index);
    end
  end
end