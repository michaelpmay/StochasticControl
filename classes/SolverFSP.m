classdef SolverFSP < GenericCME
  properties
    model
    generator
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
      data.meta.time=obj.model.time;
      data.meta.initialState=obj.model.initialState;
      data.meta.details=[];
      data.meta.infGenerator=obj.model.infGenerator;
    end
    function P=getSteadyState(obj)
      [P,d]=eigs(obj.getInfGenerator,1,0);
      P=real(P)./sum(real(P));
    end
    function P=getNullP(obj)
      P=null(obj.getInfGenerator);
    end
    function infGen=getInfGenerator(obj)
      infGen=obj.generator.getInfGenerator(obj.model);
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