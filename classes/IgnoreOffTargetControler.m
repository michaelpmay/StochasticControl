classdef IgnoreOffTargetControler < GradientControlerOptimizer
  properties
    
  end
  methods
    function grad=getPartial(obj,model)
      P=obj.getSteadyState;
      J=obj.makeJacobian;
      Lambda=sparse(model.generator.bMatrix.*J*model.controlInput(:)'+model.generator.aMatrix);
      B=kron(sparse(eye(prod(model.dims))),Lambda);
      K=-(model.generator.bMatrix.*P(:)');
      K=K(:);
      grad=gmres(B,K,[],obj.gmresInputTolerance,obj.gmresInputMaxIter);
      grad=reshape(grad,[prod(model.dims) prod(model.dims)]);
    end
    function obj=initializeControlInput(obj,level)
      obj=obj.setControl(level*ones(obj.model.dims));
    end
    function J=makeJacobian(obj)
      for i=1:obj.model.dim(2)
        u=zeros(obj.model.dims);
        u(i,:)=1;
        J=u(:);
      end
    end
  end
end