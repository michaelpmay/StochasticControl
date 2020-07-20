classdef SolverODE 
  properties
    model
    integrator=@ode23s
  end
  properties(Hidden)
    odeOptions=odeset('RelTol',1e-18)
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
      odeData=obj.integrator(odeEq,obj.model.time,obj.model.initialState,obj.odeOptions);
      [time,state]=obj.formatTimes(odeData);
      
      data=ModelData(time,state);
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
        try
        time(i)=obj.model.time(i);
        state(:,i)=deval(odeData,obj.model.time(i));
        catch
          return
        end
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