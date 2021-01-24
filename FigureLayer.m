classdef FigureLayer
  properties
    axes=AxesLayer;
    layout=FigureLayout;
  end
  methods
    function Figure1(obj)
      %Fig 1 is generated using
    end
    function fig=Figure2(obj)
      fig=AcademicFigure;
      fig.Position(3:4)=[1300 350];
      subplot(1,3,1)
      hold on
      obj.axes.ModelFitODE_Panel
      xlabel('time')
      ylabel('Species Count')
      hold on
      obj.axes.ModelFitODE_UnregulatedReducedModel_Trajectory
      obj.axes.ModelFitODE_UnregulatedFullModel_Trajectory
      obj.axes.ModelFitODE_ExperimentalData_Trajectory
      l1=legend({'$\mathcal{M}_U$',"$\mathcal{M}'_U$",'Experimental Data'},'Interpreter','latex');
      box(gca)
      xlim([0 780])
      LabelPlot('A')
      subplot(1,3,2)
      hold on
      obj.axes.ModelFitODEUnregulatedReducedModel_Calibration
      obj.axes.ModelFitODEUnregulatedFullModel_Calibration
      box(gca)
      xlabel("System Input (\phi') [Watts/cm^-1]")
      ylabel("Light Input (u) [min^-1]")
      axis([0 350 0 .45])
      LabelPlot('B')
      l2=legend({'Calibration Curve $\mathcal{M}_U$',"Calibration Curve $\mathcal{M}'_U$"},'Interpreter','latex');
      l2.Position=[0.4823 0.1687 0.1318 0.0951];
      subplot(1,3,3)
      hold on
      obj.axes.ModelFitSSAUnregulatedReducedModel_Calib_Histogram
      obj.axes.ModelFitSSAUnregulatedReducedModel_Calib_Mean(gca,[30 .12])
      obj.axes.ModelFitSSAUnregulatedFullModel_Calib_Histogram
      obj.axes.ModelFitSSAUnregulatedFullModel_Calib_Mean(gca,[30 .11])
      legend('$\mathcal{M}_U \phi = 20 \ W/cm^2$',"$\mathcal{M}'_U \phi = 4.6 \ W/cm^2$",'Interpreter','latex')
      xlabel(gca,'Species Count')
      ylabel(gca,'Probability')
      t3=LabelPlot('C');
      t3.Position(3)=[0.0534];
      axe=gca;
      axe.Children(1).FontSize=12;
      axe.Children(1).FontWeight='bold';
      axe.Children(1).Color=[.3 .3 1];
      axe.Children(3).FontSize=12;
      axe.Children(3).FontWeight='bold';
      axe.Children(3).Color=[1 .3 .3];
    end
    function fig=Figure3(obj)
      fig=AcademicFigure;
      ax=obj.layout.Layout3;
      hold(ax{1},'on')
      obj.axes.AnalysisODEHysteresis_Regions(ax{1})
      obj.axes.AnalysisODEHysteresis_ReducedModelUnregulated(ax{1})
      obj.axes.AnalysisODEHysteresis_ReducedModelAutoregulated(ax{1})
      ylim(ax{1},[0 50])
      xlim(ax{1},[0 .5])
      xlabel(ax{1},'Input (Watts per cm^2)')
      ylabel(ax{1},'Species Count')
      legend({'$\mathcal{M}_U\uparrow$','$\mathcal{M}_U\downarrow$','$\mathcal{M}_A\uparrow$','$\mathcal{M}_A\downarrow$'},'Interpreter','latex','Location','southeast')
      obj.axes.AnalysisODEFrequency_ReducedModels_Input(ax{2})
      xlabel(ax{2},'Period (AU)')
      ylabel(ax{2},'Input ($[species]^-1 [min]^-1$)','Interpreter','latex')
      obj.axes.AnalysisODEFrequencySeparation_ReducedModel(ax{3})
      axes(ax{3})
      lgnd1=columnlegend(2,{'LIC \omega_1','HIC \omega_1','LIC \omega_2','HIC \omega_2'});
      lgnd1.Position=[0.8296 0.5034 0.1208 0.1247];
      xlabel(ax{3},'Period (AU)')
      ylabel(ax{3},'Species Count')
      ylim(ax{3},[0 50])
      obj.axes.AnalysisODEFrequencyOmegaCrit_ReducedModel(ax{4})
      axes(ax{4})
      lgnd2=columnlegend(2,{'LIC \omega_c','HIC \omega_c','LIC \omega_c-\epsilon','HIC \omega_c-\epsilon'});
      lgnd2.Position=[0.8320 0.2022 0.1130 0.1347];
      box(gca)
      ylim([0 50])
      xlabel('Period (AU)')
      ylabel('Species Count')
    end
    function fig=Figure4(obj)
      fig=AcademicFigure;
      fig.Position(3:4)=[800 400];
      obj.axes.AnalysisODESSAFrequency_ReducedModel_Trajectory;
      legend('HIC','LIC','SSA')
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
      subtightplot(3,4,1,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_UnregulatedUniform_Force;
      xlabel('Species Count');
      ylabel('Species Count');
      set(gca, 'XTickMode', 'auto', 'XTickLabelMode', 'auto')
      set(gca, 'YTickMode', 'auto', 'YTickLabelMode', 'auto')
      title("$\mathcal{M}'_U$-UC",'Interpreter','latex','Fontsize',titleFontSize)
      subtightplot(3,4,5,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_UnregulatedUniform_JD;
      xlabel('Species Count');
      ylabel('Species Count');
      set(gca, 'XTickMode', 'auto', 'XTickLabelMode', 'auto')
      set(gca, 'YTickMode', 'auto', 'YTickLabelMode', 'auto')
      subtightplot(3,4,9,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_UnregulatedUniform_MD;
      xlabel('Species Count');
      ylabel('Probability');
      set(gca, 'XTickMode', 'auto', 'XTickLabelMode', 'auto')
      set(gca, 'YTickMode', 'auto', 'YTickLabelMode', 'auto')
      subtightplot(3,4,2,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_UnregulatedFull_Force;
      title("$\mathcal{M}'_U$-FC",'Interpreter','latex','Fontsize',titleFontSize)
      subtightplot(3,4,6,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_UnregulatedFull_JD;
      subtightplot(3,4,10,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_UnregulatedFull_MD;
      subtightplot(3,4,3,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_AutoregulatedUniform_Force;
      title("$\mathcal{M}'_A$-UC",'Interpreter','latex','Fontsize',titleFontSize);
      subtightplot(3,4,7,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_AutoregulatedUniform_JD;
      subtightplot(3,4,11,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_AutoregulatedUniform_MD;
      subtightplot(3,4,4,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_AutoregulatedFull_Force;
      title("$\mathcal{M}'_A$-FC",'Interpreter','latex','Fontsize',titleFontSize)
      cbar1=colorbar;
      cbar1.Position=[0.9246    0.6800    0.0152    0.2400];
      subtightplot(3,4,8,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_AutoregulatedFull_JD;
      cbar2=colorbar;
      cbar2.Position=[0.9246   0.3700    0.0152    0.2400];
      subtightplot(3,4,12,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_AutoregulatedFull_MD;
      lgnd=legend('Target','Non-Target');
      lgnd.Position=[0.8673    0.1555    0.1109    0.0537];
    end
    function fig=Figure6(obj)
      fig=AcademicFigure;
      ax=obj.layout.Layout6;
      obj.axes.AnalysisSSATwoCellSwapReducedModel_Patches(ax{1});
      obj.axes.AnalysisSSATwoCellSwapReducedModel_ControlInput(ax{1});
      xlabel(ax{1},'time(minutes)')
      ylabel(ax{1},'Control Input')
      ylim(ax{1},[0 1.5])
      obj.axes.AnalysisSSATwoCellSwapReducedModel_Patches(ax{2});
      obj.axes.AnalysisSSATwoCellSwapReducedModel_Trajectory(ax{2});
      xlabel(ax{2},'time(minutes)')
      ylabel(ax{2},'Species Count')
      obj.axes.AnalysisSSATwoCellSwapReducedModel_HistogramTarget(ax{3});
      ylabel(ax{3},'Probability')
      xlabel(ax{3},'Species Count')
      legend(ax{3},'Initial','Final','Steady State')
      obj.axes.AnalysisSSATwoCellSwapReducedModel_HistogramNonTarget(ax{4});
      ylabel(ax{4},'Probability')
      xlabel(ax{4},'Species Count')
      legend(ax{4},'Initial','Final','Steady State') 
    end
    function fig=Figure7(obj)
      ax=obj.layout.Layout6;
      obj.axes.AnalysisSSAFourCellSwapReducedModel_Patches(ax{1});
      obj.axes.AnalysisSSAFourCellSwapReducedModel_ControlInput(ax{1});
      xlabel(ax{1},'time(minutes)')
      ylabel(ax{1},'Control Input')
      ylim(ax{1},[0 1.5])
      obj.axes.AnalysisSSAFourCellSwapReducedModel_Patches(ax{2});
      obj.axes.AnalysisSSAFourCellSwapReducedModel_Trajectory(ax{2});
      xlabel(ax{2},'time(minutes)')
      ylabel(ax{2},'Species Count')
      lgnd=legend(ax{2},{'Target','NonTarget'});
      obj.axes.AnalysisSSAFourCellSwapReducedModel_HistogramTarget(ax{3});
      ylabel(ax{3},'Probability')
      xlabel(ax{3},'Species Count')
      legend(ax{3},'Initial','Final','Steady State')
      obj.axes.AnalysisSSAFourCellSwapReducedModel_HistogramNonTarget(ax{4});
      ylabel(ax{4},'Probability')
      xlabel(ax{4},'Species Count')
      legend(ax{4},'Initial','Final','Steady State') 
      fig=gcf;
    end
    function fig=Figure8(obj)
      fig=AcademicFigure;
      fig.Position(3:4)=[1000 600];
      subplot(2,3,[1,2]);
      obj.axes.AnalysisSSAFSPPredictiveReducedModelControl_ControlInput(gca);
      axes(gca)
      tightLayout
      LabelPlot('A')
      subplot(2,3,[4,5]);
      obj.axes.AnalysisSSAFSPPredictiveReducedModelControl_Trajectory(gca);
      axes(gca)
      tightLayout
      LabelPlot('B')
      subplot(2,3,[3]);
      axes3=obj.axes.AnalysisSSAFSPPredictiveReducedModelControl_JD(gca);
      axes(gca)
      tightLayout
      label=LabelPlot('C');
      ax=gca;
      ax.Position(3:4)=[.2293 .37];
      xlim([0 49]);
      ylim([0 49])
      label.Color='white';
      subplot(2,3,6);
      axes4=obj.axes.AnalysisSSAFSPPredictiveReducedModelControl_MD(gca);
      axes(gca)
      tightLayout
      LabelPlot('D')
      box(axes4);
      lgnd=legend({'Target','NonTarget'});
      lgnd.Position=[0.8373 0.3015 0.1110 0.0542];
    end
    function fig=Figure9(obj)
      fig.Position(3:4)=[1000 600];
      subplot(2,3,[1,2]);
      obj.axes.AnalysisSSAFSPPredictiveFullModelControl_ControlInput(gca);
      tightLayout
      LabelPlot('A')
      subplot(2,3,[4,5]);
      obj.axes.AnalysisSSAFSPPredictiveFullModelControl_Trajectory(gca);
      tightLayout
      LabelPlot('B')
      subplot(2,3,[3]);
      axes3=obj.axes.AnalysisSSAFSPPredictiveFullModelControl_JD(gca);
      tightLayout
      label=LabelPlot('C');
      ax=gca;
      ax.Position(3:4)=[.2293 .37];
      xlim([0 49]);
      ylim([0 49])
      label.Color='white';
      subplot(2,3,6);
      axes4=obj.axes.AnalysisSSAFSPPredictiveFullModelControl_MD(gca);
      tightLayout
      LabelPlot('D')
      box(axes4);
      lgnd=legend({'Target','NonTarget'});
      lgnd.Position=[0.8373 0.3015 0.1110 0.0542];
    end
    function fig=Figure10(obj)
      ax=obj.layout.Layout10;
      obj.axes.CalibrationCurveUnregulatedFullReduced_Calibration(ax{1});
      xlabel(ax{1},"$\mathcal{M}'_A$ Control Input",'Interpreter','latex');
      ylabel(ax{1},"$\mathcal{M}_A$ Control Output",'Interpreter','latex');
      xlim(ax{2},[0 1])
      obj.axes.AnalysisODEHysteresis_Regions(ax{2});
      obj.axes.CalibrationCurveUnregulatedFullReduced_Hysteresis(ax{2});
      lgnd1=legend(ax{2},{"$\mathcal{M}'_A\uparrow$","$\mathcal{M}'_A\downarrow$","$\mathcal{M}_A\uparrow$","$\mathcal{M}_A\downarrow$"},'Interpreter','latex','Location','southeast');
      xlim(ax{2},[0 .5]);
      ylim(ax{2},[0 50]);
      xlabel(ax{2},'Control Input');
      ylabel(ax{2},'Species Count');
      obj.axes.AnalysisODEFrequencySeparation_FullModels_TrajectoryLow(ax{3})
      axes(ax{3})
      lgnd2=columnlegend(2,{"$\mathcal{M}'_A$","$\mathcal{M}_A$"},'Interpreter','latex');
      lgnd2.Position=[0.8690 0.8351 0.1117 0.1016];
      ylim(ax{3},[0 50])
      obj.axes.AnalysisODEFrequencySeparation_FullModels_TrajectoryMed(ax{4})   
      ylim(ax{4},[0 50])
      obj.axes.AnalysisODEFrequencySeparation_FullModels_TrajectoryHigh(ax{5})
      xlabel(ax{5},'Period (AU)');
      ylabel(ax{5},'Species Count');
      ylim(ax{5},[0 50])
      fig=gcf;
    end
    function fig=Figure11(obj)
      fig=AcademicFigure;
      fig.Position(3:4)=[1800 600];
      subplot(2,5,1)
      obj.axes.AnalysisSSAFSPPredictiveReducedModelReducedControl_JD
      title("$\mathcal{M}'$-RC",'Interpreter','latex')
      subplot(2,5,2)
      obj.axes.AnalysisSSAFSPPredictiveReducedModelControl_JD(gca)
      title("$\mathcal{M}'$-MPC"','Interpreter','latex')
      subplot(2,5,3)
      obj.axes.AnalysisSSAFSPPredictiveFullModelReducedControl_JD(gca)
      title("$\mathcal{M}$-RC",'Interpreter','latex')
      subplot(2,5,4)
      obj.axes.AnalysisSSAFSPPredictiveFullModelControl_JD(gca)
      title("$\mathcal{M}$-MPC",'Interpreter','latex')
      subplot(2,5,5)
      obj.axes.AnalysisSSAFSPPredictiveFullModelControlSlowed_JD
      title("$\mathcal{M}$-SMPC",'Interpreter','latex')
      c=colorbar('eastoutside');
      c.Position=[0.9188 0.5833 0.0147 0.3417];
      subplot(2,5,6)
      obj.axes.AnalysisSSAFSPPredictiveReducedModelReducedControl_ScoreDist(gca)
      xlim([-0 40])
      ylim([0 .3])
      subplot(2,5,7)
      obj.axes.AnalysisSSAFSPPredictiveReducedModelControl_ScoreDist
      xlim([-0 40])
      ylim([0 .3])
      subplot(2,5,8)
      obj.axes.AnalysisSSAFSPPredictiveFullModelReducedControl_ScoreDist
      xlim([-0 40])
      ylim([0 .3])
      subplot(2,5,9)
      obj.axes.AnalysisSSAFSPPredictiveFullModelControl_ScoreDist
      xlim([-0 40])
      ylim([0 .3])
      subplot(2,5,10)
      obj.axes.AnalysisSSAFSPPredictiveFullModelControlSlowed_ScoreDist
      xlim([-0 40])
      ylim([0 .3])
    end
    function fig=Figure12(obj)
      fig=AcademicFigure;
      titleFontSize=16;
      gap=[.07 .015];
      width=[.06 .08];
      height=[.06 .08];
      subtightplot(3,5,1,gap,width,height)
      obj.axes.AnalysisSSAFullModelControlPairs_UnregulatedUniform_Input;
      xlabel('Species Count');
      ylabel('Species Count');
      set(gca, 'XTickMode', 'auto', 'XTickLabelMode', 'auto')
      set(gca, 'YTickMode', 'auto', 'YTickLabelMode', 'auto')
      caxis([0 .1])
      title('$\mathcal{M}_U$-UC','Interpreter','latex','Fontsize',titleFontSize)
      subtightplot(3,5,6,gap,width,height)
      obj.axes.AnalysisSSAFullModelControlPairs_UnregulatedUniform_JD;
      xlabel('Species Count');
      ylabel('Species Count');
      set(gca, 'XTickMode', 'auto', 'XTickLabelMode', 'auto')
      set(gca, 'YTickMode', 'auto', 'YTickLabelMode', 'auto')
      subtightplot(3,5,11,gap,width,height)
      obj.axes.AnalysisSSAFullModelControlPairs_UnregulatedUniform_MD;
      xlabel('Species Count');
      ylabel('Probability');
      set(gca, 'XTickMode', 'auto', 'XTickLabelMode', 'auto')
      set(gca, 'YTickMode', 'auto', 'YTickLabelMode', 'auto')
      subtightplot(3,5,2,gap,width,height)
      obj.axes.AnalysisSSAFullModelControlPairs_UnregulatedFull_Input;
      caxis([0 .1])
      set(gca,'xticklabel',[])
      set(gca,'yticklabel',[])
      title('$\mathcal{M}_U$-FC','Interpreter','latex','Fontsize',titleFontSize)
      subtightplot(3,5,7,gap,width,height)
      obj.axes.AnalysisSSAFullModelControlPairs_UnregulatedFull_JD;
      subtightplot(3,5,12,gap,width,height)
      obj.axes.AnalysisSSAFullModelControlPairs_UnregulatedFull_MD;
      
      subtightplot(3,5,3,gap,width,height)
      obj.axes.AnalysisSSAFullModelControlPairs_AutoregulatedUniform_Input;
      caxis([0 .1])
      set(gca,'xticklabel',[])
      set(gca,'yticklabel',[])
      title('$\mathcal{M}_A$-UC','Interpreter','latex','Fontsize',titleFontSize);
      subtightplot(3,5,8,gap,width,height)
      obj.axes.AnalysisSSAFullModelControlPairs_AutoregulatedUniform_JD;
      subtightplot(3,5,13,gap,width,height)
      obj.axes.AnalysisSSAFullModelControlPairs_AutoregulatedUniform_MD;
      
      subtightplot(3,5,4,gap,width,height)
      obj.axes.AnalysisSSAFullModelControlPairs_AutoregulatedFull_Input;
      caxis([0 .1])
      set(gca,'xticklabel',[])
      set(gca,'yticklabel',[])
      title('$\mathcal{M}_A$-FC','Interpreter','latex','Fontsize',titleFontSize)
      subtightplot(3,5,9,gap,width,height)
      obj.axes.AnalysisSSAFullModelControlPairs_AutoregulatedFull_JD
      subtightplot(3,5,14,gap,width,height)
      obj.axes.AnalysisSSAFullModelControlPairs_AutoregulatedFull_MD
      
      subtightplot(3,5,5,gap,width,height)
      obj.axes.AnalysisSSAFullModelControlPairs_AutoregulatedReduced_Input;
      caxis([0 .1])
      set(gca,'xticklabel',[])
      set(gca,'yticklabel',[])
      title('$\mathcal{M}_A$-RC','Interpreter','latex','Fontsize',titleFontSize)
      cbar1=colorbar;
      cbar1.Position=[0.9246    0.6800    0.0152    0.2400];
      subtightplot(3,5,10,gap,width,height)
      obj.axes.AnalysisSSAFullModelControlPairs_AutoregulatedReduced_JD;
      cbar2=colorbar;
      cbar2.Position=[0.9246   0.3700    0.0152    0.2400];
      subtightplot(3,5,15,gap,width,height)
      obj.axes.AnalysisSSAFullModelControlPairs_AutoregulatedReduced_MD;
      lgnd=legend('Target','Non-Target');
      lgnd.Position=[0.8673    0.1555    0.1109    0.0537];
    end
    function fig=Figure13(obj)
      fig=AcademicFigure;
      fig.Position(3:4)=[1000 600];
      subplot(2,3,[1,2]);
      obj.axes.AnalysisSSAFSPPredictiveFullModelControlSlowed_ControlInput;
      tightLayout
      LabelPlot('A')
      subplot(2,3,[4,5]);
      obj.axes.AnalysisSSAFSPPredictiveFullModelControlSlowed_Trajectory;
      tightLayout
      LabelPlot('B')
      subplot(2,3,[3]);
      axes3=obj.axes.AnalysisSSAFSPPredictiveFullModelControlSlowed_JD;
      tightLayout
      label=LabelPlot('C');
      ax=gca;
      ax.Position(3:4)=[.2293 .37];
      xlim([0 49]);
      ylim([0 49])
      label.Color='white';
      subplot(2,3,6);
      axes4=obj.axes.AnalysisSSAFSPPredictiveFullModelControlSlowed_MD;
      tightLayout
      LabelPlot('D')
      box(axes4);
      lgnd=legend({'Target','NonTarget'});
      lgnd.Position=[0.8373 0.3015 0.1110 0.0542];
    end
    function fig=Figure14(obj)
      ax=obj.layout.Layout14;
      ax{1}=obj.axes.AnalysisSSATwoCellFullModelReducedControl_ControlInput(ax{1});
      ylabel(ax{1},{'Control';'Input'})
      axis(ax{1},[0 3000 0 .1])
      ax{2}=obj.axes.AnalysisSSATwoCellFullModelReducedControl_Trajectory(ax{2});
      axis(ax{2},[0 3000 0 60])
      ylabel(ax{2},'Species Count')
      xlabel(ax{2},'time (minutes)')
      legend(ax{2},{'Target','NonTarget'},'Orientation','horizontal');
      ylim(ax{2},[0 50])
      lgnd=legend(ax{2},{'Target','NonTarget'},'Position',[0.4151 0.7555 0.1931 0.0298]);
      ax{3}=obj.axes.AnalysisSSATwoCellFullModelReducedControl_JD(ax{3});
      obj.axes.AnalysisSSATwoCellFullModelReducedControl_PScore(ax{3}); 
      ylabel(ax{3},'Species Count')
      xlabel(ax{3},'Species Count')
      ax{4}=obj.axes.AnalysisSSAFSPPredictiveFullModelControl_ControlInput(ax{4});
      ylabel(ax{4},{'Control';'Input'})
      xlabel(ax{4},'')
      axis(ax{4},[0 3000 0 1])
      ax{5}=obj.axes.AnalysisSSAFSPPredictiveFullModelControl_Trajectory(ax{5});
      ylabel(ax{5},'Species Count')
      xlabel(ax{5},'time (minutes)')
      legend(ax{5},{'Probability','Target','NonTarget','Predicion'},'Orientation','horizontal');
      axis(ax{5},[0 3000 0 50])
      ax{6}=obj.axes.AnalysisSSAFSPPredictiveFullModelControl_JD(ax{6});
      ax{6}=obj.axes.AnalysisSSAFSPPredictiveFullModelControl_PScore(ax{6});
      ylabel(ax{6},'Species Count')
      xlabel(ax{6},'Species Count')
      children=allchild(gcf);
      children=children(13).Children;
      children(1).Color=[1 1 1];
      children(4).Color=[1 1 1];
      fig=gcf;
      fig.Children(1).Position=[0.9295 0.0860 0.0164 0.3851];
      fig.Children(3).Position=[0.9295 0.5620 0.0164 0.3917];
    end
    function fig=Figure15(obj)
      ax=obj.layout.Layout14;
      ax{1}=obj.axes.AnalysisSSATwoCellReducedModelReducedControl_ControlInput(ax{1});
      ylabel(ax{1},{'Control';'Input'})
      axis(ax{1},[0 3000 0 1.5])
      ax{2}=obj.axes.AnalysisSSATwoCellReducedModelReducedControl_Trajectory(ax{2});
      axis(ax{2},[0 3000 0 60])
      ylabel(ax{2},'Species Count')
      xlabel(ax{2},'time (minutes)')
      legend(ax{2},{'Target','NonTarget'},'Orientation','horizontal');
      ylim(ax{2},[0 50])
      lgnd=legend(ax{2},{'Target','NonTarget'},'Position',[0.4151 0.7555 0.1931 0.0298]);
      ax{3}=obj.axes.AnalysisSSATwoCellReducedModelReducedControl_JD(ax{3});
      obj.axes.AnalysisSSATwoCellReducedModelReducedControl_PScore(ax{3}); 
      ylabel(ax{3},'Species Count')
      xlabel(ax{3},'Species Count')
      ax{4}=obj.axes.AnalysisSSAFSPPredictiveReducedModelControl_ControlInput(ax{4});
      ylabel(ax{4},{'Control';'Input'})
      xlabel(ax{4},'')
      axis(ax{4},[0 3000 0 1])
      ax{5}=obj.axes.AnalysisSSAFSPPredictiveReducedModelControl_Trajectory(ax{5});
      ylabel(ax{5},'Species Count')
      xlabel(ax{5},'time (minutes)')
      legend(ax{5},{'Probability','Target','NonTarget','Predicion'},'Orientation','horizontal');
      axis(ax{5},[0 3000 0 50])
      ax{6}=obj.axes.AnalysisSSAFSPPredictiveReducedModelControl_JD(ax{6});
      ax{6}=obj.axes.AnalysisSSAFSPPredictiveReducedModelControl_PScore(ax{6});
      ylabel(ax{6},'Species Count')
      xlabel(ax{6},'Species Count')
      caxis(ax{6},[0 .01])
      children=allchild(gcf);
      children=children(13).Children;
      children(1).Color=[1 1 1];
      children(4).Color=[1 1 1];
      fig=gcf;
      fig.Children(1).Position=[0.9295 0.0860 0.0164 0.3851];
      fig.Children(3).Position=[0.9295 0.5620 0.0164 0.3917];
    end
    function fig=Figure16(obj)
      ax=obj.layout.Layout15;
      ax{1}=obj.axes.AnalysisSSATwoCellReducedModel_ControlInput(ax{1});
      ylabel(ax{1},{'Control';'Input'})
      axis(ax{1},[0 3000 0 1.5])
      ax{2}=obj.axes.AnalysisSSATwoCellReducedModel_Trajectory(ax{2});
      axis(ax{2},[0 3000 0 60])
      ylabel(ax{2},'Species Count')
      xlabel(ax{2},'time (minutes)')
      legend(ax{2},{'Target','NonTarget'},'Orientation','horizontal');
      ylim(ax{2},[0 50])
      lgnd=legend(ax{2},{'Target','NonTarget'},'Position',[0.4220 0.5507 0.1931 0.0590]);
      ax{3}=obj.axes.AnalysisSSATwoCellReducedModel_ScoreDist(ax{3});
      obj.axes.AnalysisSSATwoCellReducedModel_PScore(ax{3},[300 .95]); 
      ylabel(ax{3},'Probability')
      xlabel(ax{3},'Score')
      fig=gcf;
      xlim(ax{3},[-50 1000])
      ylim(ax{3},[0 1])
    end
    function fig=Figure17(obj)
      ax=obj.layout.Layout15;
      ax{1}=obj.axes.AnalysisSSATwoCellFullModel_ControlInput(ax{1});
      ylabel(ax{1},{'Control';'Input'})
      axis(ax{1},[0 3000 0 .1])
      ax{2}=obj.axes.AnalysisSSATwoCellFullModel_Trajectory(ax{2});
      axis(ax{2},[0 3000 0 60])
      ylabel(ax{2},'Species Count')
      xlabel(ax{2},'time (minutes)')
      legend(ax{2},{'Target','NonTarget'},'Orientation','horizontal');
      ylim(ax{2},[0 50])
      lgnd=legend(ax{2},{'Target','NonTarget'},'Position',[0.4220 0.5507 0.1931 0.0590]);
      ax{3}=obj.axes.AnalysisSSATwoCellFullModel_ScoreDist(ax{3});
      obj.axes.AnalysisSSATwoCellFullModelReducedControl_PScore(ax{3},[300 .95]); 
      ylabel(ax{3},'Probability')
      xlabel(ax{3},'Score')
      fig=gcf;
      xlim(ax{3},[-50 1000])
      ylim(ax{3},[0 1])
    end
    function fig=Figure18(obj)
      ax=obj.layout.Layout15;
      ax{1}=obj.axes.AnalysisSSATwoCellReducedModelReducedControl_ControlInput(ax{1});
      ylabel(ax{1},{'Control';'Input'})
      axis(ax{1},[0 3000 0 1])
      ax{2}=obj.axes.AnalysisSSATwoCellReducedModelReducedControl_Trajectory(ax{2});
      axis(ax{2},[0 3000 0 60])
      ylabel(ax{2},'Species Count')
      xlabel(ax{2},'time (minutes)')
      legend(ax{2},{'Target','NonTarget'},'Orientation','horizontal');
      ylim(ax{2},[0 50])
      lgnd=legend(ax{2},{'Target','NonTarget'},'Position',[0.4220 0.5507 0.1931 0.0590]);
      ax{3}=obj.axes.AnalysisSSATwoCellReducedModelReducedControl_ScoreDist(ax{3});
      obj.axes.AnalysisSSATwoCellReducedModelReducedControl_PScore(ax{3},[300 .75]); 
      ylabel(ax{3},'Probability')
      xlabel(ax{3},'Score')
      fig=gcf;
      axis(ax{3},[-50 1000 0 .8])
    end
    function fig=Figure19(obj)
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
      title("$\mathcal{M}'_U$-UC",'Interpreter','latex','Fontsize',titleFontSize)
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
      title("$\mathcal{M}'_U$-FC",'Interpreter','latex','Fontsize',titleFontSize)
      subtightplot(3,5,7,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_UnregulatedFull_JD;
      subtightplot(3,5,12,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_UnregulatedFull_MD;
      subtightplot(3,5,3,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_AutoregulatedUniform_Force;
      title("$\mathcal{M}'_A$-UC",'Interpreter','latex','Fontsize',titleFontSize);
      subtightplot(3,5,8,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_AutoregulatedUniform_JD;
      subtightplot(3,5,13,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_AutoregulatedUniform_MD;
      subtightplot(3,5,4,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_AutoregulatedFull_Force;
      title("$\mathcal{M}'_A$-FC",'Interpreter','latex','Fontsize',titleFontSize)
      subtightplot(3,5,9,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_AutoregulatedFull_JD;
      subtightplot(3,5,14,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_AutoregulatedFull_MD;
      subtightplot(3,5,5,gap,width,height)
      obj.axes.AnalysisFSPReducedModelControlPairs_AutoregulatedReduced_Force;
      title("$\mathcal{M}'_A$-RC",'Interpreter','latex','Fontsize',titleFontSize)
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
  end
end