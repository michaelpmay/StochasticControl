classdef AxesLayer
  properties
    dataFileName='data/file/data'
    datalayer=DataLayer
  end
  methods
    function axes=TestFile(obj)
      data=obj.datalayer.TestFile;
    end
    function axes=AnalysisODEFrequencyOmegaCrit_ReducedModel(obj,ax)
      data=obj.datalayer.get('AnalysisODEFrequencyOmegaCrit_ReducedModel');
      hold(ax,'on');
      line1=plot(ax,linspace(0,2,51),data.wHigh_LIC.state((end-50):end),'g-','LineWidth',3)
      line1.Color=[0 1 0];
      line2=plot(ax,linspace(0,2,51),data.wHigh_HIC.state((end-50):end),'g--','LineWidth',3)
      line2.Color=[0 .5 1];
      line3=plot(ax,linspace(0,2,51),data.wLow_LIC.state((end-50):end),'r-.','LineWidth',3)
      line3.Color=[1 0 0];
      line4=plot(ax,linspace(0,2,51),data.wLow_HIC.state((end-50):end),'r--','LineWidth',3)
      line4.Color=[1 .5 0];
    end
    function axes=AnalysisODESSAFrequency_ReducedModel_Trajectory(obj)
      data=obj.datalayer.get('AnalysisODESSAFrequency_ReducedModel');
      midpoint=(data.ODE_HIC.state+data.ODE_LIC.state)/2;
      traj=data.SSA.node{1}.state((end-1500):end)>midpoint((end-1500):end);
      time=data.SSA.node{1}.time(1:1501);
      hold on
      for i=2:2:length(traj)
        xl=[time(i-1) time(i+1)];
        yl=[0 60];
        if traj(i)==1
          p{i}=patch([xl(1),xl(2),xl(2),xl(1),xl(1)],...
            [yl(1),yl(1),yl(2),yl(2),yl(1)],'blue');
        else
          p{i}=patch([xl(1),xl(2),xl(2),xl(1),xl(1)],...
            [yl(1),yl(1),yl(2),yl(2),yl(1)],'red');
        end
        p{i}.FaceAlpha=.1;
        p{i}.EdgeAlpha=0;
        p{i}.HandleVisibility='off';
      end
      line4=plot(time,midpoint((end-1500):end),'k--','LineWidth',1,'Color',[1 1 1]*.45,'HandleVisibility','off')
      line1=plot(time,data.ODE_HIC.state((end-1500):end),'LineWidth',3,'Color',[0 0 1]);
      line2=plot(time,data.ODE_LIC.state((end-1500):end),'LineWidth',3,'Color',[1 0 0]);
      line3=plot(time,data.SSA.node{1}.state((end-1500):end),'LineWidth',3,'Color',[1 0 1])
      line3.Color=[1 0 1]*.7;
      
      axes=gca;
      box(axes)
      axes.Color=[1 1 1]*.95;
    end
    function axes=AnalysisFSPReducedModelControlPairs_UnregulatedUniform_Force(obj)
      data=obj.datalayer.get('AnalysisFSPReducedModelControlPairs_UnregulatedUniform');
      axes=obj.makePlotForce(data);
    end
    function axes=AnalysisFSPReducedModelControlPairs_UnregulatedUniform_JD(obj)
      data=obj.datalayer.get('AnalysisFSPReducedModelControlPairs_UnregulatedUniform');
      axes=obj.makePlotJointDistrbution(data);
    end
    function axes=AnalysisFSPReducedModelControlPairs_UnregulatedUniform_MD(obj)
      data=obj.datalayer.get('AnalysisFSPReducedModelControlPairs_UnregulatedUniform');
      axes=obj.makePlotMarginalDistribution(data);
    end
    function axes=AnalysisFSPReducedModelControlPairs_UnregulatedFull_Force(obj)
      data=obj.datalayer.get('AnalysisFSPReducedModelControlPairs_UnregulatedFull');
      obj.makePlotForce(data);
    end
    function axes=AnalysisFSPReducedModelControlPairs_UnregulatedFull_JD(obj)
      data=obj.datalayer.get('AnalysisFSPReducedModelControlPairs_UnregulatedFull');
      axes=obj.makePlotJointDistrbution(data);
    end
    function axes=AnalysisFSPReducedModelControlPairs_UnregulatedFull_MD(obj)
      data=obj.datalayer.get('AnalysisFSPReducedModelControlPairs_UnregulatedFull');
      axes=obj.makePlotMarginalDistribution(data);
    end
    function axes=AnalysisFSPReducedModelControlPairs_AutoregulatedUniform_Force(obj)
      data=obj.datalayer.get('AnalysisFSPReducedModelControlPairs_AutoregulatedUniform');
      obj.makePlotForce(data);
    end
    function axes=AnalysisFSPReducedModelControlPairs_AutoregulatedUniform_JD(obj)
      data=obj.datalayer.get('AnalysisFSPReducedModelControlPairs_AutoregulatedUniform');
      axes=obj.makePlotJointDistrbution(data);
    end
    function axes=AnalysisFSPReducedModelControlPairs_AutoregulatedUniform_MD(obj)
      data=obj.datalayer.get('AnalysisFSPReducedModelControlPairs_AutoregulatedUniform');
      axes=obj.makePlotMarginalDistribution(data);
    end
    function axes=AnalysisFSPReducedModelControlPairs_AutoregulatedFull_Force(obj)
      data=obj.datalayer.get('AnalysisFSPReducedModelControlPairs_AutoregulatedFull');
      obj.makePlotForce(data);
    end
    function axes=AnalysisFSPReducedModelControlPairs_AutoregulatedFull_JD(obj)
      data=obj.datalayer.get('AnalysisFSPReducedModelControlPairs_AutoregulatedFull');
      axes=obj.makePlotJointDistrbution(data);
    end
    function axes=AnalysisFSPReducedModelControlPairs_AutoregulatedFull_MD(obj)
      data=obj.datalayer.get('AnalysisFSPReducedModelControlPairs_AutoregulatedFull');
      axes=obj.makePlotMarginalDistribution(data);
    end
    function axes=AnalysisFSPReducedModelControlPairs_AutoregulatedReduced_Force(obj)
      data=obj.datalayer.get('AnalysisFSPReducedModelControlPairs_AutoregulatedReduced');
      obj.makePlotForce(data);
    end
    function axes=AnalysisFSPReducedModelControlPairs_AutoregulatedReduced_JD(obj)
      data=obj.datalayer.get('AnalysisFSPReducedModelControlPairs_AutoregulatedReduced');
      axes=obj.makePlotJointDistrbution(data);
    end
    function axes=AnalysisFSPReducedModelControlPairs_AutoregulatedReduced_MD(obj)
      data=obj.datalayer.get('AnalysisFSPReducedModelControlPairs_AutoregulatedReduced');
      axes=obj.makePlotMarginalDistribution(data);
    end
    function axes=AnalysisSSAFullModelControlPairs_UnregulatedUniform_Input(obj)
      data=obj.datalayer.get('ControlInputs_FullModels');
      axes=pcolorProbability(data.UniformControlUnregulatedModelControler_FMCalibration);
    end
    function axes=AnalysisSSAFullModelControlPairs_UnregulatedUniform_JD(obj)
      data=obj.datalayer.get('AnalysisSSAFullModelControlPairs');
      axes=obj.makePlotJointDistrbution(data.UniformControlUnegulatedModelControler);
    end
    function axes=AnalysisSSAFullModelControlPairs_UnregulatedUniform_MD(obj)
      data=obj.datalayer.get('AnalysisSSAFullModelControlPairs');
      axes=obj.makePlotMarginalDistribution(data.UniformControlUnegulatedModelControler);
    end
    function axes=AnalysisSSAFullModelControlPairs_UnregulatedFull_Input(obj)
      data=obj.datalayer.get('ControlInputs_FullModels');
      axes=pcolorProbability(data.FullControlUnregulatedModelControler_FMCalibration);
    end
    function axes=AnalysisSSAFullModelControlPairs_UnregulatedFull_JD(obj)
      data=obj.datalayer.get('AnalysisSSAFullModelControlPairs');
      axes=obj.makePlotJointDistrbution(data.FullControlUnregulatedModelControler);
    end
    function axes=AnalysisSSAFullModelControlPairs_UnregulatedFull_MD(obj)
      data=obj.datalayer.get('AnalysisSSAFullModelControlPairs');
      axes=obj.makePlotMarginalDistribution(data.FullControlUnregulatedModelControler);
    end
    function axes=AnalysisSSAFullModelControlPairs_AutoregulatedUniform_Input(obj)
      data=obj.datalayer.get('ControlInputs_FullModels');
      axes=pcolorProbability(data.UniformControlAutoregulatedModelControler_FMCalibration);
    end
    function axes=AnalysisSSAFullModelControlPairs_AutoregulatedUniform_JD(obj)
      data=obj.datalayer.get('AnalysisSSAFullModelControlPairs');
      axes=obj.makePlotJointDistrbution(data.UniformControlAutoregulatedModelControler);
    end
    function axes=AnalysisSSAFullModelControlPairs_AutoregulatedUniform_MD(obj)
      data=obj.datalayer.get('AnalysisSSAFullModelControlPairs');
      axes=obj.makePlotMarginalDistribution(data.UniformControlAutoregulatedModelControler);
    end
    function axes=AnalysisSSAFullModelControlPairs_AutoregulatedFull_Input(obj)
      data=obj.datalayer.get('ControlInputs_FullModels');
      axes=pcolorProbability(data.FullControlAutoregulatedModelControler_FMCalibration);
    end
    function axes=AnalysisSSAFullModelControlPairs_AutoregulatedFull_JD(obj)
      data=obj.datalayer.get('AnalysisSSAFullModelControlPairs');
      axes=obj.makePlotJointDistrbution(data.FullControlAutoregulatedModelControler);
    end
    function axes=AnalysisSSAFullModelControlPairs_AutoregulatedFull_MD(obj)
      data=obj.datalayer.get('AnalysisSSAFullModelControlPairs');
      axes=obj.makePlotMarginalDistribution(data.FullControlAutoregulatedModelControler);
    end
    function axes=AnalysisSSAFullModelControlPairs_AutoregulatedReduced_Input(obj)
      data=obj.datalayer.get('ControlInputs_FullModels');
      axes=pcolorProbability(data.ReducedControlAutoregulatedModelControler_FMCalibration);
    end
    function axes=AnalysisSSAFullModelControlPairs_AutoregulatedReduced_JD(obj)
      data=obj.datalayer.get('AnalysisSSAFullModelControlPairs');
      axes=obj.makePlotJointDistrbution(data.ReducedControlAutoregulatedModelControler);
    end
    function axes=AnalysisSSAFullModelControlPairs_AutoregulatedReduced_MD(obj)
      data=obj.datalayer.get('AnalysisSSAFullModelControlPairs');
      axes=obj.makePlotMarginalDistribution(data.ReducedControlAutoregulatedModelControler);
    end
    function axes=ModelFitODE_Panel(obj)
      xBox = [0, 0, 270, 270, 0];
      yBox = [0, 25, 25, 0, 0];
      p1=patch(xBox, yBox, 'black', 'FaceColor', 'blue', 'FaceAlpha', 0.25, 'EdgeAlpha', 0);
      set(p1, 'HandleVisibility', 'off');
      xBox = [270, 270, 570, 570, 0];
      yBox = [0, 25, 25, 0, 0];
      
      p2=patch(xBox, yBox, 'black', 'FaceColor', 'blue', 'FaceAlpha', 0.05, 'EdgeAlpha', 0);
      set(p2, 'HandleVisibility', 'off');
      xBox = [570, 570, 780, 780, 0];
      yBox = [0, 25, 25, 0, 0];
      p3=patch(xBox, yBox, 'black', 'FaceColor', 'blue', 'FaceAlpha', 0.1, 'EdgeAlpha', 0);
      set(p3, 'HandleVisibility', 'off');
      ylim([0 22])
    end
    function axes=ModelFitODE_UnregulatedFullModel_Trajectory(obj)
      data=obj.datalayer.get('ModelFitODEUnregulatedFullModel');
      axes=plot(data.time,data.state(5,:),'r-.','Linewidth',3);
    end
    function axes=ModelFitODE_UnregulatedReducedModel_Trajectory(obj)
      data=obj.datalayer.get('ModelFitODEUnregulatedReducedModel');
      hold on
      line1=plot(data.time,data.state,'b-','Linewidth',3);
      
    end
    function axes=ModelFitODE_ExperimentalData_Trajectory(obj)
      data=obj.datalayer.get('ModelFitODE_ExperimentalData')
      axes=plot(data.time,data.state/max(data.state)*20,'k.','MarkerSize',24)
    end
    function axes=ModelFitODEUnregulatedReducedModel_Calibration(obj)
      data=obj.datalayer.get('ModelFitODEUnregulatedReducedModel_Calibration');
      hold on
      line1=plot(data.calibration(2,:),data.calibration(1,:),'LineWidth',3);
      line2=plot(data.TruePoints(2,:),data.TruePoints(1,:),'k.','MarkerSize',24);
      line2.HandleVisibility='off';
      axes=gca;
      axes.Color=[1 1 1]*.95;
      axes.XGrid = 'on';
    end
    function axes=ModelFitODEUnregulatedFullModel_Calibration(obj)
      data=obj.datalayer.get('ModelFitODEUnregulatedFullModel_Calibration');
      hold on
      line1=plot(data.calibration(2,:),data.calibration(1,:),'LineWidth',3);
      line2=plot(data.TruePoints(2,:),data.TruePoints(1,:),'k.','MarkerSize',24);
      line2.HandleVisibility='off';
      axes=gca;
      axes.Color=[1 1 1]*.95;
      axes.XGrid = 'on';
    end
    function axes=ModelFitSSAUnregulatedReducedModel_Low_Histogram(obj)
      data=obj.datalayer.get('ModelFitSSAUnregulatedReducedModel_Low');
      h1=histogram(data.state,[0:60],'normalization','Probability', 'EdgeAlpha', 0);
      h1.FaceColor=[1 0 0];
      axes=gca;
      axes.Color=[1 1 1]*.95;
      box(axes,'on');
    end
    function axes=ModelFitSSAUnregulatedReducedModel_Med_Histogram(obj)
      data=obj.datalayer.get('ModelFitSSAUnregulatedReducedModel_Med');
      h1=histogram(data.state,[0:60],'normalization','Probability', 'EdgeAlpha', 0);
      h1.FaceColor=[1 .25 0];
      axes=gca;
      box(gca,'on');
    end
    function axes=ModelFitSSAUnregulatedReducedModel_Hig_Histogram(obj)
      data=obj.datalayer.get('ModelFitSSAUnregulatedReducedModel_Hig');
      h1=histogram(data.state,[0:60],'normalization','Probability', 'EdgeAlpha', 0);
      h1.FaceColor=[1 .5 0];
      axes=gca;
      box(axes,'on');
    end
    function axes=ModelFitSSAUnregulatedReducedModel_Calib_Histogram(obj)
      data=obj.datalayer.get('ModelFitSSAUnregulatedReducedModel_Calib');
      h1=histogram(data.state,[0:50],'normalization','Probability','DisplayStyle','stairs','LineWidth',3);
      h1.EdgeColor=[0 .25 1];
      axes=gca;
      box(gca,'on');
    end
    function axes=ModelFitSSAUnregulatedReducedModel_Calib_Mean(obj,ax,position)
      data=obj.datalayer.get('ModelFitSSAUnregulatedReducedModel_Calib');
      h1=text(ax,position(1),position(2),sprintf('Mean=%0.1f',mean(data.state(4500:end))));
    end
    function axes=ModelFitSSAUnregulatedFullModel_Low_Histogram(obj)
      data=obj.datalayer.get('ModelFitSSAUnregulatedFullModel_Low');
      h1=histogram(data.state,[0:60],'normalization','Probability', 'EdgeAlpha', 0);
      h1.FaceColor=[0 0 1];
      axes=gca;
      axes.Color=[1 1 1]*.95;
      box(axes,'on');
    end
    function axes=ModelFitSSAUnregulatedFullModel_Med_Histogram(obj)
      data=obj.datalayer.get('ModelFitSSAUnregulatedFullModel_Med');
      h1=histogram(data.state,[0:60],'normalization','Probability', 'EdgeAlpha', 0);
      h1.FaceColor=[0 .25 1];
      axes=gca;
      box(gca,'on');
    end
    function axes=ModelFitSSAUnregulatedFullModel_Hig_Histogram(obj)
      data=obj.datalayer.get('ModelFitSSAUnregulatedFullModel_Hig');
      h1=histogram(data.state,[0:60],'normalization','Probability', 'EdgeAlpha', 0);
      h1.FaceColor=[0 .5 1];
      axes=gca;
      box(axes,'on');
    end
    function axes=ModelFitSSAUnregulatedFullModel_Calib_Histogram(obj)
      data=obj.datalayer.get('ModelFitSSAUnregulatedFullModel_Calib');
      h1=histogram(data.state,[0:50],'normalization','Probability','DisplayStyle','stairs','LineWidth',3);
      h1.EdgeColor=[1 .25 0];
      axes=gca;
      box(gca,'on');
    end
    function axes=ModelFitSSAUnregulatedFullModel_Calib_Mean(obj,ax,position)
      data=obj.datalayer.get('ModelFitSSAUnregulatedFullModel_Calib');
      h1=text(ax,position(1),position(2),sprintf('Mean=%0.1f',mean(data.state(5,4500:end))));
    end
    function ax=AnalysisODEHysteresis_Regions(obj,ax)
      hold(ax,'on')
      data=obj.datalayer.get('AnalysisODEHysteresis_ReducedModelAutoregulated');
      X=[data.LowerBound data.UpperBound];
      xBox = [0, 0, X(1), X(1), 0];
      yBox = [0, 120, 120, 0, 0];
      p1=patch(ax,xBox, yBox, 'black', 'FaceColor', 'black', 'FaceAlpha', 0.05, 'EdgeAlpha', 0);
      set(p1, 'HandleVisibility', 'off');
      xBox = [X(1), X(1), X(2), X(2), 0];
      yBox = [0, 120, 120, 0, 0];
      p2=patch(ax,xBox, yBox, 'black', 'FaceColor', 'black', 'FaceAlpha', 0.2, 'EdgeAlpha', 0);
      set(p2, 'HandleVisibility', 'off');
      xBox = [X(2), X(2), 1, 1, 0];
      yBox = [0, 120, 120, 0, 0];
      p3=patch(ax,xBox, yBox, 'black', 'FaceColor', 'black', 'FaceAlpha', 0.05, 'EdgeAlpha', 0);
      set(p3, 'HandleVisibility', 'off');
      line1=plot(ax,[data.UpperBound,data.UpperBound],[0 50],'k--','LineWidth',.5)
      line1.HandleVisibility='off';
      line2=plot(ax,[data.LowerBound,data.LowerBound],[0 50],'k--','LineWidth',.5)
      line2.HandleVisibility='off';
      hold(ax,'off')
    end
    function ax=AnalysisODEHysteresis_ReducedModelAutoregulated(obj,ax)
      data=obj.datalayer.get('AnalysisODEHysteresis_ReducedModelAutoregulated');
      hold(ax,'on')
      line2=plot(ax,data.range,data.upTrajectory,'b-','LineWidth',3);
      line2.Color=[0 0 1];
      %line2.MarkerSize=10;
      line1=plot(ax, data.range,data.downTrajectory,'b--','LineWidth',3);
      line1.Color=[0 .5 1];
      %line1.MarkerSize=3;
    end
    function ax=AnalysisODEHysteresis_ReducedModelUnregulated(obj,ax)
      data=obj.datalayer.get('AnalysisODEHysteresis_ReducedModelUnregulated');
      hold(ax,'on')
      line1=plot(ax,data.range,data.upTrajectory,'k-','LineWidth',3);
      line1.Color=[1 0 0];
      line2=plot(ax,data.range,data.downTrajectory,'k--','LineWidth',3);
      line2.Color=[1 .5 0];
    end
    function ax=AnalysisODEFrequency_ReducedModels_Input(obj,ax)
      hold(ax,'on')
      data1=obj.datalayer.get('AnalysisODEFrequencySeparation_ReducedModels');
      data2=obj.datalayer.get('AnalysisODEHysteresis_ReducedModelAutoregulated');
      line2=plot(ax,data1.time,data2.UpperBound*ones(size(data1.time)),'k--','Linewidth',.5);
      line3=plot(ax,data1.time,data2.LowerBound*ones(size(data1.time)),'k--','Linewidth',.5);
      line1=plot(ax,data1.time,data1.input,'m-','LineWidth',3);
      xBox = [0, 0, 2, 2, 0];
      yBox = [data2.LowerBound, data2.UpperBound, data2.UpperBound, data2.LowerBound, data2.LowerBound];
      p1=patch(ax,xBox, yBox, 'black', 'FaceColor', 'black', 'FaceAlpha', 0.1, 'EdgeAlpha', 0);
      set(p1, 'HandleVisibility', 'off');
    end
    function ax=AnalysisODEFrequencySeparation_ReducedModel(obj,ax)
      data=obj.datalayer.get('AnalysisODEFrequencySeparation_ReducedModels');
      range1=linspace(0,2,201);
      range2=linspace(0,2,2001);
      hold(ax,'on')
      line3=plot(ax,range2,data.trajectory_LIC_w0p0001.state((end-2000):end),'g-','LineWidth',3);
      line4=plot(ax,range2,data.trajectory_HIC_w0p0001.state((end-2000):end),'g--','LineWidth',3);
      line4.Color=[0 .5 1];
      line1=plot(ax,range1,data.trajectory_LIC_w0p01.state((end-200):end),'r-.','LineWidth',3);
      line2=plot(ax,range1,data.trajectory_HIC_w0p01.state((end-200):end),'r--','LineWidth',3);
      line2.Color=[1 .5 0];
    end
    function ax=AnalysisSSATwoCellSwapReducedModel_ControlInput(obj,ax)
      data=obj.datalayer.get('AnalysisSSATwoCellSwapReducedModel');
      axis1=area(ax,data.trajectory.node{1}.time(1:length(data.U)),data.U,'FaceColor','m');
      axis1.EdgeAlpha=0;
    end
    function ax=AnalysisSSATwoCellSwapReducedModel_Patches(obj,ax)
      hold(ax,'on')
      v = [0 0; 1000,0; 1000,60; 0,60];
      f = [1 2 3 4];
      patch(ax,'Faces',f,'Vertices',v,'FaceColor','blue','FaceAlpha',.1)
      v = [1000 0; 2000,0; 2000,60; 1000,60];
      f = [1 2 3 4];
      patch(ax,'Faces',f,'Vertices',v,'FaceColor','red','FaceAlpha',.1)
      v = [2000 0; 3000,0; 3000,60; 2000,60];
      f = [1 2 3 4];
      patch(ax,'Faces',f,'Vertices',v,'FaceColor','blue','FaceAlpha',.1)
    end
    function ax=AnalysisSSATwoCellSwapReducedModel_Trajectory(obj,ax)
      hold(ax,'on')
      data=obj.datalayer.get('AnalysisSSATwoCellSwapReducedModel')
      plot(ax,data.trajectory.node{1}.time,30*ones(size(data.trajectory.node{1}.time)),'k-','LineWidth',1);
      plot(ax,data.trajectory.node{1}.time,10*ones(size(data.trajectory.node{1}.time)),'k-','LineWidth',1);
      s1=stairs(ax,data.trajectory.node{1}.time,data.trajectory.node{1}.state(1,:)','LineWidth',2);
      s1.Color=[0 0 1]*.8;
      s2=stairs(ax,data.trajectory.node{1}.time,data.trajectory.node{1}.state(2,:)','LineWidth',2);
      s2.Color=[1 0 0]*.8;
      plot(ax,[1000,1000],[0 80],'k-');
      plot(ax,[2000,2000],[0 80],'k-');
      axis(ax,[0 3000 0 60])
      ax=gca;
    end
    function ax=AnalysisSSATwoCellSwapReducedModel_HistogramTarget(obj,ax)
      data=obj.datalayer.get('AnalysisSSATwoCellSwapReducedModel');
      hold(ax,'on')
      axes(ax);
      obj.makePlotHistogram(data.initialTargetData(:),0:60-.5,[1 .75 0],.6)
      obj.makePlotHistogram(data.finalTargetData(:),0:60-.5,'red',.4)
      plot((0:49),data.targetMarginal,'g-.','color',[0 0 0]+.1,'linewidth',2)
    end
    function ax=AnalysisSSATwoCellSwapReducedModel_HistogramNonTarget(obj,ax)
      data=obj.datalayer.get('AnalysisSSATwoCellSwapReducedModel');
      hold(ax,'on');
      axes(ax);
      obj.makePlotHistogram(data.initialNonTargetData(:),0:60-.5,'cyan',.6)
      obj.makePlotHistogram(data.finalNonTargetData(:),0:60-.5,'blue',.4)
      plot((0:49),data.nonTargetMarginal,'g-.','color',[0 0 0]+.1,'linewidth',2)
      ax=gca;
      axis([0 60 0 .2])
    end
    function ax=AnalysisSSAFourCellSwapReducedModel_ControlInput(obj,ax)
      data=obj.datalayer.get('AnalysisSSAFourCellSwapReducedModel');
      hold(ax,'on')
      area1=area(ax,data.trajectory.node{1}.time(1:length(data.U)),data.U,'FaceColor','m');
      area1.EdgeAlpha=0;
    end
    function ax=AnalysisSSAFourCellSwapReducedModel_Patches(obj,ax)
      v = [0 0; 1000,0; 1000,60; 0,60];
      f = [1 2 3 4];
      patch(ax,'Faces',f,'Vertices',v,'FaceColor','blue','FaceAlpha',.1)
      v = [1000 0; 2000,0; 2000,60; 1000,60];
      f = [1 2 3 4];
      patch(ax,'Faces',f,'Vertices',v,'FaceColor','red','FaceAlpha',.1)
      v = [2000 0; 3000,0; 3000,60; 2000,60];
      f = [1 2 3 4];
      patch(ax,'Faces',f,'Vertices',v,'FaceColor','green','FaceAlpha',.1)
    end
    function ax=AnalysisSSAFourCellSwapReducedModel_Trajectory(obj,ax)
      data=obj.datalayer.get('AnalysisSSAFourCellSwapReducedModel');
      hold(ax,'on')
      axes(ax);
      plot(data.trajectory.node{1}.time,30*ones(size(data.trajectory.node{1}.time)),'k-','LineWidth',1);
      plot(data.trajectory.node{1}.time,10*ones(size(data.trajectory.node{1}.time)),'k-','LineWidth',1);
      s1=stairs(ax,data.trajectory.node{1}.time,data.trajectory.node{1}.state(1,:)','LineWidth',2);
      s1.Color=[0 0 1]*.8;
      s2=stairs(ax,data.trajectory.node{1}.time,data.trajectory.node{1}.state(2,:)','LineWidth',2);
      s2.Color=[1 0 0]*.8;
      s3=stairs(ax,data.trajectory.node{1}.time,data.trajectory.node{1}.state(3,:)','LineWidth',2);
      s3.Color=[0 1 0]*.8;
      s4=stairs(ax,data.trajectory.node{1}.time,data.trajectory.node{1}.state(4,:)','LineWidth',1);
      s4.Color=[.5 .5 .5]*.8;
      plot(ax,[1000,1000],[0 80],'k-');
      plot(ax,[2000,2000],[0 80],'k-');
      axis([0 3000 0 60])
      ax=gca;
    end
    function ax=AnalysisSSAFourCellSwapReducedModel_HistogramTarget(obj,ax)
      data=obj.datalayer.get('AnalysisSSAFourCellSwapReducedModel');
      hold(ax,'on')
      axes(ax);
      obj.makePlotHistogram(data.initialTargetData(:),0:60-.5,[1 .75 0],.6)
      obj.makePlotHistogram(data.finalTargetData(:),0:60-.5,'red',.4)
      plot(ax,(0:49),data.targetMarginal,'g-.','color',[0 0 0]+.1,'linewidth',2)
    end
    function ax=AnalysisSSAFourCellSwapReducedModel_HistogramNonTarget(obj,ax)
      data=obj.datalayer.get('AnalysisSSAFourCellSwapReducedModel');
      hold(ax,'on')
      axes(ax);
      obj.makePlotHistogram(data.initialNonTargetData(:),0:60-.5,'cyan',.6)
      obj.makePlotHistogram(data.finalNonTargetData(:),0:60-.5,'blue',.4)
      plot(ax,(0:49),data.nonTargetMarginal,'g-.','color',[0 0 0]+.1,'linewidth',2)
    end
    function ax=AnalysisSSAFSPPredictiveReducedModelReducedControl_ControlInput(obj,ax)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveReducedModelReducedControl');
      area1=area(ax,data.time,data.U,'FaceColor','m');
      area1.EdgeAlpha=0;
    end
    function ax=AnalysisSSAFSPPredictiveReducedModelReducedControl_Trajectory(obj,ax)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveReducedModelReducedControl');
      hold(ax,'on')
      [X,Y]=meshgrid(data.time,0:49);
      pcolorplot=pcolor(ax,X,Y,data.P);
      pcolorplot.EdgeAlpha=0;
      colormap(flipud(gray))
      set(ax,'handlevisibility','off')
      caxis(ax,[0 0.2])
      hold(ax,'on')
      plot(ax,data.time,data.X,'LineWidth',2)
      plot(ax,data.time,data.Y,'LineWidth',2)
      plot(ax,data.time,data.predictionY,'LineWidth',2)
      xlim(ax,[0 3000]);
    end
    function ax=AnalysisSSAFSPPredictiveReducedModelReducedControl_JD(obj,ax)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveReducedModelReducedControl');
      [xVec]=[1:(size(data.steadystate,1))]-1;
      [yVec]=[1:(size(data.steadystate,2))]-1;
      [X,Y]=meshgrid(xVec,yVec);
      hold on
      pFig=pcolor(X,Y,data.steadystate);
      pFig.EdgeAlpha=0;
      axis([0,50,0,50]);
      cmap=hot;
      colormap(gca,cmap(20:end,:))
      blueX=scatter(data.target(2),data.target(1),30,'wo');
      blueX.MarkerEdgeColor=[1 1 1];
      blueX.LineWidth=2;
      caxis(ax,[0 .04])
    end
    function axes=AnalysisSSAFSPPredictiveReducedModelReducedControl_MD(obj,ax)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveReducedModelReducedControl');
      hold(ax,'on')
      plot([data.target(1) data.target(1)],[0 1],'b--','HandleVisibility','off')
      plot(data.target(1),0,'bp','Markersize',10,'MarkerFaceColor' ,'blue','HandleVisibility','off')
      plot([data.target(2) data.target(2)],[0 1],'r--','HandleVisibility','off')
      plot(data.target(2),0,'rp','Markersize',10,'MarkerFaceColor','red','HandleVisibility','off')
      xMarginal=sum(data.steadystate,2);
      yMarginal=sum(data.steadystate,1);
      lineP1ot1=plot(ax,0:(length(xMarginal)-1),xMarginal,'b-');
      lineP1ot1.LineWidth=3;
      linePlot2=plot(ax,0:(length(yMarginal)-1),yMarginal,'r-.');
      linePlot2.LineWidth=3;
      ylim(ax,[0,.2])
      xlim(ax,[0 50])
      axes=gca;
      axes.YGrid='on';
      text(31,.16,sprintf('J= %.0f',data.Pscore),'FontSize',11,'FontWeight','bold');
      xlabel('Species Count')
      ylabel('Probability')
      axes=gca;
      axes.Color=[1 1 1]*.95;
    end
    function ax=AnalysisSSAFSPPredictiveReducedModelReducedControl_ScoreDist(obj,ax)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveReducedModelReducedControl');
      hold(ax,'on')
      h1=histogram(ax,data.TScore.^.5,0:2:50-1,'Normalization','probability');
      line=plot(ax,[data.Pscore.^.5,data.Pscore.^.5],[0,1],'k--','LineWidth',.1);
      h1.EdgeAlpha=0;
      h1.FaceColor=[0.4941 0.1843 0.5569];
      t=LabelPlot(sprintf('J = %0.0f',data.Pscore));
      t.Position(3)=[0.1192];
      ax.Color=[1 1 1]*.95;
    end
    function ax=AnalysisSSAFSPPredictiveReducedModelReducedControl_PScore(obj,ax,position)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveReducedModelReducedControl');
      text(ax,position(1),position(2),sprintf('J= %.0f',data.Pscore),'FontSize',11,'FontWeight','bold','Color',[1 1 1]);
      axis(ax,[0 50 0 50])
    end
    function ax=AnalysisSSAFSPPredictiveReducedModelControl_ControlInput(obj,ax)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveReducedModelControl');
      hold(ax,'on')
      area1=area(ax,data.time,data.U,'FaceColor','m');
      area1.EdgeAlpha=0;
    end
    function ax=AnalysisSSAFSPPredictiveReducedModelControl_Trajectory(obj,ax)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveReducedModelControl');
      hold(ax,'on')
      [X,Y]=meshgrid(data.time,0:49);
      pcolorplot=pcolor(ax,X,Y,data.P);
      pcolorplot.EdgeAlpha=0;
      colormap(ax,flipud(gray))
      set(ax,'handlevisibility','off')
      caxis(ax,[0 0.2])
      plot(ax,data.time,data.X,'LineWidth',2)
      plot(ax,data.time,data.Y,'LineWidth',2)
      plot(ax,data.time,data.predictionY,'LineWidth',2)
    end
    function ax=AnalysisSSAFSPPredictiveReducedModelControl_JD(obj,ax)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveReducedModelControl');
      [xVec]=[1:(size(data.steadystate,1))]-1;
      [yVec]=[1:(size(data.steadystate,2))]-1;
      [X,Y]=meshgrid(xVec,yVec);
      hold(ax,'on')
      pFig=pcolor(ax,X,Y,data.steadystate);
      pFig.EdgeAlpha=0;
      cmap=hot;
      colormap(ax,cmap(20:end,:))
      blueX=scatter(ax,data.target(2),data.target(1),30,'wo');
      blueX.MarkerEdgeColor=[1 1 1];
      blueX.LineWidth=2;
      caxis([0 .04])
    end
    function ax=AnalysisSSAFSPPredictiveReducedModelControl_PScore(obj,ax)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveReducedModelControl');
      text(ax,31,45,sprintf('J= %.0f',data.Pscore),'FontSize',11,'FontWeight','bold','Color',[1 1 1]);
      axis(ax,[0 50 0 50])
    end
    function ax=AnalysisSSAFSPPredictiveReducedModelControl_MD(obj,ax)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveReducedModelControl');
      hold(ax,'on')
      plot(ax,[data.target(1) data.target(1)],[0 1],'b--','HandleVisibility','off')
      plot(ax,data.target(1),0,'bp','Markersize',10,'MarkerFaceColor' ,'blue','HandleVisibility','off')
      plot(ax,[data.target(2) data.target(2)],[0 1],'r--','HandleVisibility','off')
      plot(ax,data.target(2),0,'rp','Markersize',10,'MarkerFaceColor','red','HandleVisibility','off')
      xMarginal=sum(data.steadystate,2);
      yMarginal=sum(data.steadystate,1);
      lineP1ot1=plot(ax,0:(length(xMarginal)-1),xMarginal,'b-');
      lineP1ot1.LineWidth=3;
      linePlot2=plot(ax,0:(length(yMarginal)-1),yMarginal,'r-.');
      linePlot2.LineWidth=3
      text(31,.16,sprintf('J= %.0f',data.Pscore),'FontSize',11,'FontWeight','bold');
    end
    function ax=AnalysisSSAFSPPredictiveReducedModelControl_ScoreDist(obj)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveReducedModelControl');
      hold on
      h1=histogram(data.TScore.^.5,0:2:50-1,'Normalization','probability');
      line=plot([data.Pscore.^.5,data.Pscore.^.5],[0,1],'k--','LineWidth',.1);
      h1.EdgeAlpha=0;
      h1.FaceColor=[0.4941 0.1843 0.5569];
      xlabel('Distance')
      ylabel('Probability')
      axes=gca;
      box(axes);
      t=LabelPlot(sprintf('J = %0.0f',data.Pscore));
      t.Position(3)=[0.1192];
      axes.Color=[1 1 1]*.95;
    end
    function ax=AnalysisSSAFSPPredictiveFullModelControl_ControlInput(obj,ax)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveFullModelControl');
      area1=area(ax,data.time,data.U,'FaceColor','m');
      area1.EdgeAlpha=0;
    end
    function ax=AnalysisSSAFSPPredictiveFullModelControl_Trajectory(obj,ax)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveFullModelControl');
      hold(ax,'on')
      [X,Y]=meshgrid(data.time,0:49);
      pcolorplot=pcolor(ax,X,Y,data.P);
      pcolorplot.EdgeAlpha=0;
      colormap(ax,flipud(gray))
      set(ax,'handlevisibility','off')
      caxis(ax,[0 0.2])
      plot(ax,data.time,data.X,'LineWidth',2)
      plot(ax,data.time,data.Y,'LineWidth',2)
      plot(ax,data.time,data.predictionY,'LineWidth',2)
      legend(ax,{'Probability','Target','NonTarget','Prediction'},'Orientation','horizontal');
      xlim(ax,[0 3000]);
    end
    function ax=AnalysisSSAFSPPredictiveFullModelControl_JD(obj,ax)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveFullModelControl');
      [xVec]=[1:(size(data.steadystate,1))]-1;
      [yVec]=[1:(size(data.steadystate,2))]-1;
      [X,Y]=meshgrid(xVec,yVec);
      hold(ax,'on')
      pFig=pcolor(ax,X,Y,data.steadystate);
      pFig.EdgeAlpha=0;
      axis(ax,[0,50,0,50]);
      cmap=hot;
      colormap(ax,cmap(20:end,:))
      blueX=scatter(ax,data.target(2),data.target(1),30,'wo');
      blueX.MarkerEdgeColor=[1 1 1];
      blueX.LineWidth=2;
      caxis(ax,[0 .04])
    end
    function ax=AnalysisSSAFSPPredictiveFullModelControl_MD(obj,ax)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveFullModelControl');
      hold(ax,'on')
      plot(ax,[data.target(1) data.target(1)],[0 1],'b--','HandleVisibility','off')
      plot(ax,data.target(1),0,'bp','Markersize',10,'MarkerFaceColor' ,'blue','HandleVisibility','off')
      plot(ax,[data.target(2) data.target(2)],[0 1],'r--','HandleVisibility','off')
      plot(ax,data.target(2),0,'rp','Markersize',10,'MarkerFaceColor','red','HandleVisibility','off')
      xMarginal=sum(data.steadystate,2);
      yMarginal=sum(data.steadystate,1);
      lineP1ot1=plot(ax,0:(length(xMarginal)-1),xMarginal,'b-');
      lineP1ot1.LineWidth=3;
      linePlot2=plot(ax,0:(length(yMarginal)-1),yMarginal,'r-.');
      linePlot2.LineWidth=3;
      ylim([0,.2])
      xlim([0 50])
    end
    function ax=AnalysisSSAFSPPredictiveFullModelControl_PScore(obj,ax)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveFullModelControl');
      text(ax,31,46,sprintf('J= %.0f',data.Pscore),'FontSize',11,'FontWeight','bold','Color',[1 1 1]);
    end
    function ax=AnalysisSSAFSPPredictiveFullModelControl_ScoreDist(obj)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveFullModelControl');
      hold on
      h1=histogram(data.TScore.^.5,0:2:50-1,'Normalization','probability');
      line=plot([data.Pscore.^.5,data.Pscore.^.5],[0,1],'k--','LineWidth',.1);
      h1.EdgeAlpha=0;
      h1.FaceColor=[0.4941 0.1843 0.5569];
      xlabel('Distance')
      ylabel('Probability')
      axes=gca;
      box(axes);
      t=LabelPlot(sprintf('J = %0.0f',data.Pscore));
      t.Position(3)=[0.1192];
      axes.Color=[1 1 1]*.95;
    end
    function ax=AnalysisSSAFSPPredictiveFullModelReducedControl_ControlInput(obj,ax)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveFullModelReducedControl');
      hold(ax,'on')
      area1=area(ax,data.time,data.U,'FaceColor','m');
      area1.EdgeAlpha=0;
    end
    function ax=AnalysisSSAFSPPredictiveFullModelReducedControl_Trajectory(obj,ax)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveFullModelReducedControl');
      hold(ax,'on')
      [X,Y]=meshgrid(data.time,0:49);
      pcolorplot=pcolor(ax,X,Y,data.P);
      pcolorplot.EdgeAlpha=0;
      colormap(ax,flipud(gray))
      set(ax,'handlevisibility','off')
      caxis(ax,[0 0.2])
      plot(ax,data.time,data.X,'LineWidth',2)
      plot(ax,data.time,data.Y,'LineWidth',2)
      plot(ax,data.time,data.predictionY,'LineWidth',2)
    end
    function ax=AnalysisSSAFSPPredictiveFullModelReducedControl_JD(obj,ax)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveFullModelReducedControl');
      hold(ax,'on')
      axes(ax)
      pFig=pcolorProbability(data.steadystate);
      axis(ax,[0,50,0,50]);
      cmap=hot;
      colormap(ax,cmap(20:end,:))
      blueX=scatter(ax,data.target(2),data.target(1),30,'wo');
      blueX.MarkerEdgeColor=[1 1 1];
      blueX.LineWidth=2;
      caxis([0 .02])
      colorbar()
    end
    function axes=AnalysisSSAFSPPredictiveFullModelReducedControl_MD(obj)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveFullModelReducedControl');
      hold on
      plot([data.target(1) data.target(1)],[0 1],'b--','HandleVisibility','off')
      plot(data.target(1),0,'bp','Markersize',10,'MarkerFaceColor' ,'blue','HandleVisibility','off')
      plot([data.target(2) data.target(2)],[0 1],'r--','HandleVisibility','off')
      plot(data.target(2),0,'rp','Markersize',10,'MarkerFaceColor','red','HandleVisibility','off')
      xMarginal=sum(data.steadystate,2);
      yMarginal=sum(data.steadystate,1);
      lineP1ot1=plot(0:(length(xMarginal)-1),xMarginal,'b-');
      lineP1ot1.LineWidth=3;
      linePlot2=plot(0:(length(yMarginal)-1),yMarginal,'r-.');
      linePlot2.LineWidth=3;
      ylim([0,.2])
      xlim([0 50])
      axes=gca;
      axes.YGrid='on';
      text(31,.16,sprintf('J= %.0f',data.Pscore),'FontSize',11,'FontWeight','bold');
      xlabel('Species Count')
      ylabel('Probability')
      axes=gca;
      axes.Color=[1 1 1]*.95;
    end
    function ax=AnalysisSSAFSPPredictiveFullModelReducedControl_PScore(obj,ax)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveFullModelReducedControl');
      text(31,45,sprintf('J= %.0f',data.Pscore),'FontSize',11,'FontWeight','bold','Color',[1 1 1]);
    end
    function axes=AnalysisSSAFSPPredictiveFullModelReducedControl_ScoreDist(obj)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveFullModelReducedControl');
      hold on
      h1=histogram(data.TScore.^.5,0:2:50-1,'Normalization','probability');
      line=plot([data.Pscore.^.5,data.Pscore.^.5],[0,1],'k--','LineWidth',.1);
      h1.EdgeAlpha=0;
      h1.FaceColor=[0.4941 0.1843 0.5569];
      xlabel('Distance')
      ylabel('Probability')
      axes=gca;
      box(axes);
      t=LabelPlot(sprintf('J = %0.0f',data.Pscore));
      t.Position(3)=[0.1192];
      axes.Color=[1 1 1]*.95;
    end
    function axes=AnalysisSSAFSPPredictiveFullModelControlSlowed_ControlInput(obj)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveFullModelControlSlowed');
      axes=area(data.time,data.U,'FaceColor','m');
      axes.EdgeAlpha=0;
      set(gca, 'YGrid', 'off', 'XGrid', 'on')
      xlabel('time(minutes)')
      ylabel('Control Input')
      grid(gca,'on');
      xlim([0 3000]);
      axes=gca;
      axes.Color=[1 1 1]*.95;
    end
    function axes=AnalysisSSAFSPPredictiveFullModelControlSlowed_Trajectory(obj)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveFullModelControlSlowed');
      hold on
      [X,Y]=meshgrid(data.time,0:49);
      pcolorplot=pcolor(X,Y,data.P);
      pcolorplot.EdgeAlpha=0;
      colormap(flipud(gray))
      set(gco,'handlevisibility','off')
      caxis([0 0.2])
      hold on
      plot(data.time,data.X,'LineWidth',2)
      plot(data.time,data.Y,'LineWidth',2)
      plot(data.time,data.predictionY,'LineWidth',2)
      legend({'Probability','Target','NonTarget','Prediction'},'Orientation','horizontal');
      xlim([0 3000]);
      grid(gca,'on')
      box(gca,'on')
      xlabel('time (minutes)')
      ylabel('Species Count')
      axes=gca;
    end
    function axes=AnalysisSSAFSPPredictiveFullModelControlSlowed_JD(obj)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveFullModelControlSlowed');
      [xVec]=[1:(size(data.steadystate,1))]-1;
      [yVec]=[1:(size(data.steadystate,2))]-1;
      [X,Y]=meshgrid(xVec,yVec);
      hold on
      pFig=pcolor(X,Y,data.steadystate);
      pFig.EdgeAlpha=0;
      axis([0,50,0,50]);
      cmap=hot;
      colormap(gca,cmap(20:end,:))
      blueX=scatter(data.target(2),data.target(1),30,'wo');
      blueX.MarkerEdgeColor=[1 1 1];
      blueX.LineWidth=2;
      caxis([0 .04])
      axes=gca;
      xlabel('Species Count')
      ylabel('Species Count')
    end
    function axes=AnalysisSSAFSPPredictiveFullModelControlSlowed_MD(obj)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveFullModelControlSlowed');
      hold on
      plot([data.target(1) data.target(1)],[0 1],'b--','HandleVisibility','off')
      plot(data.target(1),0,'bp','Markersize',10,'MarkerFaceColor' ,'blue','HandleVisibility','off')
      plot([data.target(2) data.target(2)],[0 1],'r--','HandleVisibility','off')
      plot(data.target(2),0,'rp','Markersize',10,'MarkerFaceColor','red','HandleVisibility','off')
      xMarginal=sum(data.steadystate,2);
      yMarginal=sum(data.steadystate,1);
      lineP1ot1=plot(0:(length(xMarginal)-1),xMarginal,'b-');
      lineP1ot1.LineWidth=3;
      linePlot2=plot(0:(length(yMarginal)-1),yMarginal,'r-.');
      linePlot2.LineWidth=3;
      ylim([0,.2])
      xlim([0 50])
      axes=gca;
      axes.YGrid='on';
      text(31,.16,sprintf('J= %.0f',data.Pscore),'FontSize',11,'FontWeight','bold');
      xlabel('Species Count')
      ylabel('Probability')
      axes=gca;
      axes.Color=[1 1 1]*.95;
    end
    function axes=AnalysisSSAFSPPredictiveFullModelControlSlowed_ScoreDist(obj)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveFullModelControlSlowed');
      hold on
      h1=histogram(data.TScore.^.5,0:2:50-1,'Normalization','probability');
      line=plot([data.Pscore.^.5,data.Pscore.^.5],[0,1],'k--','LineWidth',.1);
      h1.EdgeAlpha=0;
      h1.FaceColor=[0.4941 0.1843 0.5569];
      xlabel('Distance')
      ylabel('Probability')
      axes=gca;
      box(axes);
      t=LabelPlot(sprintf('J = %0.0f',data.Pscore));
      t.Position(3)=[0.1192];
      axes.Color=[1 1 1]*.95;
    end
    function ax=AnalysisSSAFSPPredictiveZModel_ControlInput(obj,ax,N)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveZModel');
      areaplot=area(ax,data.trajectories{N}.time,data.trajectories{N}.U,'FaceColor','m');
      areaplot.EdgeAlpha=0;
      grid(ax,'on');
      ax.Color=[1 1 1]*.95;
    end
    function ax=AnalysisSSAFSPPredictiveZModel_Patches(obj,ax,N)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveZModel');
      P=cumsum(data.trajectories{N}.P);
      vec=sum(P<.9)<16;
      vec2=sum(P<.1)>16;
      for i=1:length(data.trajectories{N}.time)
        if vec(i)&vec(i+1)
          xv=[data.trajectories{N}.time(i) data.trajectories{N}.time(i+1)];
          patch(ax,[xv(1) xv(2) xv(2) xv(1)],[0 0 60 60],[1 .5 0],'EdgeAlpha',0,'FaceAlpha',.2,'FaceColor',[1 .5 0]*.8);
        end
      end
    end
    function ax=AnalysisSSAFSPPredictiveZModel_Trajectory(obj,ax,N)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveZModel');
      hold(ax,'on');
      [X,Y]=meshgrid(data.trajectories{N}.time,0:49);
      pcolorplot=pcolor(ax,X,Y,data.trajectories{N}.P);
      pcolorplot.EdgeAlpha=0;
      colormap(ax,flipud(gray*.95))
      set(ax,'handlevisibility','off')
      caxis(ax,[0 0.2])
      hold(ax,'on');
      plot(ax,data.trajectories{N}.time,data.trajectories{N}.X,'LineWidth',2)
      plot(ax,data.trajectories{N}.time,data.trajectories{N}.Y,'LineWidth',2)
      plot(ax,data.trajectories{N}.time,data.trajectories{N}.predictionY,'LineWidth',2)
    end
    function ax=AnalysisSSAFSPPredictiveZModel_JD(obj,ax,N)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveZModel');
      [xVec]=[1:(size(data.trajectories{N}.steadystate,1))]-1;
      [yVec]=[1:(size(data.trajectories{N}.steadystate,2))]-1;
      [X,Y]=meshgrid(xVec,yVec);
      hold(ax,'on');
      steadystate=zeros(size(data.trajectories{N}.steadystate));
      for i=2:length(data.trajectories)
        steadystate=steadystate+data.trajectories{i}.steadystate;
      end
      steadystate=steadystate./sum(sum(steadystate));
      pFig=pcolor(ax,X,Y,steadystate);
      pFig.EdgeAlpha=0;
      axis(ax,[0,50,0,50]);
      cmap=hot;
      colormap(gca,cmap)
      blueX=scatter(ax,data.trajectories{N}.target(2),data.trajectories{1}.target(1),30,'wo');
      blueX.MarkerEdgeColor=[1 1 1];
      blueX.LineWidth=2;
      caxis([0 .04])
    end
    function ax=AnalysisSSAFSPPredictiveZModel_MD(obj,ax,N)
      N=3;
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveZModel');
      hold(ax,'on');
      plot(ax,[data.trajectories{N}.target(1) data.trajectories{N}.target(1)],[0 1],'b--','HandleVisibility','off')
      plot(ax,data.trajectories{N}.target(1),0,'bp','Markersize',10,'MarkerFaceColor' ,'blue','HandleVisibility','off')
      plot(ax,[data.trajectories{N}.target(2) data.trajectories{N}.target(2)],[0 1],'r--','HandleVisibility','off')
      plot(ax,data.trajectories{N}.target(2),0,'rp','Markersize',10,'MarkerFaceColor','red','HandleVisibility','off')
      xMarginal=zeros([1 length(data.trajectories{N}.steadystate)]);
      yMarginal=zeros([1 length(data.trajectories{N}.steadystate)]);
      for i=1:length(data.trajectories)
        xMarginal=xMarginal+sum(data.trajectories{i}.steadystate,2)';
        yMarginal=yMarginal+sum(data.trajectories{i}.steadystate,1);
      end
      xMarginal=xMarginal./sum(xMarginal);
      yMarginal=yMarginal./sum(yMarginal);
      lineP1ot1=plot(0:(length(xMarginal)-1),xMarginal,'-','Color',[0 0 1],'LineWidth',3);
      linePlot2=plot(0:(length(yMarginal)-1),yMarginal,'-.','Color',[1 0 0],'LineWidth',3);
      linePlot3=plot(0:(length(data.Pp)-1),data.Pp,'-','Color',[1 .5 0],'LineWidth',3);
      ylim([0,.2])
      xlim([0 50])
      text(ax,31,.16,sprintf('J= %.0f',mean(data.tscore)),'FontSize',11,'FontWeight','bold');
    end
    function axes=AnalysisSSAFSPPredictiveZModel_ScoreDist(obj,ax)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveFullModelControlSlowed');
      N=3;
      hold(ax,'on')
      h1=histogram(ax,data.trajectories{N}.TScore.^.5,0:2:50-1,'Normalization','probability');
      line=plot(ax,[data.trajectories{N}.Pscore.^.5,data.trajectories{1}.Pscore.^.5],[0,1],'k--','LineWidth',.1);
      h1.EdgeAlpha=0;
      h1.FaceColor=[0.4941 0.1843 0.5569];
      xlabel('Distance')
      ylabel('Probability')
      axes=gca;
      box(axes);
      t=LabelPlot(sprintf('J = %0.0f',data.trajectories{N}.Pscore));
      t.Position(3)=[0.1192];
      axes.Color=[1 1 1]*.95;
    end
    function ax=AnalysisSSAFSPPredictiveZModel_TransientDistributions(obj,ax)
      N=3;
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveZModel');
      controller=obj.datalayer.get('ControlInputs_ReducedModels');
      controller=controller.ReducedControlAutoregulatedModelControler;
      controller=controller(:,1);
      Jp=0;
      Jb=0;
      Js=0;
      Pp=zeros([50 1]);
      Pb=zeros([50 1]);
      Ps=zeros([50 1]);
      indp=0;
      indb=0;
      inds=0;
      for j=1:length(data.trajectories)
        P=cumsum(data.trajectories{j}.P);
        vec=sum(P<.9)<16;
        vec2=sum(P<.1)>16;
        for i=15000:65000
          if vec(i)&vec(i+1)
            Jp=Jp+data.trajectories{j}.TScore(i);
            Pp=Pp+data.trajectories{j}.P(:,i);
            indp=indp+1;
          elseif vec2(i)&vec2(i+1)
            Jb=Jb+data.trajectories{j}.TScore(i);
            Pb=Pb+data.trajectories{j}.P(:,i);
            indb=indb+1;
          end
          Js=Js+data.trajectories{j}.TScore(i);
          Ps=Ps+data.trajectories{j}.P(:,i);
          inds=inds+1;
        end
      end
      Pp=Pp./sum(Pp);
      Pb=Pb./sum(Pb);
      Ps=Ps./sum(Ps);
      Jp=sum(Jp)/indp;
      Jb=sum(Jb)/indb;
      Js=sum(Js)/inds;
      hold(ax,'on')
      M=10;
      ind=(1:M)*6500;
      scale=1e-10;
      Z=[linspace(1,0,11),linspace(0,-1,50-11)]*scale;
      positiveVisibilityFlag='on';
      negativeVisibilityFlag='on';
      plot(ax,0:49,Ps,'LineWidth',3,'Color',[1 0 1]*.8)
      for i=1:M
        if data.trajectories{N}.Z(ind(i))>0
          color=[1 0 0];
          plot(ax,0:49,data.trajectories{N}.P(:,ind(i)),'k-','Color',color*.65,...
          'HandleVisibility','off','LineWidth',1,'HandleVisibility',positiveVisibilityFlag);
        positiveVisibilityFlag='off';
        else
          color=[0 0 1];
          plot(ax,0:49,data.trajectories{N}.P(:,ind(i)),'k-','Color',color*.65,...
          'HandleVisibility','off','LineWidth',1,'HandleVisibility',negativeVisibilityFlag);
        negativeVisibilityFlag='off';
        end
      end
      
      axis(ax,[0 50 0 .2])
    end
    function ax=AnalysisSSATwoCellFullModel_ControlInput(obj,ax)
      data=obj.datalayer.get('AnalysisSSATwoCellFullModel');
      hold(ax,'on')
      area1=area(ax,data.time,data.U,'FaceColor','m');
      area1.EdgeAlpha=0;
    end
    function ax=AnalysisSSATwoCellFullModel_Trajectory(obj,ax)
      data=obj.datalayer.get('AnalysisSSATwoCellFullModel');
      hold(ax,'on')
      colormap(flipud(gray).*[1 0 0])
      set(gco,'handlevisibility','off')
      plot(ax,data.time,data.X,'LineWidth',2)
      plot(ax,data.time,data.Y,'LineWidth',2)
    end
    function ax=AnalysisSSATwoCellFullModel_JD(obj,ax)
      data=obj.datalayer.get('AnalysisSSATwoCellFullModel');
      hold(ax,'on')
      axes(ax)
      pFig=pcolorProbability(data.P);
      pFig.EdgeAlpha=0;
      axis(ax,[0,50,0,50]);
      cmap=hot;
      colormap(gca,cmap(20:end,:))
      blueX=scatter(data.target(2),data.target(1),30,'wo');
      blueX.MarkerEdgeColor=[1 1 1];
      blueX.LineWidth=2;
      caxis(ax,[0 .02])
      colorbar()
    end
    function ax=AnalysisSSATwoCellFullModel_MD(obj)
      data=obj.datalayer.get('AnalysisSSATwoCellFullModel');
      hold on
      plot([data.target(1) data.target(1)],[0 1],'b--','HandleVisibility','off')
      plot(data.target(1),0,'bp','Markersize',10,'MarkerFaceColor' ,'blue','HandleVisibility','off')
      plot([data.target(2) data.target(2)],[0 1],'r--','HandleVisibility','off')
      plot(data.target(2),0,'rp','Markersize',10,'MarkerFaceColor','red','HandleVisibility','off')
      lineP1ot1=plot(0:(length(data.targetMarginal)-1),data.targetMarginal,'b-');
      lineP1ot1.LineWidth=3;
      linePlot2=plot(0:(length(data.nonTargetMarginal)-1),data.nonTargetMarginal,'r-.');
      linePlot2.LineWidth=3;
      ylim([0,.2])
      xlim([0 50])
      axes=gca;
      axes.YGrid='on';
      xlabel('Species Count')
      ylabel('Probability')
      axes=gca;
      axes.Color=[1 1 1]*.95;
    end
    function ax=AnalysisSSATwoCellFullModel_PScore(obj,ax)
      data=obj.datalayer.get('AnalysisSSATwoCellFullModel');
      axes(ax)
      text(31,45,sprintf('J= %.0f',data.score),'FontSize',11,'FontWeight','bold','Position',[34.3939 44.8182 0],'Color',[1 1 1]);
    end
    function ax=AnalysisSSATwoCellFullModel_ScoreDist(obj,ax)
      data=obj.datalayer.get('AnalysisSSATwoCellFullModel');
      hold on
      h1=histogram(ax,data.TScore,0:50:1500,'Normalization','probability');
      line=plot(ax,[data.score,data.score],[0,1],'k--','LineWidth',1);
      h1.EdgeAlpha=0;
      h1.FaceColor=[0.4941 0.1843 0.5569];
    end
    function ax=AnalysisSSATwoCellFullModelReducedControl_ControlInput(obj,ax)
      data=obj.datalayer.get('AnalysisSSATwoCellFullModelReducedControl');
      hold(ax,'on')
      area1=area(ax,data.time,data.U,'FaceColor','m');
      area1.EdgeAlpha=0;
    end
    function ax=AnalysisSSATwoCellFullModelReducedControl_Trajectory(obj,ax)
      data=obj.datalayer.get('AnalysisSSATwoCellFullModelReducedControl');
      hold(ax,'on')
      colormap(flipud(gray).*[1 0 0])
      set(gco,'handlevisibility','off')
      caxis(ax,[0 0.02])
      colorbar()
      plot(ax,data.time,data.X,'LineWidth',2)
      plot(ax,data.time,data.Y,'LineWidth',2)
    end
    function ax=AnalysisSSATwoCellFullModelReducedControl_JD(obj,ax)
      data=obj.datalayer.get('AnalysisSSATwoCellFullModelReducedControl');
      hold(ax,'on')
      axes(ax)
      pFig=pcolorProbability(data.P);
      pFig.EdgeAlpha=0;
      axis(ax,[0,50,0,50]);
      cmap=hot;
      colormap(gca,cmap(20:end,:))
      blueX=scatter(data.target(2),data.target(1),30,'wo');
      blueX.MarkerEdgeColor=[1 1 1];
      blueX.LineWidth=2;
      caxis(ax,[0 .02])
      colorbar()
    end
    function ax=AnalysisSSATwoCellFullModelReducedControl_MD(obj)
      data=obj.datalayer.get('AnalysisSSATwoCellFullModelReducedControl');
      hold on
      plot([data.target(1) data.target(1)],[0 1],'b--','HandleVisibility','off')
      plot(data.target(1),0,'bp','Markersize',10,'MarkerFaceColor' ,'blue','HandleVisibility','off')
      plot([data.target(2) data.target(2)],[0 1],'r--','HandleVisibility','off')
      plot(data.target(2),0,'rp','Markersize',10,'MarkerFaceColor','red','HandleVisibility','off')
      lineP1ot1=plot(0:(length(data.targetMarginal)-1),data.targetMarginal,'b-');
      lineP1ot1.LineWidth=3;
      linePlot2=plot(0:(length(data.nonTargetMarginal)-1),data.nonTargetMarginal,'r-.');
      linePlot2.LineWidth=3;
      ylim([0,.2])
      xlim([0 50])
      axes=gca;
      axes.YGrid='on';
      xlabel('Species Count')
      ylabel('Probability')
      axes=gca;
      axes.Color=[1 1 1]*.95;
    end
    function ax=AnalysisSSATwoCellFullModelReducedControl_PScore(obj,ax,position)
      data=obj.datalayer.get('AnalysisSSATwoCellFullModelReducedControl');
      axes(ax)
      t=text(ax,position(1),position(2),sprintf('J= %.0f',data.score),'FontSize',11,'FontWeight','bold');
    end
    function ax=AnalysisSSATwoCellFullModelReducedControl_ScoreDist(obj,ax)
      data=obj.datalayer.get('AnalysisSSATwoCellFullModelReducedControl');
      hold(ax,'on')
      h1=histogram(ax,data.TScore,0:50:1500,'Normalization','probability');
      line=plot(ax,[data.Pscore,data.Pscore],[0,1],'k--','LineWidth',.1);
      h1.EdgeAlpha=0;
      h1.FaceColor=[0.4941 0.1843 0.5569];
      xlabel(ax,'Distance')
      ylabel(ax,'Probability')
    end
    function ax=AnalysisSSATwoCellReducedModel_ControlInput(obj,ax)
      data=obj.datalayer.get('AnalysisSSATwoCellReducedModel');
      hold(ax,'on')
      area1=area(ax,data.time,data.U,'FaceColor','m');
      area1.EdgeAlpha=0;
    end
    function ax=AnalysisSSATwoCellReducedModel_Trajectory(obj,ax)
      data=obj.datalayer.get('AnalysisSSATwoCellReducedModel');
      hold(ax,'on')
      colormap(flipud(gray).*[1 0 0])
      set(gco,'handlevisibility','off')
      plot(ax,data.time,data.X,'LineWidth',2)
      plot(ax,data.time,data.Y,'LineWidth',2)
    end
    function ax=AnalysisSSATwoCellReducedModel_JD(obj,ax)
      data=obj.datalayer.get('AnalysisSSATwoCellReducedModel');
      hold(ax,'on')
      axes(ax)
      pFig=pcolorProbability(data.P);
      pFig.EdgeAlpha=0;
      axis(ax,[0,50,0,50]);
      cmap=hot;
      colormap(gca,cmap(20:end,:))
      blueX=scatter(data.target(2),data.target(1),30,'wo');
      blueX.MarkerEdgeColor=[1 1 1];
      blueX.LineWidth=2;
      caxis(ax,[0 .02])
      colorbar()
    end
    function ax=AnalysisSSATwoCellReducedModel_MD(obj)
      data=obj.datalayer.get('AnalysisSSATwoCellReducedModel');
      hold on
      plot([data.target(1) data.target(1)],[0 1],'b--','HandleVisibility','off')
      plot(data.target(1),0,'bp','Markersize',10,'MarkerFaceColor' ,'blue','HandleVisibility','off')
      plot([data.target(2) data.target(2)],[0 1],'r--','HandleVisibility','off')
      plot(data.target(2),0,'rp','Markersize',10,'MarkerFaceColor','red','HandleVisibility','off')
      lineP1ot1=plot(0:(length(data.targetMarginal)-1),data.targetMarginal,'b-');
      lineP1ot1.LineWidth=3;
      linePlot2=plot(0:(length(data.nonTargetMarginal)-1),data.nonTargetMarginal,'r-.');
      linePlot2.LineWidth=3;
      ylim([0,.2])
      xlim([0 50])
      axes=gca;
      axes.YGrid='on';
      xlabel('Species Count')
      ylabel('Probability')
      axes=gca;
      axes.Color=[1 1 1]*.95;
    end
    function ax=AnalysisSSATwoCellReducedModel_PScore(obj,ax,position)
      data=obj.datalayer.get('AnalysisSSATwoCellReducedModel');
      axes(ax)
      text(position(1),position(2),sprintf('J= %.0f',data.score),'FontSize',11,'FontWeight','bold');
    end
    function ax=AnalysisSSATwoCellReducedModel_ScoreDist(obj,ax)
      data=obj.datalayer.get('AnalysisSSATwoCellReducedModel');
      hold on
      h1=histogram(ax,data.TScore,0:50:1500,'Normalization','probability');
      line=plot(ax,[data.score,data.score],[0,1],'k--','LineWidth',.1);
      h1.EdgeAlpha=0;
      h1.FaceColor=[0.4941 0.1843 0.5569];
    end
    function ax=AnalysisSSATwoCellReducedModelReducedControl_ControlInput(obj,ax)
      data=obj.datalayer.get('AnalysisSSATwoCellReducedModelReducedControl');
      hold(ax,'on')
      area1=area(ax,data.time,data.U,'FaceColor','m');
      area1.EdgeAlpha=0;
    end
    function ax=AnalysisSSATwoCellReducedModelReducedControl_Trajectory(obj,ax)
      data=obj.datalayer.get('AnalysisSSATwoCellReducedModelReducedControl');
      hold(ax,'on')
      colormap(flipud(gray).*[1 0 0])
      set(gco,'handlevisibility','off')
      plot(ax,data.time,data.X,'LineWidth',2)
      plot(ax,data.time,data.Y,'LineWidth',2)
    end
    function ax=AnalysisSSATwoCellReducedModelReducedControl_JD(obj,ax)
      data=obj.datalayer.get('AnalysisSSATwoCellReducedModelReducedControl');
      hold(ax,'on')
      axes(ax)
      pFig=pcolorProbability(data.P);
      pFig.EdgeAlpha=0;
      axis(ax,[0,50,0,50]);
      cmap=hot;
      colormap(gca,cmap(20:end,:))
      blueX=scatter(data.target(2),data.target(1),30,'wo');
      blueX.MarkerEdgeColor=[1 1 1];
      blueX.LineWidth=2;
      caxis(ax,[0 .02])
      colorbar()
    end
    function ax=AnalysisSSATwoCellReducedModelReducedControl_MD(obj)
      data=obj.datalayer.get('AnalysisSSATwoCellReducedModelReducedControl');
      hold on
      plot([data.target(1) data.target(1)],[0 1],'b--','HandleVisibility','off')
      plot(data.target(1),0,'bp','Markersize',10,'MarkerFaceColor' ,'blue','HandleVisibility','off')
      plot([data.target(2) data.target(2)],[0 1],'r--','HandleVisibility','off')
      plot(data.target(2),0,'rp','Markersize',10,'MarkerFaceColor','red','HandleVisibility','off')
      lineP1ot1=plot(0:(length(data.targetMarginal)-1),data.targetMarginal,'b-');
      lineP1ot1.LineWidth=3;
      linePlot2=plot(0:(length(data.nonTargetMarginal)-1),data.nonTargetMarginal,'r-.');
      linePlot2.LineWidth=3;
      ylim([0,.2])
      xlim([0 50])
      axes=gca;
      axes.YGrid='on';
      xlabel('Species Count')
      ylabel('Probability')
      axes=gca;
      axes.Color=[1 1 1]*.95;
    end
    function ax=AnalysisSSATwoCellReducedModelReducedControl_PScore(obj,ax,position)
      data=obj.datalayer.get('AnalysisSSATwoCellReducedModelReducedControl');
      axes(ax)
      text(position(1),position(2),sprintf('J= %.0f',data.score),'FontSize',11,'FontWeight','bold','Position',[34.3939 44.8182 0],'Color',[0 0 0]);
    end
    function ax=AnalysisSSATwoCellReducedModelReducedControl_ScoreDist(obj,ax)
      data=obj.datalayer.get('AnalysisSSATwoCellReducedModelReducedControl');
      hold(ax,'on')
      h1=histogram(ax,data.TScore,0:50:1500,'Normalization','probability');
      line=plot(ax,[data.score,data.score],[0,1],'k--','LineWidth',.1);
      h1.EdgeAlpha=0;
      h1.FaceColor=[0.4941 0.1843 0.5569];
    end
    function ax=CalibrationCurveUnregulatedFullReduced_Hysteresis(obj,ax)
      data1=obj.datalayer.get('CalibrationCurveHysteresisCalibratedModel');
      data2=obj.datalayer.get('AnalysisODEHysteresis_ReducedModelAutoregulated');
      hold(ax,'on')
      line1=plot(ax,data1.range,data1.upTrajectory,'LineWidth',3)
      line1.Color=[1 0 0];
      line2=plot(ax,data1.range,data1.downTrajectory,'LineWidth',3)
      line2.Color=[0 0 1];
      line3=plot(ax,data2.range,data2.upTrajectory,'--','LineWidth',3)
      line3.Color=[1 .7 0];
      line4=plot(ax,data2.range,data2.downTrajectory,'--','LineWidth',3)
      line4.Color=[0 .7 1];
    end
    function ax=CalibrationCurveUnregulatedFullReduced_Calibration(obj,ax)
      data=obj.datalayer.get('CalibrationCurveUnregulatedFullReduced');
      hold(ax,'on');
      line1=plot(ax,data.calibration(2,:),data.calibration(1,:),'k-','LineWidth',3)
    end
    function axes=AnalysisODEFrequencySeparation_FullModels_TrajectoryLow(obj,ax)
      data=obj.datalayer.get('AnalysisODEFrequencySeparation_FullModels');
      hold(ax,'on')
      period=linspace(0,2,81);
      line1=plot(ax,period,data{1,2}.state(1,(end-80):end),'-','LineWidth',3);
      line1.Color=[0 1 1]*.8;
      line2=plot(ax,period,data{1,3}.state(5,(end-80):end),'-.','LineWidth',3);
      line2.Color=[0 1 1]*.4;
    end
    function axes=AnalysisODEFrequencySeparation_FullModels_TrajectoryMed(obj,ax)
      data=obj.datalayer.get('AnalysisODEFrequencySeparation_FullModels');
      hold(ax,'on')
      period=linspace(0,2,81);
      line1=plot(ax,period,data{2,2}.state(1,(end-80):end),'-','LineWidth',3);
      line1.Color=[0 1 1]*.8;
      line2=plot(ax,period,data{2,3}.state(5,(end-80):end),'-.','LineWidth',3);
      line2.Color=[0 1 1]*.4;
    end
    function axes=AnalysisODEFrequencySeparation_FullModels_TrajectoryHigh(obj,ax)
      data=obj.datalayer.get('AnalysisODEFrequencySeparation_FullModels');
      hold(ax,'on')
      period=linspace(0,2,81);
      line1=plot(ax,period,data{3,2}.state(1,(end-80):end),'-','LineWidth',3);
      line1.Color=[0 1 1]*.8;
      line2=plot(ax,period,data{3,3}.state(5,(end-80):end),'-.','LineWidth',3);
      line2.Color=[0 1 1]*.4;
    end
    function ax=AnalysisSSACorrelationsSSATwoCellFullModel_U(obj,ax)
      data=obj.datalayer.get('AnalysisSSACorrelationsSSATwoCellFullModel');
      hold(ax,'on')
      lineWidth=3;
      plot(ax,data.tau,data.corrUU,'LineWidth',lineWidth,'Color',[0 0 1])
      plot(ax,data.tau,data.corrTT,'LineWidth',lineWidth,'Color',[1 0 1])
      plot(ax,data.tau,data.corrNN,'LineWidth',lineWidth,'Color',[0 .5 1])
    end
    function AnalysisSSACorrelationsSSATwoCellReducedModel_U(obj,ax)
      data=obj.datalayer.get('AnalysisSSACorrelationsSSATwoCellReducedModel');
      hold(ax,'on')
      lineWidth=3;
      plot(ax,data.tau,data.corrUU,'LineWidth',lineWidth,'Color',[0 0 1])
      plot(ax,data.tau,data.corrTT,'LineWidth',lineWidth,'Color',[1 0 1])
      plot(ax,data.tau,data.corrNN,'LineWidth',lineWidth,'Color',[0 .5 1])
    end
    function ax=AnalysisSSACorrelationsSSATwoCellReducedModelReducedControl_U(obj,ax);
      data=obj.datalayer.get('AnalysisSSACorrelationsSSATwoCellReducedModelReducedControl');
      hold(ax,'on')
      hold(ax,'on')
      lineWidth=3;
      plot(ax,data.tau,data.corrUU,'LineWidth',lineWidth,'Color',[0 0 1])
      plot(ax,data.tau,data.corrTT,'LineWidth',lineWidth,'Color',[1 0 1])
      plot(ax,data.tau,data.corrNN,'LineWidth',lineWidth,'Color',[0 .5 1])
    end
    function ax=AnalysisSSACorrelationsSSAFSPPredictiveZModel_U(obj,ax)
      data=obj.datalayer.get('AnalysisSSACorrelationsSSAFSPPredictiveZModel');
      hold(ax,'on')
      hold(ax,'on')
      lineWidth=3;
      plot(ax,data.tau,data.corrUU,'LineWidth',lineWidth,'Color',[0 0 1])
      plot(ax,data.tau,data.corrTT,'LineWidth',lineWidth,'Color',[1 0 1])
      plot(ax,data.tau,data.corrNN,'LineWidth',lineWidth,'Color',[0 .5 1])
    end
    function ax=AnalysisSSACorrelationsSSATwoCellFullModel_T(obj,ax)
      data=obj.datalayer.get('AnalysisSSACorrelationsSSATwoCellFullModel');
      hold(ax,'on')
      plot(ax,data.tau,data.corrUT,'LineWidth',3,'Color',[1 0 0])
      plot(ax,data.tau,data.corrUN,'LineWidth',3,'Color',[1 .5 0])
      plot(ax,data.tau,data.corrTN,'LineWidth',3,'Color',[0 1 0])
    end
    function ax=AnalysisSSACorrelationsSSATwoCellReducedModel_T(obj,ax)
      data=obj.datalayer.get('AnalysisSSACorrelationsSSATwoCellReducedModel');
      hold(ax,'on')
      plot(ax,data.tau,data.corrUT,'LineWidth',3,'Color',[1 0 0])
      plot(ax,data.tau,data.corrUN,'LineWidth',3,'Color',[1 .5 0])
      plot(ax,data.tau,data.corrTN,'LineWidth',3,'Color',[0 1 0])
    end
    function ax=AnalysisSSACorrelationsSSATwoCellReducedModelReducedControl_T(obj,ax)
      data=obj.datalayer.get('AnalysisSSACorrelationsSSATwoCellReducedModelReducedControl');
      hold(ax,'on')
      plot(ax,data.tau,data.corrUT,'LineWidth',3,'Color',[1 0 0])
      plot(ax,data.tau,data.corrUN,'LineWidth',3,'Color',[1 .5 0])
      plot(ax,data.tau,data.corrTN,'LineWidth',3,'Color',[0 1 0])
    end
    function ax=AnalysisSSACorrelationsSSAFSPPredictiveZModel_T(obj,ax)
      data=obj.datalayer.get('AnalysisSSACorrelationsSSAFSPPredictiveZModel');
      hold(ax,'on')
      plot(ax,data.tau,data.corrUT,'LineWidth',3,'Color',[1 0 0])
      plot(ax,data.tau,data.corrUN,'LineWidth',3,'Color',[1 .5 0])
      plot(ax,data.tau,data.corrTN,'LineWidth',3,'Color',[0 1 0])
    end
    function axes=makePlotForce(~,data)
      hold on
      pcolorProbability(data.controlInput);
      plotQuiver=quiver(data.sampleX,data.sampleY,data.forcesX,data.forcesY,4/data.stepSize^2,'LineWidth',1);
      plotQuiver.Color=[1,1,1];
      xlim([0 50]);
      ylim([0 50]);
      set(gca,'xticklabel',[])
      set(gca,'yticklabel',[])
      caxis([0 5]);
      axes=gca;
    end
    function axes=makePlotJointDistrbution(obj,data)
      hold on
      [xVec]=[1:(size(data.steadystate,1))]-1;
      [yVec]=[1:(size(data.steadystate,2))]-1;
      [X,Y]=meshgrid(xVec,yVec);
      pFig=pcolor(X,Y,data.steadystate);
      pFig.EdgeAlpha=0;
      axis([0,50,0,50])
      cmap=hot;
      colormap(gca,cmap(20:end,:))
      blueX=scatter(data.target(2),data.target(1),30,'wo');
      blueX.MarkerEdgeColor=[1 1 1];
      blueX.LineWidth=2;
      set(gca,'xticklabel',[])
      set(gca,'yticklabel',[])
      caxis([0 .04])
      axes=gca;
    end
    function axes=makePlotMarginalDistribution(obj,data)
      hold on
      plot([data.target(1) data.target(1)],[0 1],'b--','HandleVisibility','off')
      plot(data.target(1),0,'bp','Markersize',10,'MarkerFaceColor' ,'blue','HandleVisibility','off')
      plot([data.target(2) data.target(2)],[0 1],'r--','HandleVisibility','off')
      plot(data.target(2),0,'rp','Markersize',10,'MarkerFaceColor','red','HandleVisibility','off')
      xMarginal=sum(data.steadystate,2);
      yMarginal=sum(data.steadystate,1);
      lineP1ot1=plot(0:(length(xMarginal)-1),xMarginal,'b-');
      lineP1ot1.LineWidth=3;
      linePlot2=plot(0:(length(yMarginal)-1),yMarginal,'r-.');
      linePlot2.LineWidth=3;
      ylim([0,.2])
      xlim([0 50])
      set(gca,'xticklabel',[])
      set(gca,'yticklabel',[])
      hold off
      axes=gca;
      axes.YGrid='on';
      box(axes,'on')
      text(31,.16,sprintf('J= %.0f',data.score),'FontSize',11,'FontWeight','bold');
      axes.Color=[1 1 1]*.95;
    end
    function histogramFig=makePlotHistogram(obj,data,bins,color,alpha)
      histogramFig=histogram(data,bins,'Normalization','probability');
      histogramFig.EdgeAlpha=0;
      histogramFig.FaceAlpha=alpha;
      histogramFig.FaceColor=color;
      histogramFig.LineWidth=2;
    end
  end
end