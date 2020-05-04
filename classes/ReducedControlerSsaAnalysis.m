classdef ReducedControlerSsaAnalysis
  properties
    model%must be a reduced dim model
  end
  methods
    function obj=ReducedControlerSsaAnalysis(model)
      obj.model=model;
    end
    function analysis=analyze(obj)
      ssa=SolverSSA(obj.model);
      analysis=ssa.run;
    end
  end
end