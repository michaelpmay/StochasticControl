classdef ProbabilityScore
  properties
    target=[30; 10] 
    sigma=[1 0;0 1]
    C
  end
  methods
    function obj=ProbabilityScore(model)
      obj.C=obj.makeC(model);
    end
    function score=getScore(obj,P)
      score=obj.C'*P(:);
    end
    function C=makeC(obj,model)
      xv=0:(model.dims(1)-1);
      yv=0:(model.dims(2)-1);
      for i=1:length(xv)
        for j=1:length(yv)
          C(i,j)=([xv(i),yv(j)]'-obj.target)'*...
            obj.sigma*([xv(i),yv(j)]'-obj.target);
        end
      end
      C=C(:);
    end
    function obj=setTarget(obj,target,model)
      obj.target=target;
      obj.C=obj.makeC(model);
    end
    function obj=setSigma(obj,sigma,model)
      obj.sigma=sigma;
      obj.C=obj.makeC(model);
    end
  end
end