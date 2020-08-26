load data/workspaces/workspaceScoreMat2
%score=score.score
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
  errorbar([0 1 2 3 4 5],fliplr(scoreMatrix(i,:)),fliplr(2*meanVarReps(i,:)))
end
xt = get(gca, 'XTick');
yl = get(gca, 'YLim');
str = cellstr( num2str(xt(:),'2^{%d}') );      %# format x-ticks as 2^{xx}
hTxt = text(xt, yl(ones(size(xt))), str, ...   %# create text at same locations
    'Interpreter','tex', ...                   %# specify tex interpreter
    'VerticalAlignment','top', ...             %# v-align to be underneath
    'HorizontalAlignment','center'); 