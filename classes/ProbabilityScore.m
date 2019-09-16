classdef ProbabilityScore
  properties
    target=[30; 10] 
    sigma=[1 0;0 1]
    C
  end
  methods
    function obj=ProbabilityScore(modelfsp)
      obj.C=obj.makeC(modelfsp);
    end
    function score=getScore(obj,P)
      score=obj.C'*P(:);
    end
    function score=getDynamicScore(obj,P,stateGen)
      %score=obj.C'*infGen*P(:);
      score=obj.C'*stateGen*P;
    end
    function C=makeC(obj,modelFsp)
      xv=0:(modelFsp.dims(1)-1);
      yv=0:(modelFsp.dims(2)-1);
      C=preAllocateArray(length(xv),length(yv));
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