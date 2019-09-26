function saveAnalysis(analysis)
  for i=1:length(analysis)
    time{i}=analysis{i}.time;
    targetData{i}.node{1}.state=analysis{i}.targetData.node{1}.state;
    nonTargetData{i}.state=analysis{i}.nonTargetData;
    u{i}=analysis{i}.u;
    score{i}=analysis{i}.score;
    dynamicScore{i}=analysis{i}.dynamicScore;
  end
  save('time.mat','time')
  save('targetData.mat','targetData')
  save('nonTargetData.mat','nonTargetData')
  save('u.mat','u')
  save('score.mat','score')
  save('dynamicScore.mat','dynamicScore')
end
