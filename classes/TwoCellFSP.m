classdef TwoCellFSP < SolverFSP & PrintObjects
  properties (Hidden)
    maxU=50
  end
  methods
    function obj=TwoCellFSP(model)
      obj.model=model;
      obj.generator=TwoCellFSPGenerator();
      obj.generator;
      obj.model.controlInput=zeros(model.dims);
    end
    function data=formatTrajectory(obj,data)
      newState=zeros([obj.model.dims(1),obj.model.dims(2),length(obj.model.time)]);
      for i=1:length(data.time)
        newState(:,:,i)=reshape(data.state(:,i),[obj.dims(1),obj.dims(2)]);
      end
      data=ModelFSPData(data.time,newState,data.meta);
    end
    function grad=getGrad(obj)
      P=obj.getSteadyState;
      Lambda=sparse(obj.generator.bMatrix.*obj.model.controlInput(:)'+obj.generator.aMatrix);
      B=kron(sparse(eye(prod(obj.dims))),Lambda);
      C=-(obj.generator.bMatrix.*P(:)');
      C=C(:);
      grad=gmres(B,C,[],obj.gmresInputTolerance,obj.gmresInputMaxIter);
      grad=reshape(grad,[prod(obj.model.dims) prod(obj.model.dims)]);
    end
    function [model,optimizer]=accept(obj,optimizer)
      [model,optimizer]=optimizer.visit(obj);
    end
    function field=reshapeField(obj,field)
      field=reshape(field,obj.model.dims);
    end
  end
end

