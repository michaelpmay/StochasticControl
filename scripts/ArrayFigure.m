classdef ArrayFigure < Visual
  properties
    figsize=[16,10]
  end
  methods
    function obj=ArrayFigure(model)
      obj.model=model;
      obj.frame=obj.initializeFrame();
    end
    function plot(obj)
      for i=1:3
      end
    end
    function index=subplotmap(obj,indI,indJ,maxI,maxJ)
      index=(indJ-1)*maxI+indI
    end
  end
end