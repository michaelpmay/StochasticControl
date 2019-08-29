classdef ControlOptimizer
  properties
    model
    C
    target=[40;5]
    sigma=[1 0;
      0 1]
    score
    controlInput
    maxControlerBounds=10
    minControlerBounds=00
    numIterations=50
    initialInputLevel=.8
    dims=[50 50]
  end
  methods
    function [model,obj]=visit(obj,model)
      obj.model=model;
      [model,obj]=obj.optimizeControler();
    end
    function obj=setControl(obj,controler)
      controler=obj.setBounds(controler);
      obj.controlInput=controler;
      obj.model.controlInput=controler;
    end
    function obj=initializeControlInput(obj,level)
      obj=obj.setControl(level*ones(obj.model.dims));
    end
    function boundedControler=setBounds(obj,controler)
      controler(controler>obj.maxControlerBounds)=obj.maxControlerBounds;
      controler(controler<obj.minControlerBounds)=obj.minControlerBounds;
      boundedControler=controler;
    end
    function C=getC(obj)
      xv=0:(obj.model.dims(1)-1);
      yv=0:(obj.model.dims(2)-1);
      for i=1:length(xv)
        for j=1:length(yv)
          %C(i,j)=norm([i,j]-mu);
          C(i,j)=([xv(i),yv(j)]'-obj.target)'*...
            obj.sigma*([xv(i),yv(j)]'-obj.target);
        end
      end
      C=C(:);
    end
    function score=getScore(obj)
      steadyStateProbability=obj.getSteadyState();
      score=obj.C'*steadyStateProbability(:);
    end
    function steadyState=getSteadyState(obj)
      obj=obj.setControl(obj.controlInput);
      steadyState=obj.model.getSteadyState();
    end
  end
end