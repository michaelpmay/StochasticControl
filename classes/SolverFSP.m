classdef SolverFSP < GenericCME
  properties
    model
    generator
    dims
    eMaxIter=30;
  end
  methods Public
    function obj=SolverFSP(varargin)
      if nargin==2
        model=varargin{1}
        dims=varargin{2}
      elseif nargin==0
        model=[]
        dims=[]
      else
        error('accepts 2 or 0 arguements')
      end
      obj.model=model
      obj.dims=dims
      obj.generator=FSPGenerator
    end
  end
  methods Private
    function outData=run(obj)
      infGen=sparse(obj.getInfGenerator());
      initialState=sparse(obj.getInitialState());
      maxInd=length(obj.model.time);
      %waitBar=waitbar(0,'Running FSP');
      for i=1:maxInd
        %waitbar(i/maxInd,waitBar);
        P(:,i)=expm(infGen*obj.model.time(i))*initialState;
      end
      outData=GenericCMEData(obj.model.time,P);
      %delete(waitBar)
    end
    function snapTime(obj,time)
      P(:)=expm(infGen*time)*obj.getInitialState;
    end
    function data=appendMetaData(obj,data)
      data.meta.solver=class(obj);
      data.meta.timeStamp=datetime;
      data.meta.time=obj.time;
      data.meta.initialState=obj.initialState;
      data.meta.details=[];
      data.meta.infGenerator=obj.infGenerator;
    end
    function P=getSteadyState(obj)
      opts.maxit = obj.eMaxIter;
      [P,d]=eigs(obj.getInfGenerator,3,0,opts);
      P=real(P(:,1))./sum(real(P(:,1)));
    end
    function P=getNullP(obj)
      P=null(obj.getInfGenerator);
    end
    function out=getInfGenerator(obj)
      out=obj.generator.getInfGenerator(obj.model,obj.dims);
    end
    function out=getInitialState(obj)
      out=obj.model.initialState;
    end
    function outData=formatTrajectory(obj,data)
      outData=data;
    end
    function state=getSample(obj,time,state)
      infGen=sparse(obj.getInfGenerator());
      probabilty=expm(infGen*state);
      cSumProbability=cumsum(probabilty);
      [state]=find(csum>rand);
    end
  end
end