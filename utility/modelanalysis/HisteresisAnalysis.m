classdef HisteresisAnalysis
  properties
    ode
    uRange=0:.01:5
    time
    speciesIndex
  end
  methods
    function obj=HisteresisAnalysis(ode)
      obj.ode=ode;
    end
    function [upAnalysis,downAnalysis]=analyze(obj,parameterIndex)
      obj.ode.model.initialState=zeros(size(obj.ode.model.initialState));
      obj.ode.model.time=obj.time;
      N=length(obj.uRange);
      upAnalysis=[];
      for i=1:N
        obj.ode.model.parameters(parameterIndex)=obj.uRange(i);
        data{i}=obj.ode.run;
        obj.ode.model.initialState=data{i}.state(:,end);
        upAnalysis(end+1)=data{i}.state(obj.speciesIndex,end);
      end
      downAnalysis=[];
      flipRange=fliplr(obj.uRange);
      for i=1:N
        obj.ode.model.parameters(parameterIndex)=flipRange(i);
        data{i}=obj.ode.run;
        obj.ode.model.initialState=data{i}.state(:,end);
        downAnalysis(end+1)=data{i}.state(obj.speciesIndex,end);
      end
      downAnalysis=fliplr(downAnalysis);
      analysis=[upAnalysis,downAnalysis]
      range=[obj.uRange,flipRange]
    end
  end
end