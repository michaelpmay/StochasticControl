classdef FSPGenerator
  properties
    model
    dims
  end
  properties(Hidden)
    makeInfGen
  end
  methods
    function infGenerator=getInfGenerator(obj,model,dims)
      obj.model=model;
      obj.dims=dims;
      N=prod(obj.dims);
      infGenerator=obj.getInfGenTensor();
      infGenerator=reshape(infGenerator,[N,N]);
    end
    function stateSpaceStoich=getInfGenTensor(obj)
      stateSpaceStoich=obj.preAllocateInfGenTensor;
      for i=1:obj.numRxns
        stateSpaceStoich=stateSpaceStoich+obj.makeSingleRxnInfGen(i);
      end
    end
    function stateSpaceStoich=makeSingleRxnInfGen(obj,rxnIndex)
      error('ERROR: OVERWRITE THIS FUNCTION OR BAD THINGS HAPPEN')
    end
    function tfBool=isInStateSpace(obj,state)
      tfBool=true;
      for i=1:length(state)
        if (state(i) >= obj.dims(i)) || (state(i)<0)
          tfBool=false;
        end
      end
    end
    function stateSpaceStoich=connectStates(obj,fromState,toState,stateSpaceStoich,rxnIndex,time)
      rxnRate=obj.model.evaluateRateEquation(0, fromState);
      toIndex=num2cell([toState',fromState']+1);
      fromIndex=num2cell([fromState',fromState']+1);
      stateSpaceStoich(toIndex{:})=rxnRate(rxnIndex);%positive A^I_J
      stateSpaceStoich(fromIndex{:})=-rxnRate(rxnIndex);%negative A^I_I
    end
    function tensor=preAllocateInfGenTensor(obj)
      tensorDims=[obj.dims,obj.dims];
      tensor=zeros(tensorDims);
    end
    function n=numRxns(obj)
      n=size(obj.model.stoichMatrix,2);
    end
  end
end