addpath(genpath('utility'))
viewlayer=ViewLayer();
viewlayer.datalayer.forceAnalysis=false;
viewlayer.TestFile();

% axes=viewlayer.ModelFit_FullModel_Trajectorys
axes=viewlayer.ModelFit_UnregulatedFullModel_Trajectorys
axes=viewlayer.ModelFit_UnregulatedFullModel_Histograms
% axes=viewlayer.ModelFit_ReducedModels

% axes=viewlayer.AnalysisODEFrequencySeparation_ReducedModels() 
% axes=viewlayer.AnalysisODEFrequencySeparation_FullModels() 
% axes=viewlayer.AnalysisODEFrequencyOmegaCrit_ReducedModel 
% axes=viewlayer.AnalysisSSAFrequency_ReducedModel
% 
% axes=viewlayer.CalibrationCurve_UnregulatedFullReduced() 
% axes=viewlayer.AnalysisFSPReducedModelControlPairs()%good
% axes=viewlayer.AnalsysisFSPFullModelControlPairs()
% 
% axes=viewlayer.AnalsysisFSPReducedModelControlPairs
% axes=viewlayer.AnalsysisFSPFullModelControlPairs
% axes=viewlayer.AnalysisODESSAFrequency_ReducedModel
% axes=viewlayer.AnalysisFSPReducedModels
% axes=viewlayer.AnalysisSSAFullModels
% axes=viewlayer.OptimizeControlerFullModels
% axes=viewlayer.OptimizeControlerReducedModels

% axes=viewlayer.AnalysisODEHysteresis_ReducedModels
% axes=viewlayer.AnalysisODEHysteresis_FullModels
% axes=viewlayer.AnalysisTwoCellSwap_ReducedModel
% axes=viewlayer.AnalysisFourCellSwap_FullModel
% axes=viewlayer.ControlInputs_FullModels
% axes=viewlayer.ControlInputs_ReducedlModels
% axes=viewlayer.AnalysisFitFullModel
% axes=viewlayer.ControlInputs_ReducedlModels
% axes=viewlayer.AnalysisFitFullModel
% axes=viewlayer.AnalysisFitReducedModel
axes
subplot(1,3,1)
fig1=viewlayer.AnalysisSSAFSPPredictiveModelControl_Trajectory
subplot(1,3,2)
fig2=viewlayer.AnalysisSSAFSPPredictiveModelControl_JointProbability
subplot(1,3,3)
fig3=viewlayer.AnalysisSSAFSPPredictiveModelControl_Histogram
