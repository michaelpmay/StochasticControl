classdef IterableFspWithGenerators < IterableFsp
  properties
    generator={}
  end
  methods
    function obj=iterateGenerator(obj,index,time)
      obj=obj.iterate(obj.generator{index},time);
    end
    function obj=iterateStepGenerator(obj,index,time)
      obj=obj.iterateStep(obj.generator{index},time);
    end
    function probability=testGenerator(obj,index)
      probability=obj.test(obj.generator{index});
    end
  end
end
