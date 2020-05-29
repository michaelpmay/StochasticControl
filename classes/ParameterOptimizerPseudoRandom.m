classdef ParameterOptimizerPseudoRandom
  properties
    decrement=.99
    tolerance=1e-10
    maxIter=100
    LogFit=true
    initialRate=2
    minRate=.001
    numChange=2
    logLowerBound=-10;
  end
  methods
    function [solver,error]=optimize(obj,solver,data,index)
      warning('off','MATLAB:odearguments:RelTolIncrease')
      solver.model.time=data.time;
      iter=1;
      error=obj.getError(solver,data,index);
      parameters=solver.model.getParameters();
      rate=obj.initialRate();
      while ((obj.tolerance<error) && (iter<obj.maxIter))
        newParameters=obj.mutate(parameters,rate);
        newSolver=obj.setParameters(solver,newParameters);
        newError=obj.getError(newSolver,data,index);
        if newError<error
          parameters=newParameters;
          error=newError;
          solver=newSolver;
        end
        rate=obj.getRate(rate);
        iter=iter+1;
      end
      obj=obj.setParameters(solver,parameters);
      ['Final Error: ',num2str(error)];
    end
    function parameterVector=getParameters(obj,solver)
      parameterVector=solver.model.getParameters();
    end
    function solver=setParameters(obj,solver,parameters)
      solver.model=solver.model.setParameters(parameters);
    end
    function error=getError(obj,solver,data,index)
      sData=solver.run;
      error=sum((data.state-sData.state(index,:)).^2);
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