function randomIndex=probabilitySampleFrom(probability,numSamples)
  probability=probability(:);
  cSumProbability=cumsum([0; probability]);
  randomIndex=preAllocateVector(numSamples);
  for i=1:numSamples
    randomIndex(i)=find(cSumProbability<rand,1,'last') ;
  end
end