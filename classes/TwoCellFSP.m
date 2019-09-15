classdef TwoCellFSP < SolverFSP & PrintObjects
  properties
    model
    dims=[50 50]
  end
  properties (Hidden)
    maxU=50
    generator
  end
  methods
    function obj=TwoCellFSP(model)
      obj.model=model;
      obj.generator=TwoCellFSPGenerator(model);
      obj.generator.dims=obj.dims;
    end
    function data=formatTrajectory(obj,data)
      newState=zeros([obj.dims(1),obj.dims(2),length(obj.time)]);
      for i=1:length(data.time)
        newState(:,:,i)=reshape(data.state(:,i),[obj.dims(1),obj.dims(2)]);
      end
      data=ModelFSPData(data.time,newState,data.meta);
    end
    function Pss=getSteadyState(obj)
      infGenerator=obj.getInfGenerator;
      fsp=SolverFSP();
      fsp.infGenerator=infGenerator;
      Pss=fsp.getSteadyState;
      Pss=obj.reshapeField(Pss);
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
  end
end

