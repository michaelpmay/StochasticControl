classdef AlphaTimeControlOptimizer
  properties
    modelFsp
    score
    generator
    initialControler
    minBounds
    maxBounds
    dims=[50 50]
  end
  properties(Hidden)
    stateGenerators
  end
  methods
    function obj=AlphaTimeControlOptimizer(obj,modelFsp)
      obj.modelFsp=modelFsp;
      obj.score=ProbabilityScore(obj.modelFsp);
      obj.generator=TwoCellFSPGenerator(obj.modelFsp.model,obj.dims);
      obj.time=linspace(1,10,100);
      obj.initialControler=ones(obj.dims)*.3;
      obj.minBounds=0;
      obj.maxBounds=50;
    end
    function modelFsp=getOptimumModelFsp(obj)
      build=ModelFactory;
      modelFsp=build.optimizedTwoCellModel;
    end
    function optimize(obj)
      ssControler=obj.getOptimalControler;
      modelFsp=obj.modelFsp;
      modelFsp.controler=obj.initialControler;
      probability=modelFsp.getSteadyState;
      for i=1:length(obj.time)
        model=obj.stepToNewControler(model,control,probability,rate,alpha)
        obj=obj.stepToNewTime(model);
        controler=[]%updateControler
        probability=[]%updatePRobability
      end
    end
    function controlInput=getOptimalControler(obj)
      load inFiles/controlInput.mat
    end
    function model=stepToNewControler(obj,model,probability,rate,alpha)
      grad=obj.getGreedyGrad(model,probabilty);
      grad=obj.mixGrad(grad,controlInput);
      grad=obj.trimGrad(grad);
      load('inFiles/controlInput.mat');
      
      model.controlInput=model.controlInput-grad*stepRate;
    end
    function grad=getGreedyGrad(obj,model,probability)
      A=obj.generator.getInfGenerator(model.controlInput);
      grad=obj.score.c(:)'*A*probability(:);
    end
    function grad=trimGrad(obj,grad)
      grad(grad<obj.minBounds)=obj.minBounds;
      grad(grad>obj.maxBounds)=obj.maxBounds;
    end
    function grad=mixGrad(obj,grad1,grad2,alpha)
      grad=alpha*grad1+(1-alpha)*grad2;
    end
    function stepToNewTime(obj,model)
      
    end
  end
end