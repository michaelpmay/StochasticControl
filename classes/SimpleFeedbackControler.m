classdef SimpleFeedbackControler < FeedbackControler
  properties
    uOptimal
    linearResponseArray
    score
    time
  end
  methods
    function obj=SimpleFeedbackControler(inputArray)
      obj.linearResponseArray=ControlInputArray(inputArray);
      score=ProbabilityScore(inputArray);
    end
    function response=respond(obj,error)
      response=obj.linearResponseArray.get*error;
    end
  end
end