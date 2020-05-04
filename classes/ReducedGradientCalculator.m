classdef ReducedGradientCalculator < FullGradientCalculator 
  properties
    jacobian=[]
  end
  methods
    function obj=ReducedGradientCalculator(modelFsp)
      obj=obj.getJacobian(modelFsp)
    end
    function grad=getGrad(obj,modelFsp,score)
      partial=obj.getPartial(modelFsp);
      partial=partial*obj.jacobian;
      grad=score.C'*partial;
      grad=repmat(grad',[1,modelFsp.dims(2)]);
    end
    function obj=getJacobian(obj,modelFsp)
      if isempty(obj.jacobian)
        obj.jacobian=obj.makeJacobian(modelFsp);
      end
    end
    function jacobian=makeJacobian(obj,modelFsp)
      jacobian=preAllocateArray(prod(modelFsp.dims),modelFsp.dims(1));
      for i=1:modelFsp.dims(1)
        states=zeros(modelFsp.dims);
        states(i,:)=1;
        jacobian(:,i)=states(:);
      end
    end
  end
end