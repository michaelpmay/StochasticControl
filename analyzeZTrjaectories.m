load workspaceZTrajectories.mat
zMat=matrify(scoreTrajectory);
zMat=trim(zMat,2000);
meanTrajectory=getMean(zMat);
figure
histogram(zMat(:),[0:10:2000]-.5,'normalization','probability')
function mat=matrify(trajectory)
for i=1:size(trajectory,2)
  mat(i,:)=trajectory{i};
end
end
function mat=trim(mat,element)
  mat=mat(:,element:end);
end
function meanTrajectory=getMean(mat)
  meanTrajectory=mean(mean(mat));
end

