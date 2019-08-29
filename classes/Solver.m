classdef Solver
  properties
    strategy
    model
  end
  methods
    function obj=Solver(strategy,model)
      obj.strategy=strategy;
      obj.model=model;
    end
    function data=run(obj)
      obj.strategy.model=obj.model;
      data=obj.strategy.run;
    end
    function [obj,error]=accept(obj,visitor)
      [obj,error]=visitor.visit(obj);
    end
  end
end