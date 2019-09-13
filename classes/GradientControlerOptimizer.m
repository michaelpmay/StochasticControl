classdef GradientControlerOptimizer < SteadyStateControlOptimizer & PrintObjects
  properties
    gradCutoffIndex=2500
    initialRate=1;
    minimumStep=.0005;
    decrement=.99
    gmresTolerance=1e-14
    gmresMaxIter=100
  end
  properties (Hidden)
    
  end
  methods
    function [optimizedModel,obj]=optimizeControler(obj)
      warning('MATLAB:eigs:IllConditionedA','off');
      obj.score=ProbabilityScore(obj.modelFsp.model);
      obj=obj.initializeControlInput(obj.initialInputLevel);
      stepRate=obj.initialRate;
      %controlHistory=zeros([obj.model.dims obj.numIterations]);
      %waitBar=waitbar(0,'Optimizing controler ... this may take a while');
      for i=1:obj.numIterations
        obj=obj.stepToNewControler(stepRate);
        stepRate=obj.updateStepRate(stepRate);
       % waitbar(i/obj.numIterations,waitBar);
      end
      %delete(waitBar);
      optimizedModel=obj.model;
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
      obj=obj.setControl(obj.controlInput-grad*stepRate);
    end
    function grad=trimGrad(obj,grad)
      gradCutoff=min(maxk(abs(grad(:)),obj.gradCutoffIndex));
      grad(abs(grad)<gradCutoff)=0;
    end
    function obj=setControl(obj,controler)
      controler=obj.setBounds(controler);
      obj.modelFsp.model.controlInput=controler;
    end
    function boundedControler=setBounds(obj,controler)
      controler(controler>obj.maxControlerBounds)=obj.maxControlerBounds;
      controler(controler<obj.minControlerBounds)=obj.minControlerBounds;
      boundedControler=controler;
    end
    function grad=getGrad(obj)
      partial=obj.getPartial(obj.modelFsp);
      grad=obj.score.C'*partial;
      grad=reshape(grad,obj.modelFsp.dims);
    end
    
    function [xVector,yVector]=getSampleSpace(obj,stepSize)
      xVector=0:stepSize:(obj.model.dims(1)-1);
      yVector=0:stepSize:(obj.model.dims(2)-1);
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
    
    function grad=getPartial(obj,modelFsp)
      P=obj.getSteadyState;
      Lambda=sparse(modelFsp.generator.bMatrix.*modelFsp.model.controlInput(:)'+modelFsp.generator.aMatrix);
      B=kron(sparse(eye(prod(modelFsp.dims))),Lambda);
      K=-(modelFsp.generator.bMatrix.*P(:)');
      K=K(:);
      grad=gmres(B,K,[],obj.gmresTolerance,obj.gmresMaxIter);
      grad=reshape(grad,[prod(modelFsp.dims) prod(modelFsp.dims)]);
    end
    function infGen=getInfGenerator(obj,modelFsp)
      infGen=modelFsp.generator.getInfGenerator(modelFsp.controlInput);
    end
  end
end