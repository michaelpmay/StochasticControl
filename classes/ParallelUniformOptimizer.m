classdef ParallelUniformOptimizer < UniformControlerOptimizer
  methods
    function [model,obj]=optimizeControler(obj)
      obj.score=ProbabilityScore(obj.model);
      levelRange=linspace(obj.range(1),obj.range(2),obj.numIterations);
      scoreRange=preAllocateVector(obj.numIterations);
      n=obj.numIterations;
      parfor i=1:n
        tempObj=obj.initializeControlInput(levelRange(i));
        try
          scoreRange(i)=tempObj.getScore;
        catch
          scoreRange(i)=nan;
        end
      end
      delete(gcp('nocreate'));
      [score,minIndex]=min(scoreRange);
      obj=obj.initializeControlInput(levelRange(minIndex));
      model=obj.model;
    end
    function getScore()
      
    end
  end
end