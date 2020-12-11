% turn .fig files to high res png files
type='-dpng'
resolution='-r600'
load figures/FullModelIntro.fig
print(gcf,'figures/3by5_ReducedModels.png',type,resolution)

load figures/3by5_ReducedModels
print(gcf,'figures/3by5_ReducedModels.png',type,resolution')

load figures/3by5_FullModels.fig
print(gcf,'figures/3by5_FullModels.png',type,resolution)

load figures/HysteresisAnalysisFrequencyAnalysis_ReducedModels.fig
print(gcf,'figures/HysteresisAnalysisFrequencyAnalysis_ReducedModels.png',type,resolution)

load figures/HysteresisAnalysisFrequencyAnalysis_CalibratedModels.fig
print(gcf,'figures/HysteresisAnalysisFrequencyAnalysis_ReducedModels.png',type,resolution)