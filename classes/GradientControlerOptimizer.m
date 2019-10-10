classdef GradientControlerOptimizer < SteadyStateControlOptimizer & PrintObjects
  properties
    gradCutoffIndex=2500
    initialRate=1;
    minimumStep=.0005;
    decrement=.99
    gmresTolerance=1e-14
    gmresMaxIter=100
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
      %controlHistory=zeros([obj.model.dims obj.numIterations]);
      %waitBar=waitbar(0,'Optimizing controler ... this may take a while');
      for i=1:obj.numIterations
        obj=obj.stepToNewControler(stepRate);
        stepRate=obj.updateStepRate(stepRate);
        if obj.saveInject
          obj.saveInjector();
        end
        if obj.plotInject()
          obj.plotInjector();
        end
       % waitbar(i/obj.numIterations,waitBar);
      end
      %delete(waitBar);
      optimizedModel=obj.modelFsp;
    end
    function stepRate=updateStepRate(obj,stepRate)
      stepRate=stepRate*obj.decrement;
      if stepRate<obj.minimumStep
        stepRate=obj.minimumStep;
      end
    end
    function obj=stepToNewControler(obj,stepRate)
      grad=obj.getGrad();
      grad=obj.trimGrad(grad);
      obj=obj.setControl(obj.modelFsp.model.controlInput-grad*stepRate);
    end
    function grad=trimGrad(obj,grad)
      gradCutoff=min(maxk(abs(grad(:)),obj.gradCutoffIndex));
      grad(abs(grad)<gradCutoff)=0;
    end
    function obj=setControl(obj,controler)
      controler=obj.setBounds(controler);
      obj.modelFsp.model.controlInput=controler;
      obj.modelFsp.model.controlInput=controler;
    end
    function grad=getGrad(obj)
      partial=obj.getPartial(obj.modelFsp.model);
      grad=obj.score.C'*partial;
      grad=reshape(grad,obj.modelFsp.dims);
    end
    function saveInjector(obj)
      if obj.saveInject
        controlInput=obj.modelFsp.model.controlInput;
        save('controlInputInjector','controlInput');
      end
    end
    function plotInjector(obj)
      if obj.plotInject()
        subplot(1,2,1)
        pcolorProbability(obj.modelFsp.model.controlInput);
        subplot(1,2,2);
        pcolorProbability(reshape(obj.getSteadyState,obj.dims));
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
    
    function grad=getPartial(obj,model)
      P=obj.getSteadyState;
      Lambda=sparse(obj.modelFsp.generator.bMatrix.*model.controlInput(:)'+obj.modelFsp.generator.aMatrix);
      B=kron(sparse(eye(prod(obj.modelFsp.dims))),Lambda);
      K=-(obj.modelFsp.generator.bMatrix.*P(:)');
      K=K(:);
      grad=gmres(B,K,[],obj.gmresTolerance,obj.gmresMaxIter);
      grad=reshape(grad,[prod(obj.modelFsp.dims) prod(obj.modelFsp.dims)]);
    end
    
  end
end