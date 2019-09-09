classdef DynamicControlOptimizer < SteadyStateControlOptimizer
  properties
    model
    score
  end
  methods
    function getSnapshotScore(time)
      probability=obj.model.snapTime(time);
      score=obj.score.getScore(probability);
    end
  end
end