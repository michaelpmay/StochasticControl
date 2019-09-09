classdef Strategy
  properties
    solver
    model
  end
  methods
    function obj=Solver(solver,model)
      obj.solver=solver;
      obj.model=model;
    end
    function data=run(obj)
      obj.solver.model=obj.model;
      data=obj.solver.run;
    end
    function [obj,error]=accept(obj,visitor)
      [obj,error]=visitor.visit(obj);
    end
  end
end