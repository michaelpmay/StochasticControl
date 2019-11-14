classdef TwoCellFSP < SolverFSP & PrintObjects
  properties (Hidden)
    maxU=10
  end
  methods
    function obj=TwoCellFSP(model,dims)
      obj.model=model;
      obj.dims=dims;
      obj.generator=TwoCellFSPGenerator(model,dims);
    end
    function data=formatTrajectory(obj,data)
      newState=zeros([obj.dims(1),obj.dims(2),length(obj.time)]);
      for i=1:length(data.time)
        newState(:,:,i)=reshape(data.state(:,i),[obj.dims(1),obj.dims(2)]);
      end
      data=ModelFSPData(data.time,newState,data.meta);
    end
    function infGenerator=getInfGenerator(obj)
      infGenerator=obj.generator.getInfGenerator(obj.model);
    end
    function grad=getGrad(obj)
      P=obj.getSteadyState;
      Lambda=sparse(obj.generator.bMatrix.*obj.controlInput(:)'+obj.generator.aMatrix);
      B=kron(sparse(eye(prod(obj.dims))),Lambda);
      C=-(obj.generator.bMatrix.*P(:)');
      C=C(:);
      grad=gmres(B,C,[],obj.gmresInputTolerance,obj.gmresInputMaxIter);
      grad=reshape(grad,[prod(obj.dims) prod(obj.dims)]);
    end
    function [model,optimizer]=accept(obj,optimizer)
      [model,optimizer]=optimizer.visit(obj);
    end
    function field=reshapeField(obj,field)
      field=reshape(field,obj.dims);
    end
    function probability=getSteadyStateReshape(obj)
      probability=obj.getSteadyState();
      probability=obj.reshapeField(probability);
    end
    function [xv,yv]=getXYV(obj)
      xv=[0:1:(obj.dims(1)-1)];
      yv=[0:1:(obj.dims(2)-1)];
    end
  end
end

