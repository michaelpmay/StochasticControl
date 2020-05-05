classdef KhammashParameterOptimizer < ParameterOptimizer
  methods
    function error=getError(obj,index)
      data=obj.solver.run;
      modelData=data.state(index,:);
      error=sum((obj.realData.state(6:end)-modelData(6:end)).^2);
    end
  end
end