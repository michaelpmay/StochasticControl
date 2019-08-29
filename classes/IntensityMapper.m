classdef IntensityMapper < SSAData
  properties
    inputSignal
  end
  methods
    function obj=IntensityMapper(data)
      obj.node{1}=data.node{1};
    end
    
    function intensity=getIntensity(obj,mu,sig,del,bkg)
      state=obj.getState();
      intensity=preAllocateVector(length(state));
      for j = 1:length(intensity)
        intensity(j) = del*randn + state(j)*mu + sig*sqrt(state(j))*randn+bkg;
        %         GFPperMol(j,i) = 1*abs(randn) + J(j,i)*mu + gamrnd(J(j,i),mu);
      end
    end
    function state=getState(obj)
      state=obj.node{1}.state;
    end
  end
end