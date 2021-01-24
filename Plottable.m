classdef Plottable
  properties
    data
    plotFunction
  end
  methods
    function plot(obj,ax)
      obj.plotFunction(ax)
    end
  end
end