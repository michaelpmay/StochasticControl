function rateEq=hill(x,ko,be,mu,ka)
  rateEq=ko*x.^(mu)./(x.^mu+be^mu)+ka;
end