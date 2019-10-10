classdef SteadyStateControlOptimizer
  properties
    maxControlerBounds=10
    minControlerBounds=00
    numIterations=50
    initialInputLevel=.4
    dims=[50 50]
    modelFsp
    score
  end
  methods
    function [modelFsp,obj]=visit(obj,modelFsp)
      obj.modelFsp=modelFsp;
      obj.score=ProbabilityScore(obj.dims);
      [modelFsp,obj]=obj.optimizeControler();
    end
    function obj=setControl(obj,controler)
      controler=obj.setBounds(controler);
      obj.modelFsp.model.controlInput=controler;
      obj.modelFsp.model.controlInput=controler;
    end
    function obj=initializeControlInput(obj,level)
      obj=obj.setControl(level*ones(obj.modelFsp.dims));
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