classdef ErrorCalcSSE
  properties
    
  end
  methods
    function error=getError(obj,data1,data2,scale)
      error=scale*sum((data1-data2).^2);
    end
  end
end