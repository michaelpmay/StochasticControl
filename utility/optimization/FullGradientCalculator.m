classdef FullGradientCalculator 
  properties
    gradCutoffIndex=2500
    gmresTolerance=1e-14
    gmresMaxIter=3
  end
  methods
    function grad=getGrad(obj,modelFsp,score)
      partial=obj.getPartial(modelFsp);
      grad=score.C'*partial;
      grad=reshape(grad,modelFsp.dims);
      grad=obj.trimGrad(grad);
    end
    function grad=getPartial(obj,modelFsp)
      P=modelFsp.getSteadyState();
      Lambda=sparse(modelFsp.generator.bMatrix.*modelFsp.model.controlInput(:)'+modelFsp.generator.aMatrix);
      B=kron(sparse(eye(prod(modelFsp.dims))),Lambda);
      K=-(modelFsp.generator.bMatrix.*P(:)');
      K=K(:);
      grad=gmres(B,K,[],obj.gmresTolerance,obj.gmresMaxIter);
      grad=reshape(grad,[prod(modelFsp.dims) prod(modelFsp.dims)]);
    end
    function grad=trimGrad(obj,grad)
      gradCutoff=min(maxk(abs(grad(:)),obj.gradCutoffIndex));
      grad(abs(grad)<gradCutoff)=0;
    end
  end
end