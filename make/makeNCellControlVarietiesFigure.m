load scoreMat_20000_500_30.mat
score=score.score
scoreArray=[]
for i=1:length(score)
  scoreArray(:,:,i)=score{i}
end
scoreMatrix=mean(scoreArray,3);
for i=1:size(scoreArray,1)
  for j=1:size(scoreArray,2)
    reps=squeeze(scoreArray(i,j,:))
    varReps(i,j)=var(reps);
  end
end

meanVarReps=sqrt(varReps)/sqrt(length(score))

figure 
hold on
for i=1:7
  errorbar([1 2 4 8 16 32],fliplr(scoreMatrix(i,:)),fliplr(2*meanVarReps(i,:)))
end