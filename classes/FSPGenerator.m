classdef FSPGenerator
  properties
    core
  end
  methods
    function obj=FSPGenerator()
    end
    function infGenerator=getInfGenerator(obj,model,dims)
      obj.core=obj.getCore(dims);
      infGenerator=obj.core.getInfGenerator(model,dims);
    end
    function core=getCore(obj,dims)
      N=length(dims);
      switch N
        case 1
          core=FSPGenerator1D;
        case 2
          core=FSPGenerator2D;
        case 3
          core=FSPGenerator3D;
        otherwise
          error('FSP GENERATOR IS SUPPORTED FOR 1D or 2D or 3D')
      end
    end
  end
end