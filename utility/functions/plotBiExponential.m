function plotBiExponential(x,p,linespec)
  newX=biExponentialMap(x);
  plot(newX,p,linespec);
end