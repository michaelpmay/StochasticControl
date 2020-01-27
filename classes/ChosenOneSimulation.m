classdef ChosenOneSimulation
  properties
    time
  end
  methods
    function run(obj)
      
    end
    function Pxy=sampleX(Pxy)
      Px=sum(Pxy,1);
      Py=sum(Pxy,2);
      s=sampleFrom(Py(:),1);
      Pxy=zeros(dims);
      Pxy(s+1,:)=Px;
    end
  end
end