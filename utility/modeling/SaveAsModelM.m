classdef SaveAsModelM
  properties
  end
  
  methods
    function save(obj,model,filename)
      stoichMatrix=mat2str(model.stoichMatrix);
      rxnRate=func2str(model.rxnRate);
      initialState=mat2str(model.initialState);
      parameters=mat2str(model.parameters);
      name=model.name;
      description=model.description;
      time=mat2str(model.time);
      fileID = fopen(filename,'w');
      fprintf(fileID,"name = '%s';\n",name);
      fprintf(fileID,"description = '%s';\n",description);
      fprintf(fileID,"parameters = %s;\n",parameters);
      fprintf(fileID,"stoichMatrix = %s;\n",stoichMatrix);
      fprintf(fileID,"rxnRate = %s;\n",rxnRate);
      timeStepSizes=diff(model.time);
      tolerance=1e-10; 
      if all(abs(timeStepSizes-timeStepSizes(1))<tolerance)
        timeStart=mat2str(model.time(1));
        timeEnd=mat2str(model.time(end));
        timeStep=diff(model.time);
        fprintf(fileID,"time = %s:%s:%s;\n",timeStart,timeStep(1),timeEnd);
      else
        fprintf(fileID,"time = %s;\n",time);
      end
      fprintf(fileID,"initialState = %s;\n",initialState);
      fclose(fileID);
    end
  end
end