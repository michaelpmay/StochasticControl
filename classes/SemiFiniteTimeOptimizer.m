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
      initialState=obj.getInitialState;
      initialControler=obj.getInitialControler;
      N=length(obj.tauSpace);
      for i=1:N
        printLoopIterations(i,N);
        u{i}=obj.optimizeUForSingleTau(obj.tauSpace(i),initialState,initialControler);
      end
    end
    function u=parallelOptimize(obj)
      initialState=obj.getInitialState;
      initialControler=obj.getInitialControler;
      N=length(obj.tauSpace);
      menu=ParallelMenu;
      for i=1:N
        menu=menu.attachTicketItem(@obj.optimizeUForSingleTau,{obj.tauSpace(i),initialState,initialControler})
      end
      u=menu.run
    end
    function u=optimizeUForSingleTau(obj,tau,initialState,initialControler)
      u=initialControler;
      obj.modelFsp.model.controlInput=u;
      rate=obj.initialRate;
      for i=1:obj.numIterations
        u=obj.stepToNewControler(u,tau,initialState,rate);
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
            obj.partialElements{i,j}=L*obj.partialElements{i-1,1}/(i);
          else
            obj.partialElements{i,j}=obj.partialElements{i-1,j}*L/(i);
          end
        end
      end
    end
    function stateGenerator=getStateGenerator(obj,controlInput,tau)
      A=obj.modelFsp.generator.getAMatrix;
      B=obj.modelFsp.generator.getBMatrix;
      Bu=B.*controlInput(:);
      A=sparse(A);
      Bu=sparse(Bu);
      L=A+Bu;
      stateGenerator=expm(L*tau);
    end
    function initialControler=getInitialControler(obj)
      initialControler=ones(obj.dims)*obj.initialInputLevel;
    end
    function initialState=getInitialState(obj)
      initialState=obj.getSteadyState;
    end
    function tauVector=convergenceLine(obj,tau,tolerance)
      tauVector=[tau]
      i=1;
      while tauVector(end)>tolerance
        tauVector(end+1)=tau^i/factorial(i);
        i=i+1;
      end
    end
  end
end