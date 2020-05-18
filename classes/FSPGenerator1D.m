classdef FSPGenerator1D < FSPGeneratorCore
  methods
    function stateSpaceStoich=makeSingleRxnInfGen(obj,rxnIndex)
      xMap=0:(obj.dims(1)-1);
      stateSpaceStoich=obj.preAllocateInfGenTensor;
      rxnVec=obj.model.stoichMatrix(:,rxnIndex);
      for i=1:length(xMap)
        state=xMap(i);
        if obj.isInStateSpace(state+rxnVec)
          stateSpaceStoich=obj.connectStates(state,state+rxnVec,stateSpaceStoich,rxnIndex);
        end
      end
    end
  end
end