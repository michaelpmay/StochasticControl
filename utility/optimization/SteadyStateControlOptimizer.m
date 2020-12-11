classdef SteadyStateControlOptimizer
  properties
    maxControlerBounds=600
    minControlerBounds=.000001
    numIterations=50
    modelFsp
    score
    target=[30 10];
  end
  methods
    function [modelFsp,obj]=visit(obj,modelFsp)
      obj.modelFsp=modelFsp;
      obj.score=ProbabilityScore(modelFsp.dims);
      obj.score.target=obj.target;
      [modelFsp,obj]=obj.optimizeControler();
    end
    function obj=setControl(obj,controler)
      controler=obj.setBounds(controler);
      obj.modelFsp.model.controlInput=controler;
      obj.modelFsp.model.controlInput=controler;
    end
    function boundedControler=setBounds(obj,controler)
      controler(controler>obj.maxControlerBounds)=obj.maxControlerBounds;
      controler(controler<obj.minControlerBounds)=obj.minControlerBounds;
      boundedControler=controler;
    end
    function score=getScore(obj)
      steadyStateProbability=obj.getSteadyState();
      score=obj.score.getScore(steadyStateProbability(:));
    end
    function steadyState=getSteadyState(obj)
      obj=obj.setControl(obj.modelFsp.model.controlInput);
      steadyState=obj.modelFsp.getSteadyState();
    end
    function C=getC(obj)
      C=obj.score.C;
    end
  end
end