classdef JointTimeOptimizer
  properties
    modelFsp
    score
    initialState
    time
    initialU
  end
  methods
    function obj=JointTimeOptimizer()
      
    end
    function optimize(obj,modelFsp)
      obj.modelFsp=modelFsp;
      obj.modelFsp.intialState=zeros(obj.modelFsp.dims)
      obj.modelFsp.initialState=obj.initialState;
      
      % intitialize y
      % pick u to minimize dtJ
      % step to new time using u
    end
  end
end