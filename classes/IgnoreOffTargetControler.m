classdef IgnoreOffTargetControler < GradientControlerOptimizer
  properties
    
  end
  methods
    function grad=getPartial(obj,model)
      P=obj.getSteadyState;
      Lambda=sparse(model.generator.bMatrix.*model.controlInput(:)'+model.generator.aMatrix);
      B=kron(sparse(eye(prod(model.dims))),Lambda);
      K=-(model.generator.bMatrix.*P(:)');
      K=K(:);
      grad=gmres(B,K,[],obj.gmresInputTolerance,obj.gmresInputMaxIter);
      grad=reshape(grad,[prod(model.dims) prod(model.dims)]);
    end
    function obj=initializeControlInput(obj,level)
      obj=obj.setControl(level*ones(obj.model.dims));
    end
  end
end