classdef ModelMatFormater
  %takes a ModelPlugin and saves/loads it
  properties
    
  end
  methods
    function save(obj,model,location)
      parameters=model.parameters;
      rxnRate=model.rxnRate;
      stoichMatrix=model.stoichMatrix;
      initialState=model.initialState;
      time=model.time;
      name=model.name;
      description=model.description;
      save(location,'parameters','rxnRate','stoichMatrix','initialState','time','name','description');
    end
    function model=load(obj,fileName)
      load(fileName)
      model.parameters=parameters;
      model.rxnRate=rxnRate;
      model.stoichMatrix=stoichMatrix;
      model.initialState=initialState;
      model.timetime;
      model.name=name;
      model.description=description;
    end
  end
end