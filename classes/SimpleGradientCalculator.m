classdef SimpleGradientCalculator < FullGradientCalculator
  properties
    jacobian=[]
  end
  methods
    function obj=SimpleGradientCalculator(modelFsp)
      obj=obj.getJacobian(modelFsp)
    end
    function grad=getGrad(obj,modelFsp,score)
      partial=obj.getPartial(modelFsp);
      partial=partial*obj.jacobian;
      grad=score.C'*partial;
      grad=grad*ones(modelFsp.dims);
    end
    function obj=getJacobian(obj,modelFsp)
      if isempty(obj.jacobian)
        obj.jacobian=obj.makeJacobian(modelFsp);
      end
    end
    function jacobian=makeJacobian(obj,modelFsp)
      jacobian=preAllocateArray(prod(modelFsp.dims),1);
      for i=1
        states=ones(modelFsp.dims);
        jacobian(:,i)=states(:);
      end
    end
  end
end