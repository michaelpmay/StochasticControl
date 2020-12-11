classdef AxesLayer
  properties
    dataFileName='data/file/data'
    datalayer=DataLayer
  end
  methods
    function axes=TestFile(obj)
      data=obj.datalayer.TestFile;
    end
    function axes=AnalysisODEFrequencyOmegaCrit_ReducedModel(obj)
      data=obj.datalayer.get('AnalysisODEFrequencyOmegaCrit_ReducedModel');
      hold on
      line1=plot(linspace(0,2,51),data.wHigh_LIC.state((end-50):end),'g-','LineWidth',3)
      line1.Color=[0 1 0];
      line2=plot(linspace(0,2,51),data.wHigh_HIC.state((end-50):end),'g--','LineWidth',3)
      line2.Color=[0 .5 1];
      line3=plot(linspace(0,2,51),data.wLow_LIC.state((end-50):end),'r-.','LineWidth',3)
      line3.Color=[1 0 0];
      line4=plot(linspace(0,2,51),data.wLow_HIC.state((end-50):end),'r--','LineWidth',3)
      line4.Color=[1 .5 0];
      axes=gca;
      axes.Color=[1 1 1]*.95;
      axes.XGrid = 'on';
    end
    function axes=AnalysisODESSAFrequency_ReducedModel_Trajectory(obj)
      data=obj.datalayer.get('AnalysisODESSAFrequency_ReducedModel');
      traj=data.SSA.node{1}.state((end-1500):end)>20;
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
      line1=plot(time,data.ODE_HIC.state((end-1500):end),'LineWidth',3);
      line2=plot(time,data.ODE_LIC.state((end-1500):end),'LineWidth',3);
      line3=plot(time,data.SSA.node{1}.state((end-1500):end),'LineWidth',3)
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
    function axes=AnalysisSSAFullModels(obj)
      
    end
    function axes=OptimizeControlerFullModels(obj)
      
    end
    function axes=OptimizeControlerReducedModels(obj)
      
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
      data=obj.datalayer.get('ModelFitODE_UnregulatedFullModel');
      axes=plot(data.time,data.state(5,:),'r-.','Linewidth',3)
    end
    function axes=ModelFitODE_UnregulatedReducedModel_Trajectory(obj)
      data=obj.datalayer.get('ModelFitODE_UnregulatedReducedModel')
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
      line1=plot(data.calibration(1,:),data.calibration(2,:),'LineWidth',3);
      line2=plot(data.TruePoints(1,:),data.TruePoints(2,:),'k.','MarkerSize',24);
      axes=gca;
      axes.Color=[1 1 1]*.95;
      axes.XGrid = 'on';
    end
    function axes=ModelFitSSA_UnregulatedReducedModel_Low_Histogram(obj)
      data=obj.datalayer.get('ModelFitSSA_UnregulatedReducedModel_Low')
      histogram1=histogram(data.state,[0:60],'normalization','Probability', 'EdgeAlpha', 0);
      axes=gca;
      axes.Color=[1 1 1]*.95;
    end
    function axes=ModelFitSSA_UnregulatedReducedModel_Med_Histogram(obj)
      data=obj.datalayer.get('ModelFitSSA_UnregulatedReducedModel_Med')
      axes=histogram(data.state,[0:60],'normalization','Probability', 'EdgeAlpha', 0);
    end
    function axes=ModelFitSSA_UnregulatedReducedModel_Hig_Histogram(obj)
      data=obj.datalayer.get('ModelFitSSA_UnregulatedReducedModel_Hig')
      axes=histogram(data.state,[0:60],'normalization','Probability', 'EdgeAlpha', 0);
    end
    function axes=AnalysisODEHysteresis_Regions(obj)
      X=[90 145];
      xBox = [0, 0, X(1), X(1), 0];
      yBox = [0, 120, 120, 0, 0];
      p1=patch(xBox, yBox, 'black', 'FaceColor', 'black', 'FaceAlpha', 0.05, 'EdgeAlpha', 0);
      set(p1, 'HandleVisibility', 'off');
      xBox = [X(1), X(1), X(2), X(2), 0];
      yBox = [0, 120, 120, 0, 0];
      p2=patch(xBox, yBox, 'black', 'FaceColor', 'black', 'FaceAlpha', 0.2, 'EdgeAlpha', 0);
      set(p2, 'HandleVisibility', 'off');
      
      xBox = [X(2), X(2), 1000, 1000, 0];
      yBox = [0, 120, 120, 0, 0];
      p3=patch(xBox, yBox, 'black', 'FaceColor', 'black', 'FaceAlpha', 0.05, 'EdgeAlpha', 0);
      set(p3, 'HandleVisibility', 'off');
    end
    function axes=AnalysisODEHysteresis_ReducedModelAutoregulated(obj)
      data=obj.datalayer.get('AnalysisODEHysteresis_ReducedModelAutoregulated');
      hold on
      line2=plot(data.range,data.upTrajectory,'b-','LineWidth',3);
      line2.Color=[0 0 1];
      %line2.MarkerSize=10;
      line1=plot(data.range,data.downTrajectory,'b--','LineWidth',3);
      line1.Color=[0 .5 1];
      %line1.MarkerSize=3;
    end
    function axes=AnalysisODEHysteresis_ReducedModelUnregulated(obj)
      data=obj.datalayer.get('AnalysisODEHysteresis_ReducedModelUnregulated');
      hold on
      line1=plot(data.range,data.upTrajectory,'k-','LineWidth',3);
      %line1.MarkerSize=10;
      line1.Color=[1 0 0];
      line2=plot(data.range,data.downTrajectory,'k--','LineWidth',3);
      %line2.MarkerSize=3;
      line2.Color=[1 .5 0];
    end
    function axes=AnalysisODEFrequency_ReducedModels_Input(obj)
      data=obj.datalayer.get('AnalysisODEFrequencySeparation_ReducedModels');
      hold on
      line2=plot(data.time,data.upperbound,'k--','Linewidth',1);
      line3=plot(data.time,data.lowerbound,'k--','Linewidth',1);
      line1=plot(data.time,data.input,'m-','LineWidth',3);
      xBox = [0, 0, 2, 2, 0];
      yBox = [data.lowerbound(1), data.upperbound(1), data.upperbound(1), data.lowerbound(1), data.lowerbound(1)];
      p1=patch(xBox, yBox, 'black', 'FaceColor', 'black', 'FaceAlpha', 0.1, 'EdgeAlpha', 0);
      set(p1, 'HandleVisibility', 'off');
      axes=gca;
      axes.Color=[1 1 1]*.95;
      axes.XGrid = 'on';
    end
    function axes=AnalysisODEFrequencySeparation_ReducedModel(obj)
      data=obj.datalayer.get('AnalysisODEFrequencySeparation_ReducedModels');
      range1=linspace(0,2,201);
      range2=linspace(0,2,2001);
      hold on
      line3=plot(range2,data.trajectory_LIC_w0p0001.state((end-2000):end),'g-','LineWidth',3);
      line4=plot(range2,data.trajectory_HIC_w0p0001.state((end-2000):end),'g--','LineWidth',3);
      line4.Color=[0 .5 1];
      line1=plot(range1,data.trajectory_LIC_w0p01.state((end-200):end),'r-.','LineWidth',3);
      line2=plot(range1,data.trajectory_HIC_w0p01.state((end-200):end),'r--','LineWidth',3);
      line2.Color=[1 .5 0];
      
      axes=gca;
      axes.Color=[1 1 1]*.95;
      axes.XGrid = 'on';
    end
    function axes=AnalysisODEHysteresis_FullModelAutoregulated(obj)
      
    end
    function axes=AnalysisODEHysteresis_FullModelUnregulated(obj)
      
    end
    function axes=AnalysisSSATwoCellSwap_ReducedModel(obj)
      
    end
    function axes=AnalysisSSAFourCellSwap_FullModel(obj)
      
    end
    function axes=ControlInputs_FullModels(obj)
      
    end
    function axes=ControlInputs_ReducedlModels(obj)
      
    end
    function axes=AnalysisFitFullModel(obj)
      
    end
    function axes=AnalysisFitReducedModel(obj)
      
    end
    function axes=CalibrationCurve_FullReduced(obj)
    end
    function axes=AnalysisSSAFSPPredictiveModelControl_Histogram(obj)
      data=obj.datalayer.AnalysisSSAFSPPredictiveModelControl()
      hold on
      histogram(data.Y,'normalization','Probability')
      histogram(data.X,'normalization','Probability')
      xlabel('Species Count')
      ylabel('Probability')
      hold off
      axes=gca;
    end
    function axes=AnalysisSSATwoCellSwapReducedModel_ControlInput(obj)
      data=obj.datalayer.get('AnalysisSSATwoCellSwapReducedModel');
      axis1=area(data.trajectory.node{1}.time(1:length(data.U)),data.U,'FaceColor','m');
      axis1.EdgeAlpha=0;
      tightLayout
      set(gca, 'YGrid', 'off', 'XGrid', 'on')
      xlabel('time(minutes)')
      ylabel('Control Input')
      LabelPlot('A')
      axes=gca;
      axes.Color=[1 1 1]*.95;
      axes.XGrid = 'on';
    end
    function axes=AnalysisSSATwoCellSwapReducedModel_Trajectory(obj)
      data=obj.datalayer.get('AnalysisSSATwoCellSwapReducedModel');
      v = [0 0; 1000,0; 1000,60; 0,60];
      f = [1 2 3 4];
      patch('Faces',f,'Vertices',v,'FaceColor','blue','FaceAlpha',.1)
      v = [1000 0; 2000,0; 2000,60; 1000,60];
      f = [1 2 3 4];
      patch('Faces',f,'Vertices',v,'FaceColor','red','FaceAlpha',.1)
      v = [2000 0; 3000,0; 3000,60; 2000,60];
      f = [1 2 3 4];
      hold on
      patch('Faces',f,'Vertices',v,'FaceColor','blue','FaceAlpha',.1)
      plot(data.trajectory.node{1}.time,30*ones(size(data.trajectory.node{1}.time)),'k-','LineWidth',1);
      plot(data.trajectory.node{1}.time,10*ones(size(data.trajectory.node{1}.time)),'k-','LineWidth',1);
      s1=stairs(data.trajectory.node{1}.time,data.trajectory.node{1}.state(1,:)','LineWidth',2);
      s1.Color=[0 0 1]*.8;
      s2=stairs(data.trajectory.node{1}.time,data.trajectory.node{1}.state(2,:)','LineWidth',2);
      s2.Color=[1 0 0]*.8;
      plot([1000,1000],[0 80],'k-');
      plot([2000,2000],[0 80],'k-');
      axis([0 3000 0 60])
      tightLayout
      set(gca, 'YGrid', 'on', 'XGrid', 'on')
      xlabel('time(minutes)')
      ylabel('Species Count')
      LabelPlot('B')
      axes=gca;
    end
    function axes=AnalysisSSATwoCellSwapReducedModel_HistogramTarget(obj)
      data=obj.datalayer.get('AnalysisSSATwoCellSwapReducedModel');
      hold on
      obj.makePlotHistogram(data.initialTargetData(:),0:60-.5,[1 .75 0],.6)
      obj.makePlotHistogram(data.finalTargetData(:),0:60-.5,'red',.4)
      plot((0:49),data.targetMarginal,'g-.','color',[0 0 0]+.1,'linewidth',2)
      tightLayout
      box on
      ylabel('Probability')
      xlabel('Species Count')
      legend('Initial','Final','Steady State')
      LabelPlot('C')
      axes=gca;
      axes.Position=[0.6916    0.5804    0.2767    0.3626];
      axes.Color=[1 1 1]*.95;
    end
    function AnalysisSSATwoCellSwapReducedModel_HistogramNonTarget(obj)
      data=obj.datalayer.get('AnalysisSSATwoCellSwapReducedModel');
      hold on
      obj.makePlotHistogram(data.initialNonTargetData(:),0:60-.5,'cyan',.6)
      obj.makePlotHistogram(data.finalNonTargetData(:),0:60-.5,'blue',.4)
      plot((0:49),data.nonTargetMarginal,'g-.','color',[0 0 0]+.1,'linewidth',2)
      tightLayout
      box on
      ylabel('Probability')
      xlabel('Species Count')
      legend('Initial','Final','Steady State')
      axes=gca;
      axes.Position=[0.6916    0.0967    0.2767    0.3626];
      axes.Color=[1 1 1]*.95;
      LabelPlot('D')
    end
    function AnalysisSSAFourCellSwapReducedModel_ControlInput(obj)
      data=obj.datalayer.get('AnalysisSSAFourCellSwapReducedModel');
      axis1=area(data.trajectory.node{1}.time(1:length(data.U)),data.U,'FaceColor','m');
      axis1.EdgeAlpha=0;
      tightLayout
      set(gca, 'YGrid', 'off', 'XGrid', 'on')
      xlabel('time(minutes)')
      ylabel('Control Input')
      LabelPlot('A')
      axes=gca;
      axes.Color=[1 1 1]*.95;
    end
    function AnalysisSSAFourCellSwapReducedModel_Trajectory(obj)
      data=obj.datalayer.get('AnalysisSSAFourCellSwapReducedModel');
      v = [0 0; 1000,0; 1000,60; 0,60];
      f = [1 2 3 4];
      patch('Faces',f,'Vertices',v,'FaceColor','blue','FaceAlpha',.1)
      v = [1000 0; 2000,0; 2000,60; 1000,60];
      f = [1 2 3 4];
      patch('Faces',f,'Vertices',v,'FaceColor','red','FaceAlpha',.1)
      v = [2000 0; 3000,0; 3000,60; 2000,60];
      f = [1 2 3 4];
      patch('Faces',f,'Vertices',v,'FaceColor','green','FaceAlpha',.1)
      hold on
      plot(data.trajectory.node{1}.time,30*ones(size(data.trajectory.node{1}.time)),'k-','LineWidth',1);
      plot(data.trajectory.node{1}.time,10*ones(size(data.trajectory.node{1}.time)),'k-','LineWidth',1);
      s1=stairs(data.trajectory.node{1}.time,data.trajectory.node{1}.state(1,:)','LineWidth',2);
      s1.Color=[0 0 1]*.8;
      s2=stairs(data.trajectory.node{1}.time,data.trajectory.node{1}.state(2,:)','LineWidth',2);
      s2.Color=[1 0 0]*.8;
      s3=stairs(data.trajectory.node{1}.time,data.trajectory.node{1}.state(3,:)','LineWidth',2);
      s3.Color=[0 1 0]*.8;
      s4=stairs(data.trajectory.node{1}.time,data.trajectory.node{1}.state(4,:)','LineWidth',1);
      s4.Color=[.5 .5 .5]*.8;
      plot([1000,1000],[0 80],'k-');
      plot([2000,2000],[0 80],'k-');
      axis([0 3000 0 60])
      tightLayout
      set(gca, 'YGrid', 'on', 'XGrid', 'on')
      xlabel('time(minutes)')
      ylabel('Species Count')
      LabelPlot('B')
      axes=gca;
    end
    function axes=AnalysisSSAFourCellSwapReducedModel_HistogramTarget(obj)
      data=obj.datalayer.get('AnalysisSSAFourCellSwapReducedModel');
      hold on
      obj.makePlotHistogram(data.initialTargetData(:),0:60-.5,[1 .75 0],.6)
      obj.makePlotHistogram(data.finalTargetData(:),0:60-.5,'red',.4)
      plot((0:49),data.targetMarginal,'g-.','color',[0 0 0]+.1,'linewidth',2)
      tightLayout
      box on
      ylabel('Probability')
      xlabel('Species Count')
      legend('Initial','Final','Steady State')
      LabelPlot('C')
      axes=gca;
      axes.Position=[0.6916    0.5804    0.2767    0.3626];
      axes.Color=[1 1 1]*.95;
    end
    function axes=AnalysisSSAFourCellSwapReducedModel_HistogramNonTarget(obj)
      data=obj.datalayer.get('AnalysisSSAFourCellSwapReducedModel');
      hold on
      obj.makePlotHistogram(data.initialNonTargetData(:),0:60-.5,'cyan',.6)
      obj.makePlotHistogram(data.finalNonTargetData(:),0:60-.5,'blue',.4)
      plot((0:49),data.nonTargetMarginal,'g-.','color',[0 0 0]+.1,'linewidth',2)
      tightLayout
      box on
      ylabel('Probability')
      xlabel('Species Count')
      legend('Initial','Final','Steady State')
      axes=gca;
      axes.Position=[0.6916    0.0967    0.2767    0.3626];
      axes.Color=[1 1 1]*.95;
      LabelPlot('D')
    end
    function axes=AnalysisSSAFSPPredictiveModelControl_ControlInput(obj)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveModelControl');
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
    function axes=AnalysisSSAFSPPredictiveModelControl_Trajectory(obj)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveModelControl');
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
    function axes=AnalysisSSAFSPPredictiveModelControl_JD(obj)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveModelControl');
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
      colorbar()
    end
    function axes=AnalysisSSAFSPPredictiveModelControl_MD(obj)
      data=obj.datalayer.get('AnalysisSSAFSPPredictiveModelControl');
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
      text(31,.16,sprintf('J= %.0f',data.score),'FontSize',11,'FontWeight','bold');
      xlabel('Species Count')
      ylabel('Probability')
      axes=gca;
      axes.Color=[1 1 1]*.95;
    end
    function axes=CalibrationCurveUnregulatedFullReduced_Hysteresis(obj)
      data1=obj.datalayer.get('CalibrationCurveHysteresisCalibratedModel');
      data2=obj.datalayer.get('AnalysisODEHysteresis_ReducedModelAutoregulated');
      hold on
      line1=plot(data1.range,data1.upTrajectory,'LineWidth',2)
      line2=plot(data1.range,data1.downTrajectory,'LineWidth',2)
      line3=plot(data2.range,data2.upTrajectory,'LineWidth',2)
      line4=plot(data2.range,data2.downTrajectory,'LineWidth',2)
      axes=gca;
    end
    function axes=AnalysisODEFrequencySeparation_FullModels_TrajectoryLow(obj)
      data=obj.datalayer.get('AnalysisODEFrequencySeparation_FullModels');
      hold on
      line1=plot(data.upAnalysis,data.range,'LineWidth',2)
      line2=plot(data.downanalysis,data.range,'LineWidth',2)
      axes=gca;
    end
    function axes=AnalysisODEFrequencySeparation_FullModels_TrajectoryMed(obj)
      data=obj.datalayer.get('AnalysisODEFrequencySeparation_FullModels');
      hold on
      line1=plot(data.upAnalysis,data.range,'LineWidth',2)
      line2=plot(data.downanalysis,data.range,'LineWidth',2)
      axes=gca;
    end
    function axes=AnalysisODEFrequencySeparation_FullModels_TrajectoryHigh(obj)
      data=obj.datalayer.get('AnalysisODEFrequencySeparation_FullModels');
      hold on
      line1=plot(data.upAnalysis,data.range,'LineWidth',2)
      line2=plot(data.downanalysis,data.range,'LineWidth',2)
      axes=gca;
    end
    function axes=makePlotForce(obj,data)
      hold on
      pcolorProbability(data.controlInput);
      plotQuiver=quiver(data.sampleX,data.sampleY,data.forcesX,data.forcesY,4/data.stepSize^2,'LineWidth',1);
      plotQuiver.Color=[1,1,1];
      xlim([0 50]);
      ylim([0 50]);
      set(gca,'xticklabel',[])
      set(gca,'yticklabel',[])
      caxis([0 1000]);
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
      text(31,.16,sprintf('J= %.0f',data.score),'FontSize',11,'FontWeight','bold');
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