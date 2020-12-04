classdef AxesLayer
  properties
    dataFileName='data/file/data'
    datalayer=DataLayer
  end
  methods
    function axes=TestFile(obj)
      data=obj.datalayer.TestFile;
    end
    function axes=AnalysisODEFrequency_ReducedModels(obj)
      data=obj.datalayer.AnalysisODEFrequency_ReducedModels();
    end
    function axes=AnalysisODEFrequency_FullModels(obj)
      data=obj.datalayer.AnalysisODEFrequency_FullModels();
    end
    function axes=AnalysisODEFrequencyOmegaCrit_ReducedModel(obj)
      data=obj.datalayer.get('AnalysisODEFrequencyOmegaCrit_ReducedModel')
      hold on 
      plot(data.wHigh_LIC.state((end-50):end))
      plot(data.wHigh_HIC.state((end-50):end))
      plot(data.wLow_LIC.state((end-50):end))
      plot(data.wLow_HIC.state((end-50):end))
    end
    function axes=AnalysisODESSAFrequency_ReducedModel(obj)
      data=obj.datalayer.get('AnalysisODESSAFrequency_ReducedModel');
      hold on
      plot(data.ODE_HIC.state((end-1500):end))
      plot(data.ODE_LIC.state((end-1500):end))
      plot(data.SSA.node{1}.state((end-1500):end))
    end
    function axes=AnalysisFSPReducedModelControlPairs(obj)
      data=obj.datalayer.AnalysisFSPReducedModelControlPairs();
      titleFontSize=16;
      Academicaxesure();
      ax{1}=plotModel(data.UnregulatedModelUniformControlerFSP,1,data.target);
      
      ax{2}=plotModel(data.UnregulatedModelFullControlerFSP,2,data.target);
      
      ax{3}=plotModel(data.AutoregulatedModelUniformControlerFSP,3,data.target);
      
      ax{4}=plotModel(data.AutoregulatedModelFullControlerFSP,4,data.target);
      
      ax{5}=plotModel(data.AutoregulatedModelReducedControlerFSP,5,data.target);
      
      axes(ax{1}(1));
      
      title({'$\mathcal{M}_U-UC$'},'Interpreter','latex','Fontsize',titleFontSize);
      axes(ax{2}(1))
      title({"$\mathcal{M}_U-FC$"},'Interpreter','latex','Fontsize',titleFontSize);
      axes(ax{3}(1))
      title({"$\mathcal{M}_A-UC$"},'Interpreter','latex','Fontsize',titleFontSize);
      axes(ax{4}(1))
      title({"$\mathcal{M}_A-FC$"},'Interpreter','latex','Fontsize',titleFontSize);
      axes(ax{5}(1))
      title({"$\mathcal{M}_A-RC$"},'Interpreter','latex','Fontsize',titleFontSize);
      
      axes(ax{1}(1));
      xlabel('Species Count');
      ylabel('Species Count');
      axes(ax{1}(2));
      xlabel('Species Count');
      ylabel('Species Count');
      axes(ax{1}(3));
      xlabel('Species Count');
      ylabel('Probability');
      axes(ax{4}(3));
      lgnd=legend('Target','Non-Target');
      lgnd.Position=[0.8673    0.1555    0.1109    0.0537];
      
      function ax=plotModel(model,colNum,target)
        subplotIndex=[0 5 10];
        gap=[.07 .015];
        width=[.06 .08];
        height=[.06 .08];
        view=ViewTwoCellFSP(model,subtightplot(3,5,subplotIndex(1)+colNum,gap,width,height));
        ax(1)=view.plotSampledSumForces(4);
        caxis([0 1000]);
        if colNum~=1
          set(gca,'xticklabel',[])
          set(gca,'yticklabel',[])
        end
        if colNum==4
          cbar1=colorbar
          cbar1.Position=[0.9246   0.6800    0.0152    0.2400]
        end
        view=ViewTwoCellFSP(model,subtightplot(3,5,subplotIndex(2)+colNum,gap,width,height));
        ax(2)=view.plotSteadyStateWithTarget(target);
        if colNum~=1
          set(gca,'xticklabel',[])
          set(gca,'yticklabel',[])
        end
        if colNum==5
          cbar2=colorbar
          cbar2.Position=[0.9246    0.3700    0.0152    0.2400];
        end
        caxis([0 .04])
        view=ViewTwoCellFSP(model,subtightplot(3,5,subplotIndex(3)+colNum,gap,width,height));
        ax(3)=view.plotMarginals();
        if colNum~=1
          set(gca,'xticklabel',[]);
          set(gca,'yticklabel',[]);
        end
        scorer=ProbabilityScore([50 50]);
        probability=ax(2).Children(2).CData;
        score=scorer.getScore(probability);
        text(31,.16,sprintf('J= %.0f',score),'FontSize',11,'FontWeight','bold');
        ylim([0,.2]);
        xlim([0 50]);
        ax(3).YGrid='on';
        hold on
        plot([30 30],[0 1],'b--');
        plot(30,0,'rp','Markersize',10,'MarkerFaceColor' ,'blue');
        plot([10 10],[0 1],'r--');
        plot(10,0,'bp','Markersize',10,'MarkerFaceColor','red');
        box on
      end
    end
    function axes=AnalsysisFSPFullModelControlPairs(obj)
    end
    function axes=AnalysisFSPReducedModels(obj)
      
    end
    function axes=AnalysisSSAFullModels(obj)
      
    end
    function axes=OptimizeControlerFullModels(obj)
      
    end
    function axes=OptimizeControlerReducedModels(obj)
      
    end
    function axes=ModelFitODE_Panel(obj)
      xBox = [0, 0, 270, 270, 0];
      yBox = [0, 30, 30, 0, 0];
      patch(xBox, yBox, 'black', 'FaceColor', 'blue', 'FaceAlpha', 0.25, 'EdgeAlpha', 0);
      set(gco, 'HandleVisibility', 'off');
      xBox = [270, 270, 570, 570, 0];
      yBox = [0, 30, 30, 0, 0];
      set(gco, 'HandleVisibility', 'off');
      patch(xBox, yBox, 'black', 'FaceColor', 'blue', 'FaceAlpha', 0.05, 'EdgeAlpha', 0);
      xBox = [570, 570, 780, 780, 0];
      yBox = [0, 30, 30, 0, 0];
      patch(xBox, yBox, 'black', 'FaceColor', 'blue', 'FaceAlpha', 0.1, 'EdgeAlpha', 0);
      set(gco, 'HandleVisibility', 'off');
    end
    function axes=ModelFitODE_UnregulatedFullModel_Trajectory(obj)
      data=obj.datalayer.get('ModelFitODE_UnregulatedFullModel');
      axes=plot(data.time,data.state(5,:),'r-.','Linewidth',3)
    end
    function axes=ModelFitODE_UnregulatedReducedModel_Trajectory(obj)
      data=obj.datalayer.get('ModelFitODE_UnregulatedReducedModel')
      axes=plot(data.time,data.state,'b-','Linewidth',3)
      
    end
    function axes=ModelFitODE_ExperimentalData_Trajectory(obj)
      data=obj.datalayer.get('ModelFitODE_ExperimentalData')
      axes=plot(data.time,data.state/max(data.state)*20,'k.','MarkerSize',24)
    end
    function axes=ModelFitSSA_UnregulatedReducedModel_Low_Histogram(obj)
      data=obj.datalayer.get('ModelFitSSA_UnregulatedReducedModel_Low')
      axes=histogram(data.state,[0:60],'normalization','Probability', 'EdgeAlpha', 0);
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
      X=[80 130]
      xBox = [0, 0, X(1), X(1), 0];
      yBox = [0, 30, 30, 0, 0];
      patch(xBox, yBox, 'black', 'FaceColor', 'blue', 'FaceAlpha', 0.25, 'EdgeAlpha', 0);
      set(gco, 'HandleVisibility', 'off');
      xBox = [X(1), X(1), X(2), X(2), 0];
      yBox = [0, 30, 30, 0, 0];
      set(gco, 'HandleVisibility', 'off');
      patch(xBox, yBox, 'black', 'FaceColor', 'blue', 'FaceAlpha', 0.05, 'EdgeAlpha', 0);
      xBox = [X(2), X(2), 1000, 1000, 0];
      yBox = [0, 30, 30, 0, 0];
      patch(xBox, yBox, 'black', 'FaceColor', 'blue', 'FaceAlpha', 0.1, 'EdgeAlpha', 0);
      set(gco, 'HandleVisibility', 'off');
    end
    function axes=ModelFit_UnregulatedFullModel_Histogram(obj)
      
    end
    function axes=ModelFit_UnregulatedReducedModel_Trajectorys(obj)
      
    end
    function axes=ModelFit_UnregulatedReducedModel_Histogram(obj)
      
    end
    function axes=AnalysisODEHysteresis_ReducedModelAutoregulated(obj)
      data=obj.datalayer.get('AnalysisODEHysteresis_ReducedModelAutoregulated');
      hold on
      plot(data.range,data.upTrajectory);
      plot(data.range,data.downTrajectory);
    end
    function axes=AnalysisODEHysteresis_ReducedModelUnregulated(obj)
      data=obj.datalayer.get('AnalysisODEHysteresis_ReducedModelUnregulated');
      hold on
      plot(data.range,data.upTrajectory);
      plot(data.range,data.downTrajectory);
    end
    function axes=AnalysisODEFrequency_ReducedModels_Input(obj)
      data=obj.datalayer.get('AnalysisODEFrequency_ReducedModels_Input');
      axes=plot(data.time,data.input)
    end
    function axes=AnalysisODEFrequency_ReducedModels_Bound(obj)
      data=obj.datalayer.get('AnalysisODEFrequency_ReducedModels_Input');
      axes=plot(data.time,data.upperbound)
      axes=plot(data.time,data.lowerbound)
    end
    function axes=AnalysisODEFrequencySeparation_ReducedModel(obj)
      data=obj.datalayer.get('AnalysisODEFrequencySeparation_ReducedModels');
      range1=linspace(0,2,201);
      range2=linspace(0,2,2001);
      hold on
      axes=plot(range1,data.trajectory_LIC_w0p01.state((end-200):end));
      axes=plot(range1,data.trajectory_HIC_w0p01.state((end-200):end));
      axes=plot(range2,data.trajectory_LIC_w0p0001.state((end-2000):end));
      axes=plot(range2,data.trajectory_HIC_w0p0001.state((end-2000):end));
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
    function axes=AnalysisSSAFSPPredictiveModelControl_Trajectory(obj)
      data=obj.datalayer.AnalysisSSAFSPPredictiveModelControl()
      hold on
      plot(data.time,data.X)
      plot(data.time,data.Y)
      plot(data.time,data.predictionY(1:length(data.time)))
      hold off
      axes=gca;
    end
    function axes=AnalysisSSAFSPPredictiveModelControl_JointProbability(obj)
      data=obj.datalayer.AnalysisSSAFSPPredictiveModelControl()
      pcolorProbability(data.Pxy)
      xlabel('Species Count Non-Target')
      ylabel('Species Count Target')
      LabelPlot(num2str(data.score))
      axes=gca;
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
  end
end