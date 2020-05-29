classdef ParameterOptimizer
  properties
    solver %CME solver
    data % data object must have state and time
    optimizer = ParameterOptimizerPseudoRandom %optimization strategy
    index=1
  end
  methods
    function [solver,error]=visit(obj,solver)
      [solver,error]=obj.optimize(solver);
    end
    function [solver,error]=optimize(obj,solver)
      [solver,error]=obj.optimizer.optimize(solver,obj.data,obj.index)
    end
  end
end