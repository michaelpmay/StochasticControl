load workspaceZTrajectoriesBeta.mat
trajectory=preprocess(scoreTrajectory);
zMat=matrify(trajectory);
zMatT=trim(zMat,2000);
meanTrajectory=getMean(zMatT);
histify(zMatT);
[minMean,minInd]=min(meanTrajectory);
figure
subplot(1,3,3)
histogram(zMatT(:,minInd,:),[0:10:2000]-.5,'normalization','probability')
subplot(1,3,2)
hold on
for i=1:40
  plot(.1:.1:500,trajectory{i,minInd})
end
function cleanTrajectory=preprocess(trajectory)
for k=1:size(trajectory,2)
cleanTrajectory(:,k)=trajectory((1:40)+40*(k-1),k);
end
end
function mat=matrify(trajectory)
for i=1:size(trajectory,1)
  for k=1:size(trajectory,2);
    mat(i,k,:)=trajectory{i,k};
  end
end
end
function mat=trim(mat,element)
  mat=mat(:,:,element:end);
end
function meanTrajectory=getMean(mat)
for i=1:size(mat,1)
  for k=1:size(mat,2)
    meanTrajectory(i,k)=mean(mat(i,k,:));
  end
end
meanTrajectory=mean(meanTrajectory,1);
end
function histify(mat)
figure 
hold on 
for k=1:size(mat,2)
    h{k}=histogram(mat(:,k,:),[0:10:2000]-.5,'normalization','probability');
end
end
