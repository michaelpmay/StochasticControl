addpath(genpath('utility'))
datalayer=DataLayer();
datalayer.forceAnalysis=true;
datalayer.TestFile()
% 
% data=datalayer.ModelFit_UnregulatedReducedModel  %good
% data=datalayer.ModelFit_UnregulatedFullModel %good 
% data=datalayer.ModelFitODE_UnregulatedReducedModel
% data=datalayer.ModelFitODE_UnregulatedFullModel
% data=datalayer.ModelFitSSA_UnregulatedReducedModel
% data=datalayer.ModelFitSSA_UnregulatedFullModel
% data=datalayer.OptimizeControlerFullModels %maybe not important
% data=datalayer.OptimizeControlerReducedModels %good

% data=datalayer.AnalysisODEFrequencySeparation_ReducedModels() %good
% data=datalayer.AnalysisODEFrequencySeparation_FullModels() %good
% data=datalayer.AnalysisODEFrequencyOmegaCrit_ReducedModel %good
% data=datalayer.AnalysisSSAFrequency_ReducedModel %good

% data=datalayer.CalibrationCurve_UnregulatedFullReduced() %good
% data=datalayer.AnalysisFSPReducedModelControlPairs() %good
% data=datalayer.AnalysisFSPFullModelControlPairs() %good

% data=datalayer.AnalsysisFSPReducedModelControlPairs %good
% data=datalayer.AnalysisSSAFullModelControlPairs %good

% data=datalayer.OptimizeControlerFullModels %maybe not important
% data=datalayer.OptimizeControlerReducedModels %good

 data=datalayer.AnalysisODEHysteresis_ReducedModelsFullModels

% data=datalayer.AnalysisTwoCellSwap_ReducedModel
% data=datalayer.AnalysisFourCellSwap_FullModel
% data=datalayer.ControlInputs_FullModels %good
% data=datalayer.ControlInputs_ReducedModels %good


% data=datalayer.AnalysisFitReducedModel

% data=datalayer.AnalysisSSATwoCellSwap_ReducedModel
%data=datalayer.AnalysisSSAFSPPredictiveModelControl