classdef ArrayFig
  properties
    agModelControl=loadObj('outFiles/target30_10/agModel_98_3445');
    auModelControl=loadObj('outFiles/target30_10/auModel_402_6431');
    ugModelControl=loadObj('outFiles/target30_10/ugModel_237_0000');
    uuModelControl=loadObj('outFiles/target30_10/uuModel_240_0000');
  end
  methods
    function obj=ArrayFig()
      AcademicFigure()
      target=obj.uuModelControl.target;
      obj.plotModel(obj.uuModelControl.model,1,target)
      obj.plotModel(obj.ugModelControl.model,2,target)
      obj.plotModel(obj.auModelControl.model,3,target)
      obj.plotModel(obj.agModelControl.model,4,target)
    end
    function plotModel(obj,model,colNum,target)
      subplotIndex=[0 4 8];
      view=ViewModelFSP(model,subplot(3,4,subplotIndex(1)+colNum))
      view.plotSampledSumForces(4)
      view=ViewModelFSP(model,subplot(3,4,subplotIndex(2)+colNum))
      view.plotSteadyStateWithTarget(target)
      view=ViewModelFSP(model,subplot(3,4,subplotIndex(3)+colNum))
      view.plotMarginals()
    end
  end
end