%loadAnalysis
load dynamicScore.mat
load score.mat
load time.mat
load targetData.mat
load nonTargetData.mat
load u.mat
for i=1:length(time)
analysis{i}.time=time;
analysis{i}.u=u;
analysis{i}.score=score;
analysis{i}.dynamicScore=dynamicScore;
analysis{i}.targetData=targetData;
analysis{i}.nonTargetData=nonTargetData;
end