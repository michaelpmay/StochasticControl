classdef SaveAsModelMat
  properties
  end
  methods
    function save(obj,model,fileName)
      stoichMatrix=model.stoichMatrix;
      rxnRate=model.rxnRate;
      initialState=model.initialState;
      time=model.time;
      name=model.name;
      description=model.description;
      parameters=model.parameters;
      save(fileName,'stoichMatrix','rxnRate','initialState','time','parameters','name','description');
    end
  end
end

