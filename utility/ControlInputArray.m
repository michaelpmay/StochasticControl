classdef ControlInputArray
  properties
    array
    upperBound
    lowerBound
  end
  methods
    function obj=ControlInputArray(array)
      obj.array=array;
    end
    function input=getInput(obj,error)
      input=obj.array*error(:);
      input=obj.trim(input);
    end
    function array=get(obj)
      array=obj.array;
    end
    function obj=set(obj,input)
      input=obj.trim(input);
      obj.array=input;
    end
    function input=trim(obj,input)
      if ~isempty(obj.upperBound)
        input(input>obj.upperBound)=obj.upperBound;
      end
      if ~isempty(obj.lowerBound)
        input(input<obj.lowerBound)=obj.lowerBound;
      end
    end
    function vector=v(obj)
      vector=obj.array(:);
    end
  end
end