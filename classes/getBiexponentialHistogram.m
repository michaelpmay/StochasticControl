function [probability,centers]=getBiexponentialHistogram(x,nbins)
  newX=biExponentialMap(x);
  [counts,centers]=hist(newX,nbins);
  probability=counts./max(counts);
end