classdef ParameterOptimizerPseudoRandom
  properties
    decrement=.99
    tolerance=1e-10
    maxIter=20
    initialRate=.05
    minRate=.001
    numChange=2
    logBounds
    modelErrorCalc=ErrorCalcSSE
    parameterErrorCalc=ErrorCalcSSE
    errorFunction=@(xtrue,xsim)(sum((xtrue-xsim).^2))
  end
  methods
    function [solver,error]=optimize(obj,solver,data,index)
      warning('off','MATLAB:odearguments:RelTolIncrease')
      solver.model.time=data.time;
      parameters=obj.boundParameters(solver.model.getParameters());
      solver.model.parameters=parameters;
      error=obj.getError(solver,data,index);
      rate=obj.initialRate();
      iter=0;
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
      error=obj.errorFunction(data.state,sData.state(index,:));
    end
    function parameters=mutate(obj,parameters,rate)
      n=length(parameters);
      indicies=randi(n,obj.numChange,1);
      for i=indicies
        parameters(i)=parameters(i)*10^(rate*2*(rand()-.5));
      end
      parameters=obj.boundParameters(parameters);
    end
    function rate=getRate(obj,rate)
      rate=rate*obj.decrement;
      if rate<obj.minRate
        rate=obj.minRate;
      end
    end
    function parameters=boundParameters(obj,parameters)
      if ~isempty(obj.logBounds)
        n=length(parameters);
        parameters=log10(parameters);
        for i=1:n
          if parameters(i)<obj.logBounds(1,i)
            parameters(i)=obj.logBounds(1,i);
          end
          if parameters(i)>obj.logBounds(2,i)
            parameters(i)=obj.logBounds(2,i);
          end
        end
        parameters=10.^parameters;
      end
    end
  end
end