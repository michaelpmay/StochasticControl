classdef FlowField
  methods
    function [xVector,yVector]=getSampleSpace(obj,fsp,stepSize)
      xVector=0:stepSize:(fsp.dims(1)-1);
      yVector=0:stepSize:(fsp.dims(2)-1);
    end
    function sumForce=getForceEquation(obj,fsp)
      %first solver is the two Cell solver, second solver is the parameters to generate a two cell solver
      Hill=@(x)fsp.generator.getProductionRate(x);
      Gamma=@(x)fsp.generator.getDegredationRate(x);
      sumForce=@(x,y)[Hill(x)-Gamma(x)+fsp.model.controlInput(x+1,y+1);
        Hill(y)-Gamma(y)+fsp.model.controlInput(x+1,y+1)];
    end
    function [xForce,yForce]=getSampleSpaceForces(obj,fsp,stepSize)
      [sampledXVector,sampledYVector]=obj.getSampleSpace(fsp,stepSize);
      sumF=obj.getForceEquation(fsp);
      Force=zeros(length(sampledXVector),length(sampledYVector),2);
      for i=1:length(sampledXVector)
        for j=1:length(sampledYVector)
          Force(i,j,:)=sumF(sampledXVector(i),sampledYVector(j));
          Force(i,j,:)=Force(i,j,:)./norm(squeeze(Force(i,j,:)),2);
        end
      end
      xForce=squeeze(Force(:,:,1));
      yForce=squeeze(Force(:,:,2));
    end
  end
end