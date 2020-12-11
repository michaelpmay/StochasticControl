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
      hold on
      obj.axes.ModelFitODE_UnregulatedReducedModel_Trajectory
      obj.axes.ModelFitODE_UnregulatedFullModel_Trajectory
      obj.axes.ModelFitODE_ExperimentalData_Trajectory
      legend({'$\mathcal{M}_U$',"$\mathcal{M}'_U$",'Experimental Data'},'Interpreter','latex')
      box(gca)
      LabelPlot('A')
      subplot(1,2,2)
      hold on
      obj.axes.ModelFitODEUnregulatedReducedModel_Calibration
      box(gca)
      ylabel("System Input (\phi') [Watts/cm^-1]")
      xlabel("Light Input (\phi) [Watts/cm^-1]")
      LabelPlot('B')
      legend({'Calibration Curve','Fit Points'},'Interpreter','latex')
      %obj.axes.ModelFit_UnregulatedFullModel_Histograms
    end
    function fig=Figure3(obj)
      fig=AcademicFigure;
      fig.Position(3:4)=[1250 605];
      subplot(1,2,1)
      hold on
      obj.axes.AnalysisODEHysteresis_Regions
      obj.axes.AnalysisODEHysteresis_ReducedModelUnregulated
      obj.axes.AnalysisODEHysteresis_ReducedModelAutoregulated
      ax=gca;
      ax.Position=[0.0587    0.1100    0.4194    0.8150];
      box(gca)
      ylim([0 50])
      xlim([0 400])
      xlabel('Input (Watts per cm^2)')
      ylabel('Species Count')
      LabelPlot('A')
      legend({'$\mathcal{M}_U\uparrow$','$\mathcal{M}_U\downarrow$','$\mathcal{M}_A\uparrow$','$\mathcal{M}_A\downarrow$'},'Interpreter','latex')
      subplot(3,2,2)
      hold on
      obj.axes.AnalysisODEFrequency_ReducedModels_Input
      box(gca)
      xlabel('Period (AU)')
      ylabel('Input (Watts per cm^2)')
      tightLayout
      
      ax=gca;
      ax.Position=[0.5437    0.6992    0.4106    0.2327];
      LabelPlot('B')
      subplot(3,2,4)
      obj.axes.AnalysisODEFrequencySeparation_ReducedModel
      lgnd1=columnlegend(2,{'LIC \omega=0.0001 RPM','LIC \omega=0.0001 RPM','LIC \omega=0.01 RPM','HIC \omega=0.01 RPM'});
      lgnd1.Position=[0.7134 0.5230 0.2448 0.1017];
      box(gca)
      xlabel('Period (AU)')
      ylabel('Species Count')
      tightLayout
      ylim([0 50])
      ax=gca;
      ax.Position=[0.5437    0.4017    0.4106    0.2254];
      LabelPlot('C')
      subplot(3,2,6)
      obj.axes.AnalysisODEFrequencyOmegaCrit_ReducedModel
      lgnd2=columnlegend(2,{'LIC \omega_c','HIC \omega_c','LIC \omega_c-\epsilon','HIC \omega_c-\epsilon'});
      lgnd2.Position=[0.8264 0.1989 0.1130 0.1347];
      box(gca)
      ylim([0 50])
      xlabel('Period (AU)')
      ylabel('Species Count')
      tightLayout
      ax=gca;
      ax.Position=[0.5437    0.1141    0.4106    0.2254];
      LabelPlot('D')
    end
    function fig=Figure4(obj)
      fig=AcademicFigure;
      fig.Position(3:4)=[800 400];
      obj.axes.AnalysisODESSAFrequency_ReducedModel_Trajectory;
      legend('HIC','LIC','SSA')
      LabelPlot('A');
      xlabel('time (minutes)')
      ylabel('Species Count')
      xlim([0 1000])
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
      axes3=obj.axes.AnalysisSSAFSPPredictiveModelControl_JD;
      tightLayout
      label=LabelPlot('C');
      ax=gca;
      ax.Position(3:4)=[.2293 .37];
      xlim([0 49]);
      ylim([0 49])
      
      label.Color='white';
      
      subplot(2,3,6);
      axes4=obj.axes.AnalysisSSAFSPPredictiveModelControl_MD;
      tightLayout
      LabelPlot('D')
      box(axes4);
      lgnd=legend({'Target','NonTarget'});
      lgnd.Position=[0.8373 0.3015 0.1110 0.0542];
    end
    function fig=Figure9(obj)
      fig=AcademicFigure;
      fig.Position(3:4)=[1000 600];
      subplot(1,3,1)
      obj.axes.CalibrationCurveUnregulatedFullReduced_Hysteresis
      tightLayout
      subplot(1,3,2)
      obj.axes.CalibrationCurveUnregulatedFullReduced_Calibration
      tightLayout
      subplot(3,3,3)
      obj.axes.AnalysisODEFrequencySeparation_FullModels_TrajectoryLow
      tightLayout
      subplot(3,3,6)
      obj.axes.AnalysisODEFrequencySeparation_FullModels_TrajectoryMed
      tightLayout
      subplot(3,3,9)
      obj.axes.AnalysisODEFrequencySeparation_FullModels_TrajectoryHigh
      tightLayout
    end
        function fig=Figure10(obj)
      fig=AcademicFigure;
      fig.Position(3:4)=[1000 600];
        end
        function fig=Figure11(obj)
      fig=AcademicFigure;
      fig.Position(3:4)=[1000 600];
    end
  end
end