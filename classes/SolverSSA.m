classdef SolverSSA < GenericCME
  properties
    model
  end
  methods Private
    function obj=SolverSSA(modelPlugin)
      try
      obj.model=modelPlugin;
      catch
      end
    end
    function data=run(obj,varargin)
      [numSamples]=sanitizeVararginInputs(varargin);
      data=SSAData();
      for i=1:numSamples
        timeSeriesData=obj.runTrajectory();
        timeSeriesData=obj.formatTrajectory(timeSeriesData);
        timeSeriesData=obj.appendMetaData(timeSeriesData);
        data=data.appendNode(timeSeriesData);
      end
    end
    
    function [outData]=runTrajectory(obj)
      [state,time]=obj.getInitialLL();
      [time,state]=obj.integrateSSA(time,state);
      if obj.checkInfinityExitCondition(time)
        obj.trimInfinityExitCondition(time,state)
      end
      outData=GenericCMEData(time.toMLArray,state.toMLArray);
    end
    
    function [time,state]=integrateSSA(obj,time,state)
      waitBar=waitbar(0,'Running SSA');
      while time.getLast<obj.model.time(end)
        rate=obj.getCumulativeRate(time.getLast,state.getLast);
        time.add(obj.stepToNewTime(time.getLast,rate));
        state.add(obj.stepToNewState(state.getLast,rate));
        waitbar(time.getLast/obj.model.time(end),waitBar);
      end
      delete(waitBar)
    end
    
    function [x,t]=getInitialLL(obj)
      x=LinkedList(obj.model.initialState);
      t=LinkedList(obj.model.time(1));
    end
    
    function x=stepToNewState(obj,x,rate)
      event=find(rate>(rate(end)*rand()),1);
      x=x+obj.model.stoichMatrix(:,event);
    end
    
    function t=stepToNewTime(obj,t,rate)
      t=t-log(rand)/rate(end);
    end
    
    function rate=getCumulativeRate(obj,t,x)
      rate=obj.model.evaluateRateEquation(t,x);
      rate=cumsum(rate);
    end
    
    function flag=checkInfinityExitCondition(obj,time)
      flag=(time.getLast==inf);
    end
    
    function trimInfinityExitCondition(obj,time,state)
      n=time.length;
      time.set(n,obj.model.time(end));
      finalState=state.get(n-1);
      state.set(n,finalState);
    end
    
    function flag=isTimeSampled(obj)
      if (length(obj.model.time)>2)
        flag=1;
      else
        flag=0;
      end
    end
    
    function [data]=parseTrajectory(obj,time,state)
      numTimeElements=length(obj.model.time);
      parsedStates=zeros(size(state,1),numTimeElements);
      ind=1;
      for i=1:numTimeElements
        stepTimeIter=obj.model.time(i);
        while time(ind)<stepTimeIter
          ind=ind+1;
        end
        parsedStates(:,i)=state(:,ind);
      end
      data=GenericCMEData(obj.model.time,parsedStates);
    end
    
    function [data]=formatTrajectory(obj,data)
      if obj.isTimeSampled()
        data=obj.parseTrajectory(data.time,data.state);
      end
    end
    
    function data=appendMetaData(obj,data)
      data.meta.solver=class(obj);
      data.meta.timeStamp=datetime;
      data.meta.time=obj.model.time;
      data.meta.initialState=obj.model.initialState;
      data.meta.rxnRate=obj.model.rxnRate;
      data.meta.stoichMatrix=obj.model.stoichMatrix;
      data.meta.details=[];
    end
  end
  
end

