classdef SolverSSA 
  properties
    model
    integrator=SSAIntegratorParsed
  end
  methods Private
    function obj=SolverSSA(modelPlugin)
      try
      obj.model=modelPlugin;
      catch
      end
    end
    function data=run(obj,varargin)
      data=obj.integrator.integrate(obj.model);
    end
  end
end

