classdef UniformControlerOptimizer < ControlOptimizer
  properties
    range=[0,2]
  end
  methods
    function [model,obj]=optimizeControler(obj)
        obj.C=obj.getC;
        levelRange=linspace(obj.range(1),obj.range(2),obj.numIterations);
        scoreRange=preAllocateVector(obj.numIterations);
        for i=1:obj.numIterations
          obj=obj.initializeControlInput(levelRange(i));
          try
          scoreRange(i)=obj.getScore;
          catch
            scoreRange(i)=nan;
          end
        end
        [score,minIndex]=min(scoreRange);
        obj=obj.initializeControlInput(levelRange(minIndex));
        model=obj.model;
    end
    function obj=setControl(obj,controler)
      controler=obj.setBounds(controler);
      obj.controlInput=controler;
      obj.model.controlInput=controler;
    end
    function boundedControler=setBounds(obj,controler)
      controler(controler>obj.maxControlerBounds)=obj.maxControlerBounds;
      controler(controler<obj.minControlerBounds)=obj.minControlerBounds;
      boundedControler=controler;
    end
  end
end