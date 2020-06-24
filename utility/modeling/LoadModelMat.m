classdef LoadModelMat
  properties
  end
  methods
    function model=load(obj,fileName)
      load(fileName)
      model=ModelPlugin;
      model.stoichMatrix=stoichMatrix;
      model.rxnRate=rxnRate;
      model.initialState=initialState;
      model.time=time;
      model.name=name;
      model.description=description;
      model.parameters=parameters;
    end
  end
end