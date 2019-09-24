function analysis=loadAnalysis()
load dynamicScore.mat
load score.mat
load time.mat
load targetData.mat
load nonTargetData.mat
load u.mat
for i=1:length(time)
analysis{i}.time=time{i};
analysis{i}.u=u{i};
analysis{i}.score=score{i}
analysis{i}.dynamicScore=dynamicScore{i};
analysis{i}.targetData.node{1}.state=targetData{i};
analysis{i}.nonTargetData.state=nonTargetData{i};
end
analysis
