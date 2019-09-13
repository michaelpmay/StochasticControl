classdef JointTimeOptimizer
  properties
    modelSsa
    modelFsp
    score
    uRange
    initialState=[5 5]
    time
    initialU
    dims=[50 50]
  end
  properties(Hidden)
    generator
  end
  methods
    function obj=JointTimeOptimizer()
      
    end
    function modelSsa=optimize(obj,model)
      obj=obj.initializeModelSsa(model);
      obj=obj.initializeModelFsp(model);
      for i=1:length(obj.time)
        [u,minModel]=obj.getDynamicU();
        minModel.time=[obj.time(i),obj.time(i+1)]
        minModel.a
      % step to new time using u
      end
     
    end
    function [u,minModel]=getDynamicU(obj)
      n=length(obj.uRange);
      obj.uRange=[-.05 0 +.05];
      for i=1:length(obj.uRange)
        tempModel(i)=obj.modelFsp;
        tempModel(i).controlInput=tempModel(i).controlInput(Q+1)+obj.uRange(i);
        dynamicScore(i)=obj.getDyanamicScore(tempModel(i));
      end
      [~,minIndex]=min(dynamicScore);
      u=obj.uRange(minIndex);
      minModel=tempModel(minIndex);
    end
    function score=getDyanamicScore(obj,modelfsp)
      infGenerator=obj.getInfGenerator(modelfsp);
      score=obj.score.getDynamicScore(probability,infGenerator);
    end
    function obj=initializeModelSsa(obj,model)
      obj.modelSsa=SolverSSA(model);
      obj.modelSsa.model.initialState=obj.initialState(1);
    end
    function obj=initializeModelFsp(obj,model)
      obj.generator=FSPGenerator1D();
      obj.generator.model=model
      obj.generator.dims=obj.dims
      obj.modelFsp=TwoCellFSP(model);
      obj.score=ProbabilityScore(obj);
    end
    function getJointDistribution(obj,ssaState,probability)
      probability=zeros(size(model.dims))
    end
  end
end