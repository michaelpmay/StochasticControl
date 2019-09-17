classdef SemiFiniteTimeOptimizer < GradientControlerOptimizer
  properties
    tauSpace=linspace(0,1,100)
    initialState
    partialElements
    maxElements=20;
  end
  methods
    function obj=SemiFiniteTimeOptimizer(modelFsp)
      obj.modelFsp=modelFsp;
      obj.score=ProbabilityScore(modelFsp);
      obj.dims=obj.modelFsp.dims;
    end
    function optimize(obj)
      obj=obj.updatePartialElements();
      for i=1:length(obj.tauSpace)
        u{i}=obj.optimizeUForSingleTau(obj.tauSpace(i));
      end
    end
    function u=optimizeUforSingleTau(obj)
      u=ones(obj.dims)*obj.initialInputLevel;
      tempModelFsp=obj.modelFsp;
      rate=obj.initialRate;
      for i=1:obj.numIterations
        u=obj.stepToNewControler(u,rate);
        obj=obj.updatePartialElements(u(:))
        rate=rate*obj.decrement;
      end
    end
    function u=stepToNewControler(obj,u,rate)
      gradU=obj.getGrad(u,tau);
      u=u+rate*gradU;
    end
    function gradU=getGrad(obj,u,tau)
      grad=preAllocateArray(obj.maxElements);
      for i=1:obj.maxElements
        for j=1:i
          grad=grad+obj.partialElements{i,j}*tau^i;
        end
      end
    end
    function obj=updatePartialElements(obj,controlInput)
      A=obj.modelFsp.generator.getAMatrix;
      Bu=obj.modelFsp.generator.getBMatrix.*controlInput(:)';
      A=sparse(A);
      Bu=sparse(Bu);
      obj.partialElements=cell(obj.maxElements);
      obj.partialElements{1,1}=Bu;
      for i=2:obj.maxElements
        for j=1:i
          if i==j
            obj.partialElements{i,j}=A^(i-1)*Bu/factorial(i);
          else
            obj.partialElements{i,j}=obj.partialElements{i-1,j}*A/factorial(i);
          end
        end
      end
    end
  end
end