classdef ParameterOptimizerParallelBeeSwarm
  properties
    subOptimizer=ParameterOptimizerPseudoRandom
    numBees=16;
    numSteps=1;
    mutationRate=3;
  end
  methods
    function [solver,error]=optimize(obj,solver,data,index)
      for j=1:obj.numSteps
        parfor i=1:obj.numBees
          if i==1
            [optimizedSolver{i},error(i)]=obj.optimizeBee(solver,data,index,0);
          else
            [optimizedSolver{i},error(i)]=obj.optimizeBee(solver,data,index,obj.mutationRate);
          end
        end
        [error,minIndex]=min(error);
        solver=optimizedSolver{minIndex};
      end
    end
    function [solver,error]=optimizeBee(obj,solver,data,index,mutationRate)
      mutations=10.^(mutationRate*2*(rand(1,length(solver.model.parameters))-.5));
      solver.model.parameters=solver.model.parameters.*mutations;
      [solver,error]=obj.subOptimizer.optimize(solver,data,index);
    end
    function obj=setLogBounds(obj,bound)
      obj.subOptimizer.logBounds=bound;
    end
  end
end