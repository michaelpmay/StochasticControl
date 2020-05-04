classdef SimpleFeedbackControler < FeedbackControler
  properties
    uOptimal
    linearResponseArray
    score
    alpha=5
  end
  methods
    function obj=SimpleFeedbackControler(inputArray)
      obj.linearResponseArray=ControlInputArray(inputArray);
      score=ProbabilityScore(inputArray);
      obj.uOptimal=obj.loadOptimalControler();
    end
    function response=respond(obj,error)
      response=obj.linearResponseArray.get*error+obj.uOptimal;
    end
    function obj=setArray(obj,array)
      obj.array=array;
    end
    function controlInput=loadOptimalControler(obj)
      load inFiles/autoregulatedReducedControler_110gmres.mat
    end
    function obj=updateLra(obj,B,P,E)
      C=obj.score.C;
      L=-(C'*(B.*P'))'.*E'*obj.alpha;
      obj.linearResponseArray=L;
    end
  end
end