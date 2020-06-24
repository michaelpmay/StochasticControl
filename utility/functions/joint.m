function jointDist=joint(probability1,probability2)
  probability1=probability1(:);
  probability2=probability2(:);
  n=length(probability1);
  m=length(probability2);
  jointDist=preAllocateArray(n,m);
  for i=1:length(probability1)
    for j=1:length(probability2)
      jointDist(i,j)=probability1(i)*probability2(j);
    end
  end
end