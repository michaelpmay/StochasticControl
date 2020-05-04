classdef ArrayFigureView
  properties
    modelControler=[]
  end
  methods
    function obj=ArrayFigureView(controlerArray)
      obj.modelControler=controlerArray;
    end
    function plot(obj)
      AcademicFigure();
      hold on
      for i=1:4
        obj.subPlot(i,i);
      end
      hold off
    end
    function subPlot(obj,controlIndex,colIndex)
      subplotIndex=[0 4 8];
      view=ViewTwoCellFSP(obj.modelControler{controlIndex}.model,subplot(3,4,subplotIndex(1)+colIndex));
      view.plotSampledSumForces(4);
      view=ViewTwoCellFSP(obj.modelControler{controlIndex}.model,subplot(3,4,subplotIndex(2)+colIndex));
      view.plotSteadyStateWithTarget(obj.modelControler{controlIndex}.score.target);
      view=ViewTwoCellFSP(obj.modelControler{controlIndex}.model,subplot(3,4,subplotIndex(3)+colIndex));
      view.plotMarginals();
    end
  end
end