classdef GradientControlerOptimizer < SteadyStateControlOptimizer & PrintObjects
  properties
    gradCalc
    initialRate=1;
    minimumStep=.000005;
    decrement=.99
    saveInject=true;
    plotInject=true;
  end
  properties (Hidden)
    
  end
  methods
    function [optimizedModel,obj]=optimizeControler(obj)
      warning('MATLAB:eigs:IllConditionedA','off');
      obj.score=ProbabilityScore(obj.modelFsp.dims);
      obj=obj.initializeControlInput(obj.initialInputLevel);
      stepRate=obj.initialRate;
      for i=1:obj.numIterations
        obj=obj.stepToNewControler(stepRate);
        obj.modelFsp.model.controlInput()
        stepRate=obj.updateStepRate(stepRate);
        if obj.saveInject
          obj.saveInjector('controlInputInjector');
        end
        if obj.plotInject()
          obj.plotInjector();
        end
      end
      optimizedModel=obj.modelFsp;
    end
    function stepRate=updateStepRate(obj,stepRate)
      stepRate=stepRate*obj.decrement;
      if stepRate<obj.minimumStep
        stepRate=obj.minimumStep;
      end
    end
    function obj=stepToNewControler(obj,stepRate)
      grad=obj.gradCalc.getGrad(obj.modelFsp,obj.score);
      obj=obj.setControl(obj.modelFsp.model.controlInput-grad*stepRate);
    end
    function obj=setControl(obj,controler)
      controler=obj.setBounds(controler);
      obj.modelFsp.model.controlInput=controler;
      obj.modelFsp.model.controlInput=controler;
    end
    function saveInjector(obj,filename)
      if obj.saveInject
        controlInput=obj.modelFsp.model.controlInput;
        save(filename,'controlInput');
      end
    end
    function plotInjector(obj)
      if obj.plotInject()
        subplot(1,2,1)
        pcolorProbability(obj.modelFsp.model.controlInput);
        subplot(1,2,2);
        pcolorProbability(reshape(obj.getSteadyState,obj.modelFsp.dims));
        drawnow();
      end
    end
    function [xVector,yVector]=getSampleSpace(obj,stepSize)
      xVector=0:stepSize:(obj.modelFsp.dims(1)-1);
      yVector=0:stepSize:(obj.modelFsp.dims(2)-1);
    end 
    function decoration=generateFileDecoration(obj)
      scoreString=['_',replace(num2str(obj.getScore),'.','p'),'_'];
      timeStamp=datestr(now);
      timeStamp=replace(timeStamp,'-','');
      timeStamp=replace(timeStamp,':','');
      timeStamp=replace(timeStamp,' ','_');
      randomIntegerString=['_',strrep((num2str(randi(9,1,8))),' ','')];
      decoration=[scoreString,timeStamp,randomIntegerString];    
    end
    function fileName=generateFileName(obj)
      decoration=obj.generateFileDecoration();
      fileName=[class(obj.model.parameters),decoration];
    end
  end
end