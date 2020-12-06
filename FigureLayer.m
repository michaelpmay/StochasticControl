classdef FigureLayer
  properties
    axes=AxesLayer;
  end
  methods
    function Figure1(obj)
      %Fig 1 is generated using
    end
    function fig=Figure2(obj)
      fig=AcademicFigure;
      fig.Position(3:4)=[1050,450];
      subplot(1,2,1)
      hold on
      obj.axes.ModelFitODE_Panel
      xlabel('time')
      ylabel('Species Count')
      legend({'$\mathcal{M}_U$','$\mathcal{M}_A$','$\mathcal{M}_U$','$\mathcal{M}_A$','Experimental Data'},'Interpreter','latex')
      hold on
      obj.axes.ModelFitODE_UnregulatedReducedModel_Trajectory
      obj.axes.ModelFitODE_UnregulatedFullModel_Trajectory
      obj.axes.ModelFitODE_ExperimentalData_Trajectory
      box(gca)
      LabelPlot('A')
      subplot(1,2,2)
      hold on
      obj.axes.ModelFitSSA_UnregulatedReducedModel_Low_Histogram
      obj.axes.ModelFitSSA_UnregulatedReducedModel_Med_Histogram
      obj.axes.ModelFitSSA_UnregulatedReducedModel_Hig_Histogram
      box(gca)
      ylabel('Probability')
      xlabel('Species Count')
      LabelPlot('B')
      %obj.axes.ModelFit_UnregulatedFullModel_Histograms
    end
    function fig=Figure3(obj)
      fig=AcademicFigure;
      fig.Position(3:4)=[1050 450];
      subplot(1,2,1)
      hold on
      obj.axes.AnalysisODEHysteresis_Regions
      obj.axes.AnalysisODEHysteresis_ReducedModelUnregulated
      obj.axes.AnalysisODEHysteresis_ReducedModelAutoregulated
      box(gca)
      ylim([0 50])
      xlim([0 500])
      xlabel('Input (Watts per cm^2)')
      ylabel('Species Count')
      LabelPlot('A')
      subplot(3,2,2)
      hold on
      obj.axes.AnalysisODEFrequency_ReducedModels_Input
      obj.axes.AnalysisODEFrequency_ReducedModels_Bound
      box(gca)
      xlabel('Period (AU)')
      ylabel('Input (Watts per cm^2)')
      tightLayout
      LabelPlot('B')
      subplot(3,2,4)
      obj.axes.AnalysisODEFrequencySeparation_ReducedModel
      box(gca)
      xlabel('Period (AU)')
      ylabel('Species Count')
      tightLayout
      LabelPlot('C')
      subplot(3,2,6)
      obj.axes.AnalysisODEFrequencyOmegaCrit_ReducedModel
      box(gca)
      xlabel('Period (AU)')
      ylabel('Species Count')
      tightLayout
      LabelPlot('D')
    end
    function fig=Figure4(obj)
      fig=AcademicFigure;
      obj.axes.AnalysisODESSAFrequency_ReducedModel_Trajectory
      LabelPlot('A')
      xlabel('time (minutes)')
      ylabel('Species Count')
    end
    function fig=Figure5(obj)
      fig=AcademicFigure;
      titleFontSize=16;
      gap=[.07 .015];
      width=[.06 .08];
      height=[.06 .08];
      subtightplot(3,5,1,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_UnregulatedUniform_Force;
      xlabel('Species Count');
      ylabel('Species Count');
      set(gca, 'XTickMode', 'auto', 'XTickLabelMode', 'auto')
      set(gca, 'YTickMode', 'auto', 'YTickLabelMode', 'auto')
      title('$\mathcal{M}_U$-UC','Interpreter','latex','Fontsize',titleFontSize)
      subtightplot(3,5,6,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_UnregulatedUniform_JD;
      xlabel('Species Count');
      ylabel('Species Count');
      set(gca, 'XTickMode', 'auto', 'XTickLabelMode', 'auto')
      set(gca, 'YTickMode', 'auto', 'YTickLabelMode', 'auto')
      subtightplot(3,5,11,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_UnregulatedUniform_MD;
      xlabel('Species Count');
      ylabel('Probability');
      set(gca, 'XTickMode', 'auto', 'XTickLabelMode', 'auto')
      set(gca, 'YTickMode', 'auto', 'YTickLabelMode', 'auto')
      subtightplot(3,5,2,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_UnregulatedFull_Force;
      title('$\mathcal{M}_U$-FC','Interpreter','latex','Fontsize',titleFontSize)
      subtightplot(3,5,7,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_UnregulatedFull_JD;
      subtightplot(3,5,12,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_UnregulatedFull_MD;
      
      subtightplot(3,5,3,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_AutoregulatedUniform_Force;
      title('$\mathcal{M}_A$-UC','Interpreter','latex','Fontsize',titleFontSize);
      subtightplot(3,5,8,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_AutoregulatedUniform_JD;
      subtightplot(3,5,13,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_AutoregulatedUniform_MD;
      
      subtightplot(3,5,4,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_AutoregulatedFull_Force;
      title('$\mathcal{M}_A$-FC','Interpreter','latex','Fontsize',titleFontSize)
      subtightplot(3,5,9,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_AutoregulatedFull_JD
      subtightplot(3,5,14,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_AutoregulatedFull_MD
      
      subtightplot(3,5,5,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_AutoregulatedReduced_Force;
      title('$\mathcal{M}_A$-RC','Interpreter','latex','Fontsize',titleFontSize)
      cbar1=colorbar;
      cbar1.Position=[0.9246    0.6800    0.0152    0.2400];
      subtightplot(3,5,10,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_AutoregulatedReduced_JD;
      cbar2=colorbar;
      cbar2.Position=[0.9246   0.3700    0.0152    0.2400];
      subtightplot(3,5,15,gap,width,height)
      
      obj.axes.AnalysisFSPReducedModelControlPairs_AutoregulatedReduced_MD;
      lgnd=legend('Target','Non-Target');
      lgnd.Position=[0.8673    0.1555    0.1109    0.0537];
    end
    function fig=Figure6(obj)
      fig=AcademicFigure;
      fig.Position(3:4)=[1000 600];
      subplot(2,3,[1,2]);
      obj.axes.AnalysisSSATwoCellSwapReducedModel_ControlInput;
      subplot(2,3,[4,5]);
      obj.axes.AnalysisSSATwoCellSwapReducedModel_Trajectory;
      subplot(2,3,3);
      obj.axes.AnalysisSSATwoCellSwapReducedModel_HistogramTarget;
      subtightplot(2,3,6);
      obj.axes.AnalysisSSATwoCellSwapReducedModel_HistogramNonTarget;
    end
    function fig=Figure7(obj)
      fig=AcademicFigure;
      fig.Position(3:4)=[1000 600];
      subplot(2,3,[1,2])
      obj.axes.AnalysisSSAFourCellSwapReducedModel_ControlInput;
      subplot(2,3,[4,5])
      obj.axes.AnalysisSSAFourCellSwapReducedModel_Trajectory;
      subplot(2,3,3)
      obj.axes.AnalysisSSAFourCellSwapReducedModel_HistogramTarget;
      subplot(2,3,6)
      obj.axes.AnalysisSSAFourCellSwapReducedModel_HistogramNonTarget;
    end
    function fig=Figure8(obj)
      fig=AcademicFigure;
      fig.Position(3:4)=[1000 600];
      subplot(2,3,[1,2]);
      obj.axes.AnalysisSSAFSPPredictiveModelControl_ControlInput;
      tightLayout
      LabelPlot('A')
      subplot(2,3,[4,5]);
      obj.axes.AnalysisSSAFSPPredictiveModelControl_Trajectory;
      tightLayout
      LabelPlot('B')
      subplot(2,3,[3]);
      obj.axes.AnalysisSSAFSPPredictiveModelControl_JD;
      tightLayout
      label=LabelPlot('C');
      label.Color='white';
      subplot(2,3,6);
      obj.axes.AnalysisSSAFSPPredictiveModelControl_MD;
      tightLayout
      LabelPlot('D')
    end
    function fig=Figure9(obj)
      
    end
  end
end