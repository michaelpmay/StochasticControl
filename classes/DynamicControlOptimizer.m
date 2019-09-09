classdef DynamicControlOptimizer < SteadyStateControlOptimizer
  properties
    generator=TwoCellFSPGenerator
    time
    uRange=linspace(0,1,100);
  end
  methods
    function obj=DynamicControlOptimizer()
    end
    function getSnapshotScore(time)
      probability=obj.model.snapTime(time);
      score=obj.score.getScore(probability);
    end
    function model=optimize(obj,model)
      obj.model=model;
      for i=1:length(obj.time)
        
        probability=obj.getProbability();
        obj=obj.opimizeStep(probability);
        obj.integrateTimeStep();
      end
    end
    function obj=optimizeStep(obj,probability)
      lenRange=length(obj.uRange)
      for i=1:lenRange
        infG=obj.generator.getInfGenerator(obj.uRange(i));
        infScore(i)=obj.score.getScore(infG*probability(:)');
      end
      [controlInput,index]=min(infScore);
      obj.controlInput=controlInput;
    end
    function convertToHistogram(obj,trajectory)
      
    end
    function integrateTimeStep(obj,dt)
      
    end
  end
end