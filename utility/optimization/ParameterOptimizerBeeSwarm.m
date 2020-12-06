classdef ParameterOptimizerBeeSwarm<ParameterOptimizerParallelBeeSwarm
  methods
    function [solver,error]=optimize(obj,solver,data,index)
      for j=1:obj.numSteps
        for i=1:obj.numBees
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
  end
end