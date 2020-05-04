classdef ParameterOptimizer
  properties
    solver
    realData
    decrement=.99
    tolerance=1e-10
    maxIter=100
    LogFit=true
    initialRate=2
    minRate=.001
    numChange=2
    logLowerBound=-10;
    targetSpecies=1;
  end
  methods
    function obj=ParameterOptimizer()
    end
    function [solver,error]=visit(obj,solver)
      [solver,error]=obj.optimize(solver);
    end
    function [solver,error]=optimize(obj,solver)
      obj.solver=solver;
      obj=obj.initializeOptimization;
      iter=1;
      error=obj.getError(obj.targetSpecies);
      parameters=obj.solver.model.getParameters();
      rate=obj.initialRate();
      while (obj.isUnTolerant(error) && (iter<obj.maxIter))
        newParameters=obj.mutate(parameters,rate);
        obj=obj.setParameters(newParameters);
        newError=obj.getError(obj.targetSpecies);
        if newError<error
          parameters=newParameters;
          error=newError;
        end
        rate=obj.getRate(rate);
        iter=iter+1;
      end
      obj=obj.setParameters(parameters);
      solver=obj.solver;
      ['Final Error: ',num2str(error)];
    end
    function obj=initializeOptimization(obj)
      obj.solver.model.time=obj.realData.time;
    end
    function parameterVector=getParameters(obj)
      parameterVector=obj.solver.model.getParameters();
    end
    function obj=setParameters(obj,parameterVector)
      obj.solver.model=obj.solver.model.setParameters(parameterVector);
    end
    function bool=isUnTolerant(obj,error)
      bool=(obj.tolerance<error);
    end
    function error=getError(obj,index)
      data=obj.solver.run;
      modelData=data.state(index,:);
      error=sum((obj.realData.state-modelData).^2);
    end
    function parameters=mutate(obj,parameters,rate)
      n=length(parameters);
      indicies=randi(n,obj.numChange,1);
      if obj.LogFit
        parameters=log(parameters);
      end
      parameters(parameters==-Inf)=obj.logLowerBound;
      
      for i=indicies
        parameters(i)=parameters(i)+rate*rand();
      end
      
      if obj.LogFit
        parameters=exp(parameters);
      end
    end
    function rate=getRate(obj,rate)
      rate=rate*obj.decrement;
      if rate<obj.minRate
        rate=obj.minRate;
      end
    end
  end
end