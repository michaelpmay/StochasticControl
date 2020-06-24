classdef DataSaver
properties
    strategy
  end
  methods
    function save(obj,model,filename)
      extension=obj.getExtension(filename);
      obj=obj.setStrategyFromExtensionAndDataType(extension,data);
      obj.strategy.save(model,filename);
    end
    function ext=getExtension(obj,filename)
      [~,~,ext] = fileparts(filename);
    end
    function obj=setStrategyFromExtensionandDataType(obj,extension,classname)
      
    end
  end
end