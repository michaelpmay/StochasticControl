classdef SSAIntegratorFull
  methods
    function data=integrate(obj,model,varargin)
      [numSamples]=sanitizeVararginInputs(varargin);
      data=SSAData();
      for i=1:numSamples
        timeSeriesData=obj.runTrajectory(model);
        timeSeriesData=obj.appendMetaData(timeSeriesData,model);
        data=data.appendNode(timeSeriesData);
      end
    end
    
    function [outData]=runTrajectory(obj,model)
      [time,state]=obj.integrateSSA(model);
      if obj.checkInfinityExitCondition(time)
        obj.trimInfinityExitCondition(time,state);
      end
      outData=GenericCMEData(time.toMLArray,state.toMLArray);
    end
    
    function [time,state]=integrateSSA(obj,model)
      [state,time]=obj.getInitialState(model);
      %waitBar=waitbar(0,'Running SSA');
      lastTime=time.getLast;
      lastState=state.getLast;
      timeEnd=model.time(end);
      while lastTime<timeEnd
        rate=obj.getCumulativeRate(lastTime,lastState,model);
        lastTime=obj.stepToNewTime(lastTime,rate);
        time.add(lastTime);
        lastState=obj.stepToNewState(lastState,rate,model);
        state.add(lastState);
        %waitbar(time.getLast/obj.model.time(end),waitBar);
      end
      %delete(waitBar)
    end
    
    function [x,t]=getInitialState(obj,model)
      x=LinkedList(model.initialState);
      t=LinkedList(model.time(1));
    end
    
    function rate=getCumulativeRate(obj,t,x,model)
      rate=model.evaluateRateEquation(t,x);
      rate=cumsum(rate);
    end
    
    function t=stepToNewTime(obj,t,rate)
      t=t-log(rand)/rate(end);
    end
    
    function x=stepToNewState(obj,x,rate,model)
      event=find(rate>(rate(end)*rand()),1);
      x=x+model.stoichMatrix(:,event);
    end
    
    function flag=checkInfinityExitCondition(obj,time)
      flag=(time.getLast==inf);
    end
    function data=appendMetaData(obj,data,model)
      data.meta.solver=class(obj);
      data.meta.timeStamp=datetime;
      data.meta.time=model.time;
      data.meta.initialState=model.initialState;
      data.meta.rxnRate=model.rxnRate;
      data.meta.stoichMatrix=model.stoichMatrix;
      data.meta.details=[];
    end
  end
end