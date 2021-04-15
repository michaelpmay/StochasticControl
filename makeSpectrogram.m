addpath(genpath('utility'))
layer=DataLayer;
cMin=-60
cMax=0
data=layer.get('AnalysisSSATwoCellFullModel')
figure
subplot(1,2,1)
s1=spectrogram(data.U,2000)
caxis([cMin cMax])

data=layer.get('AnalysisSSATwoCellReducedModel')
subplot(1,2,2)
s2=spectrogram(data.U,2000)
caxis([cMin cMax])