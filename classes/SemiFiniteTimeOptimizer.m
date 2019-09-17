classdef SemiFiniteTimeOptimizer < GradientControlerOptimizer
  properties
    tauSpace=.1:.1:5
    partialElements
    maxElements=20;
  end
  methods
    function obj=SemiFiniteTimeOptimizer(modelFsp)
      obj.modelFsp=modelFsp;
      obj.score=ProbabilityScore(modelFsp);
      obj.dims=obj.modelFsp.dims;
    end
    function u=optimize(obj)
      obj=obj.updatePartialElements(obj.modelFsp.model.controlInput);
      for i=1:length(obj.tauSpace)
        u{i}=obj.optimizeUForSingleTau(obj.tauSpace(i));
      end
    end
    function u=optimizeUForSingleTau(obj,tau)
      u=ones(obj.dims)*obj.initialInputLevel;
      obj.modelFsp.model.controlInput=u;
      probability=obj.getSteadyState;
      rate=obj.initialRate;
      for i=1:obj.numIterations
        u=obj.stepToNewControler(u,tau,probability,rate);
        rate=rate*obj.decrement;
      end
    end
    function u=stepToNewControler(obj,u,tau,probability,rate)
      gradU=obj.getGrad(u,tau,probability);
      u=u+rate*gradU;
      u=obj.setBounds(u);
    end
    function gradU=getGrad(obj,u,tau,probability)
      obj=obj.updatePartialElements(u(:));
      grad=zeros(prod(obj.modelFsp.dims),prod(obj.modelFsp.dims));
      for i=1:obj.maxElements
        for j=1:i
          grad=grad+obj.partialElements{i,j}*tau^i;
        end
      end
      gradU=obj.score.C'*(grad.*probability(:));
      gradU=reshape(gradU,obj.dims);
    end
    function obj=updatePartialElements(obj,controlInput)
      A=obj.modelFsp.generator.getAMatrix;
      B=obj.modelFsp.generator.getBMatrix;
      Bu=B.*controlInput(:);
      A=sparse(A);
      Bu=sparse(Bu);
      L=A+Bu;
      obj.partialElements=cell(obj.maxElements);
      obj.partialElements{1,1}=B;
      for i=2:obj.maxElements
        for j=1:i
          if i==j
            obj.partialElements{i,j}=L^(i-1)*B/factorial(i);
          else
            obj.partialElements{i,j}=obj.partialElements{i-1,j}*L/(i);
          end
        end
      end
    end
  end
end