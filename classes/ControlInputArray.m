classdef ControlInputArray
  properties
    array
    upperBound
    lowerBound
  end
  methods
    function obj=ControlInputArray(thisArray)
      obj.array=thisArray;
    end
    function array=get(obj)
      array=obj.array;
    end
    function obj=set(obj,thisArray)
      if ~isempty(obj.upperBound)
        thisArray(thisArray>obj.upperBound)=obj.upperBound;
      end
      if ~isempty(obj.lowerBound)
        thisArray(thisArray<obj.lowerBound)=obj.lowerBound;
      end
      obj.array=thisArray;
    end
    function vector=v(obj)
      vector=obj.array(:);
    end
  end
end