classdef ReducedGradientControlerOptimizer < GradientControlerOptimizer
  properties
    controlDims
  end
  properties(Hidden)
    jacobian
  end
  methods
    function obj=ReducedGradientControlerOptimizer()
      obj.controlDims=obj.dims(1);
      obj.plotInject=true;
      obj.saveInject=false;
    end
    function [optimizedModel,obj]=optimizeControler(obj,saveResponse)
      warning('MATLAB:eigs:IllConditionedA','off');
      obj.score=ProbabilityScore(obj.modelFsp.dims);
      obj.score.target=[10;30];
      obj=obj.initializeControlInput(obj.initialInputLevel);
      stepRate=obj.initialRate;
      if obj.saveInject & ~exist('saveResponse')
        saveResponse=input('Please input save injector file name:\n','s')
      end
      %controlHistory=zeros([obj.model.dims obj.numIterations]);
      %waitBar=waitbar(0,'Optimizing controler ... this may take a while');
      for i=1:obj.numIterations
        obj=obj.stepToNewControler(stepRate);
        stepRate=obj.updateStepRate(stepRate);
        if obj.saveInject
          obj.saveInjector(saveResponse);
        end
        if obj.plotInject()
          obj.plotInjector();
        end
        %plot(obj.modelFsp.model.controlInput);
        %drawnow();
       % waitbar(i/obj.numIterations,waitBar);
      end
      %delete(waitBar);
      optimizedModel=obj.modelFsp;
    end
    function grad=getGrad(obj)
      obj=obj.getJacobian();
      partial=obj.getPartial(obj.modelFsp.model);
      partial=partial*obj.jacobian;
      grad=obj.score.C'*(partial);
      grad=grad(:);
    end
    function obj=getJacobian(obj)
      if isempty(obj.jacobian)
        obj.jacobian=obj.makeJacobian();
      end
    end
    function jacobian=makeJacobian(obj)
      jacobian=preAllocateArray(prod(obj.dims),obj.controlDims);
      for i=1:obj.dims(1)
        states=zeros(obj.dims);
        states(i,:)=1;
        jacobian(:,i)=states(:);
      end
    end
    function grad=getPartial(obj,model)
      P=obj.getSteadyState;
      controlInput=obj.jacobian*model.controlInput;
      Lambda=sparse(obj.modelFsp.generator.bMatrix.*controlInput(:)'+obj.modelFsp.generator.aMatrix);
      B=kron(sparse(eye(prod(obj.modelFsp.dims))),Lambda);
      K=-(obj.modelFsp.generator.bMatrix.*P(:)');
      K=K(:);
      grad=gmres(B,K,[],obj.gmresTolerance,obj.gmresMaxIter);
      grad=reshape(grad,[prod(obj.modelFsp.dims) prod(obj.modelFsp.dims)]);
    end
    function obj=initializeControlInput(obj,level)
      obj=obj.setControl(level*ones(obj.controlDims,1));
    end
    function steadyState=getSteadyState(obj)
      warning('MATLAB:eigs:IllConditionedA','off');
      obj=obj.getJacobian;
      controlInput=obj.jacobian*obj.modelFsp.model.controlInput;
      obj=obj.setControl(controlInput);
      steadyState=obj.modelFsp.getSteadyState();
    end
    function plotInjector(obj)
      if obj.plotInject()
        subplot(1,2,1)
        plot(obj.modelFsp.model.controlInput);
        subplot(1,2,2);
        pcolorProbability(reshape(obj.getSteadyState,obj.dims));
        drawnow();
      end
    end
  end
end