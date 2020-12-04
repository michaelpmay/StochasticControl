classdef SSAIntegratorParsed
  properties
    verbose=false
  end
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
      outData=ModelData(time,state);
    end
    
    function [timeRecord,stateRecord]=integrateSSA(obj,model)
      [stateRecord,timeRecord]=obj.getInitialRecord(model);
      timeEnd=model.time(end);
      time=timeRecord(1);
      state=stateRecord(:,1);
      timeStep=timeRecord(1);
      n=length(timeRecord);
      printTimes=linspace(model.time(1),model.time(end),101);
      printIndex=1;
      ind=1;
      while time<timeEnd
        rate=obj.getCumulativeRate(time,state,model);
        time=obj.stepToNewTime(time,rate);
        if time>=timeStep%if this condition occurs, record state before state jump
          while timeStep<time
            stateRecord(:,ind)=state;
            if ind<=n-1
              ind=ind+1;
              timeStep=timeRecord(ind);
            else
              return
            end
          end
        end
        state=obj.stepToNewState(state,rate,model);
        if obj.verbose & time>printTimes(printIndex)
          printIndex=printIndex+1;
          fprintf('percent:%f\n',(time-model.time(1))/(model.time(end)-model.time(1)))
          time
          state
        end
      end
    end
    
    function [x,t]=getInitialRecord(obj,model)
      n=length(model.time);
      m=length(model.initialState);
      x=preAllocateArray(m,n);
      x(:,1)=model.initialState;
      t=model.time;
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
    
    function flag=isTimeSampled(obj,model)
      if (length(model.time)>2)
        flag=1;
      else
        flag=0;
      end
    end
    function [data]=parseTrajectory(obj,time,state,model)
      numTimeElements=length(model.time);
      parsedStates=zeros(size(state,1),numTimeElements);
      ind=1;
      for i=1:numTimeElements
        stepTimeIter=model.time(i);
        while time(ind)<stepTimeIter
          ind=ind+1;
        end
        parsedStates(:,i)=state(:,ind);
      end
      data=ModelData(model.time,parsedStates);
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
