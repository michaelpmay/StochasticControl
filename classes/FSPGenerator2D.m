classdef FSPGenerator2D
  methods
    function stateSpaceStoich=makeSingleRxnInfGen(obj,rxnIndex)
      xMap=0:(obj.dims(1)-1);
      yMap=0:(obj.dims(2)-1);
      stateSpaceStoich=obj.preAllocateInfGenTensor;
      rxnVec=obj.model.stoichMatrix(:,rxnIndex);
      for i=1:length(xMap)
        for j=1:length(ymap)
          state=[xMap(i),yMap(j)];
          if obj.isInStateSpace(state+rxnVec);
            stateSpaceStoich=obj.connectStates(state,state+rxnVec,stateSpaceStoich,rxnIndex);
          end
        end
      end
    end
  end
end
