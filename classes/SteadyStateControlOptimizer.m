classdef SteadyStateControlOptimizer
  properties
    modelFsp
    score
    controlInput
    maxControlerBounds=10
    minControlerBounds=00
    numIterations=50
    initialInputLevel=.8
    dims=[50 50]
  end
  methods
    function [modelFsp,obj]=visit(obj,modelFsp)
      obj.modelFsp=modelFsp;
      obj.score=ProbabilityScore(modelFsp.model);
      [modelFsp,obj]=obj.optimizeControler();
    end
    function obj=setControl(obj,controler)
      controler=obj.setBounds(controler);
      obj.controlInput=controler;
      obj.modelFsp.model.controlInput=controler;
    end
    function obj=initializeControlInput(obj,level)
      obj=obj.setControl(level*ones(obj.modelFsp.model.dims));
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
      steadyState=obj.modelFsp.getSteadyState();
    end
    function C=getC(obj)
      C=obj.score.C;
    end
  end
end