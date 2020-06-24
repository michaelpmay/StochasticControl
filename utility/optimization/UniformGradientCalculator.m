classdef UniformGradientCalculator < FullGradientCalculator
  properties
    jacobian=[]
  end
  methods
    function obj=UniformGradientCalculator(modelFsp)
      obj=obj.getJacobian(modelFsp)
    end
    function grad=getGrad(obj,modelFsp,score)
      partial=obj.getPartial(modelFsp);
      grad=(score.C'*partial)*obj.jacobian;
      grad=repmat(grad',[modelFsp.dims]);
    end
    function obj=getJacobian(obj,modelFsp)
      if isempty(obj.jacobian)
        obj.jacobian=obj.makeJacobian(modelFsp);
      end
    end
    function jacobian=makeJacobian(obj,modelFsp)
      jacobian=ones(modelFsp.dims);
      jacobian=jacobian(:);
    end
  end
end    