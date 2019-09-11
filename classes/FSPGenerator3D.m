classdef FSPGenerator3D < FSPGenerator
  properties
  end
  methods
    function stateSpaceStoich=makeSingleRxnInfGen(obj,rxnIndex)
      xMap=0:(obj.dims(1)-1);
      yMap=0:(obj.dims(2)-1);
      zMap=0:(obj.dims(3)-1);
      stateSpaceStoich=obj.preAllocateInfGenTensor;
      rxnVec=obj.model.stoichMatrix(:,rxnIndex);
      for i=1:length(xMap)
        for j=1:length(yMap)
          for k=1:length(zmap)
            state=[xMap(i),yMap(j),zMap(j)];
            if obj.isInStateSpace(state+rxnVec)
              stateSpaceStoich=obj.connectStates(state,state+rxnVec,stateSpaceStoich,rxnIndex);
            end
          end
        end
      end
    end
  end
end