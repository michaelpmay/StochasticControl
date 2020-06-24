classdef LoadModelM
  properties
  end
  
  methods
    function model=load(obj,filename)
      run(filename);
      model=ModelPlugin;
      model.name=name;
      model.description=description;
      model.parameters=parameters;
      model.stoichMatrix=stoichMatrix;
      model.rxnRate=rxnRate;
      model.initialState=initialState;
      model.time=time;
    end
  end
end