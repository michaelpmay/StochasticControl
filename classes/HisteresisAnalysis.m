classdef HisteresisAnalysis
  properties
    modelOde
    uRange=linspace(0,.5,100)
  end
  methods
    function obj=HisteresisAnalysis(modelOde)
      obj.modelOde=modelOde;
    end
    function [upAnalysis,downAnalysis]=analyze(obj,parameterIndex)
      obj.modelOde.model.initialState=0;
      obj.modelOde.model.time=linspace(0,5000,500);
      N=length(obj.uRange);
      upAnalysis=[];
      for i=1:N
        obj.modelOde.model.parameters(parameterIndex)=obj.uRange(i);
        data{i}=obj.modelOde.run;
        obj.modelOde.model.initialState=data{i}.state(end);
        upAnalysis(end+1)=data{i}.state(end);
      end
      downAnalysis=[];
      flipRange=fliplr(obj.uRange)
      for i=1:N
        obj.modelOde.model.parameters(parameterIndex)=flipRange(i);
        data{i}=obj.modelOde.run;
        obj.modelOde.model.initialState=data{i}.state(end);
        downAnalysis(end+1)=data{i}.state(end);
      end
      downAnalysis=fliplr(downAnalysis);
    end
  end
end