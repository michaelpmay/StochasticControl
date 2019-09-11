classdef SolverODE < GenericCME
  properties
    model
  end
  methods
    function obj=SolverODE(modelPlugin)
      try
      obj.model=modelPlugin;
      catch
        %do nothing
      end
    end
    function data=run(obj)
      odeEq=obj.model.getRateEquation();
      odeData=ode15s(odeEq,obj.model.time,obj.model.initialState);
      [time,state]=obj.formatTimes(odeData);
      data=GenericData(time,state);
    end
    
    function [time,state]=formatTimes(obj,odeData)
      if length(obj.model.time)>2
        [time,state]=obj.parseTimes(odeData);
      else
        time=odeData.x;
        state=odeData.y;
      end
    end
    function [time,state]=parseTimes(obj,odeData)
      maxTimeIter=length(obj.model.time);
      time=preAllocateVector(maxTimeIter);
      state=preAllocateArray(length(obj.model.initialState),maxTimeIter);
      for i=1:maxTimeIter
        time(i)=obj.model.time(i);
        state(:,i)=deval(odeData,obj.model.time(i));
      end
    end
    function data=appendMetaData(obj,data)
      data.meta.solver=class(obj);
      data.meta.timeStamp=datetime;
      data.meta.time=obj.time;
      data.meta.initialState=obj.initialState;
      data.meta.rxnRate=obj.rxnRate;
      data.meta.stoichMatrix=obj.stoichMatrix;
      data.meta.details=[];
    end
    function data=formatTrajectory(obj,data)
      %do nothing
    end
    function obj=accept(obj,visitor)
      obj=visitor.visit(obj);
    end
  end
end