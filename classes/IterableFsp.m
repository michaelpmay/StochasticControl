classdef IterableFsp
  properties
    state=[]
    time=[0]
  end
  properties(Hidden)
    
  end
  methods
    function obj=IterableFsp(initialState,initialTime)
      obj.state=initialState;
      obj.time=initialTime;
    end
    function obj=iterate(stateGenIndex,time)
      obj=obj.appendNextState(obj.step{stateGenIndex});
      obj=obj.appendNextTime(time);
    end
    function obj=iterateStep(obj,stateGenerator,timeStep)
      obj=obj.appendNextState(obj.stateStep(stateGenerator));
      obj=obj.appendNextTimeStep(timeStep);
    end
    function lastState=getLastState(obj)
      lastState=obj.state(:,end);
    end
    function newState=stateStep(obj,stateGenerator)
      newState=stateGenerator*obj.state(:,end);
    end
    function obj=appendNextState(obj,newStates)
      obj.state(:,end+1)=newStates;
    end
    function obj=appendNextTime(obj,newTime)
      obj.time=[obj.time newTime];
    end
    function obj=appendNextTimeStep(obj,timeStep)
      obj.time(end+1)=obj.time(end)+timeStep;
    end
    function data=run(obj)
      data=GenericCMEData(obj.time,obj.state);
    end
  end
end 