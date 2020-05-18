classdef TwoCellFSP < SolverFSP & PrintObjects
  properties (Hidden)
    maxU=10
  end
  methods
    function obj=TwoCellFSP(varargin)
      if nargin==2
        model=varargin{1}
        dims=varargin{2}
      elseif nargin==0
        model=[]
        dims=[]
      else
        error('accepts 2 or 0 arguements')
      end
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

