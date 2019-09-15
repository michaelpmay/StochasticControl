classdef JointTimeOptimizer
  properties
    model
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
      ssa=obj.initializeSsa(model);
      jointFsp=obj.initializeJointFsp(model);
      singleFsp=obj.intializeSingularFSP(model)
      initialTarget=obj.initialState(1);
      initialNonTarget=obj.deltaDistribution(obj.initialState(2));
      initialJointDistribution=obj.makeJointDistribution(initialTarget,initialNonTarget)
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
    function ssa=initializeSsa(obj,model)
      ssa=SolverSSA(model);
      ssa.model.initialState=obj.initialState(1);
    end
    function fsp=initializeJointFsp(obj,model)
      fsp=TwoCellFSP(model);
      obj.score=ProbabilityScore(obj);
    end
    function sFsp=initializeSingularFsp(obj,model)
      
    end
    function getJointDistribution(obj,ssaState,probability)
      probability=zeros(size(model.dims))
    end
  end
end