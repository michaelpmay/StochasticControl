classdef SemiFiniteTimeOptimizer < GradientControlerOptimizer
  properties
    tauSpace=linspace(0,1,100)
  end
  methods
    function obj=SemiFiniteTimeOptimizer()
      
    end
    function optimize(obj)
      
    end
    function getGrad(obj,tau)
      A=obj.modelFsp.getInfGenerator;
      B=obj.modelFsp.getBTensor;
      alpha=obj.getAlpha(A,B,tau);
      beta=obj.getBeta(A,B,tau);
      gamma=obj.getGamma(A,B,tau);
      delta=obj.getDelta(A,B,tau);
      epsilon=obj.getEpsilon(A,B,tau);
      grad=obj.score.C(alpha+beta+gamma+delta+epsilon)*Po
    end
    function getPartialElements(obj,maxElements)
      for i=1:maxElements
        
      end
    end
  end
end