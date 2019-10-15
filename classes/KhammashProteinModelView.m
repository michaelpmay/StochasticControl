classdef KhammashProteinModelView
  properties
    axes
    onSubView
    offSubView
    light=[0 .1];
    nbins=50;
    time=linspace(0,5000000,5000000)
  end
  methods
    function obj=KhammashProteinModelView(axes)
      obj.axes=axes;
      obj.onSubView=obj.buildSubView(obj.light(1));
      obj.offSubView=obj.buildSubView(obj.light(2));
      obj.setTime(obj.time);
    end
    function view=buildSubView(obj,intensity)
      build=ModelFactory;
      model=build.unregulatedModelWithUniformLight(intensity);
      solver=SolverSSA(model);
      view=ProteinSubView(solver,obj.axes);
      view.nbins=obj.nbins;
    end
    function obj=setNBins(obj,nbins)
      obj.nbins=nbins;
      obj.onSubView.nbins=nbins;
      obj.offSubView.nbins=nbins;
    end
    function obj=setTime(obj,time)
      obj.time=time;
      obj.onSubView.time=time;
      obj.offSubView.time=time;
    end
    function plotOnOffBiExpIntensityHistogram(obj,mu,sig,del,bkg)
      hold on
      obj.onSubView.plotBiExponentialIntensityHistogram('r-',mu,sig,del,bkg);
      obj.offSubView.plotBiExponentialIntensityHistogram('b-',mu,sig,del,bkg);
      hold off
      axis([-1 6 0 1]);
    end
    function plotProteinHistogram(obj)
      hold on
      obj.onSubView.plotProteinHistogram()
      obj.offSubView.plotProteinHistogram()
      hold off
    end
  end
end