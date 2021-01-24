function p=pcolorProbability(probability)
  probSize=size(probability);
  xVec=(0:(probSize(1)-1))-.5;
  yVec=(0:(probSize(2)-1))-.5;
  [X,Y]=meshgrid(xVec,yVec);
  p=pcolor(X,Y,probability);
  p.EdgeAlpha=0;
end