classdef ModelLoader
  properties
    strategy
  end
  methods
    function model=load(obj,filename)
      extension=obj.getExtension(filename);
      obj=obj.setStrategyFromExtension(extension);
      model=obj.strategy.load(filename);
    end
    function ext=getExtension(obj,filename)
      [~,~,ext] = fileparts(filename);
    end
    function obj=setStrategyFromExtension(obj,extension)
      switch extension
        case '.mat'
          obj.strategy=LoadModelMat;
        case '.m'
          obj.strategy=LoadModelM;
        case '.xml'
          obj.strategy=LoadModelXml;
      end
    end
  end
end 