classdef ModelSaver
  %saver examines the file extension and saves the data using the proper
  %format. Model Saver is a strategy object.
  properties
    strategy
  end
  methods
    function save(obj,model,filename)
      extension=obj.getExtension(filename);
      obj=obj.setStrategyFromExtension(extension);
      obj.strategy.save(model,filename);
    end
    function ext=getExtension(obj,filename)
      [~,~,ext] = fileparts(filename);
    end
    function obj=setStrategyFromExtension(obj,extension)
      switch extension
        case '.mat'
          obj.strategy=SaveAsModelMat;
        case '.m'
          obj.strategy=SaveAsModelM;
        case '.xml'
          obj.strategy=SaveAsModelXml;
      end
    end
  end
end