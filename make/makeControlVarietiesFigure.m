load scoreMatForFig.mat
scoreMatTensor=[]
for i=1:7
  for j=1:6
    for k=1:50
      scoreTensor(i,j,k)=score{k}(i,j)
    end
  end
end

scoreMean=mean(scoreTensor,3)
scoreVar=var(scoreTensor,0,3)
errorBar=sqrt(scoreVar)/sqrt(50)*2
figure
hold on
for i=1:7
errorbar([1 2 4 8 16 32],fliplr(scoreMean(i,:)),fliplr(errorBar(i,:)))
end
