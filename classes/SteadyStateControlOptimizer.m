classdef SteadyStateControlOptimizer
  properties
    maxControlerBounds=10
    minControlerBounds=.000001
    numIterations=50
    initialControler=[]
    modelFsp
    score
  end
  methods
    function [modelFsp,obj]=visit(obj,modelFsp)
      obj.modelFsp=modelFsp;
      obj.score=ProbabilityScore(modelFsp.dims);
      [modelFsp,obj]=obj.optimizeControler();
    end
    function obj=setControl(obj,controler)
      controler=obj.setBounds(controler);
      obj.modelFsp.model.controlInput=controler;
      obj.modelFsp.model.controlInput=controler;
    end
    function obj=initializeControlInput(obj,level)
      obj=obj.setControl(obj.initialControler);
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