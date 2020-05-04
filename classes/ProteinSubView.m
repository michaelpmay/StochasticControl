classdef ProteinSubView
  properties
    axes
    solver
    nbins=50;
    light=[0 .1]
    time=linspace(0,50000,50000);
    trim=5000;
  end
  methods
    function obj=ProteinSubView(solver,axes)
      obj.solver=solver;
      obj.solver.model.time=obj.time;
      obj.axes=axes;
    end
    function plotOnOffBiExpIntensityHistogram(obj,mu,sig,del)
      data=obj.solver.run();
      obj.plotBiExponentialIntensityHistogram(data,'r-',mu,sig,del);
    end
    function plotProteinHistogram(obj)
      data=obj.solver.run();
      data.trimInitial(obj.trim);
      obj.plotHistogram(data)
    end
    function plotHistogram(obj,data)
      state=obj.getState(data);
      edges=0:(max(state)+1);
      histogram(state,edges-.5,'Normalization','probability');
    end
    function plotBiExponentialIntensityHistogram(obj,linespec,mu,sig,del,bkg)
      intensityData=IntensityMapper(obj.solver.run());
      intensity=intensityData.getIntensity(mu,sig,del,bkg);
      [probability,centers]=getBiexponentialHistogram(intensity,obj.nbins);
      plot(obj.axes,centers,probability,linespec);
    end
    function states=getState(obj,data)
      states=data.node{1}.state;
    end
  end
end