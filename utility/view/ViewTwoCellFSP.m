classdef ViewTwoCellFSP
  properties 
    axes
    solver
    caxis=[0 1.75]
  end
  methods
    function obj=ViewTwoCellFSP(solver,axes)
      obj.axes=axes;
      obj.solver=solver;
    end
    function ax=plotSteadyState(obj,target)
      data=obj.solver.getSteadyStateReshape;
      [xVec,yVec]=obj.solver.generator.getXYV;
      [X,Y]=meshgrid(xVec,yVec);
      pFig=pcolor(X,Y,data);
      pFig.EdgeAlpha=0;
      axis([0,obj.solver.dims(1),0,obj.solver.dims(2)])
      cmap=hot;
      colormap(gca,cmap(20:end,:))
      ax=gca;
    end   
    function ax=plotSteadyStateWithTarget(obj,target)
      hold on 
      obj.plotSteadyState()
      blueX=scatter(target(2),target(1),30,'wo');
      blueX.MarkerEdgeColor=[1 1 1];
      blueX.LineWidth=2;
      hold off
      ax=gca;
    end   
    function ax=plotMarginals(obj)
      [xVec,yVec]=obj.solver.generator.getXYV;
      data=obj.solver.getSteadyStateReshape();
      xMarginal=sum(data,2);
      yMarginal=sum(data,1);
      hold on
      lineP1ot1=plot(obj.axes,xVec,xMarginal,'b-');
      lineP1ot1.LineWidth=3;
      linePlot2=plot(obj.axes,yVec,yMarginal,'r-.');
      linePlot2.LineWidth=3;
      hold off
      ax=gca;
    end   
    function ax=plotSampledSumForces(obj,stepSize)
       hold on
      [xForce,yForce]=obj.getSampleSpaceForces(stepSize);
      [xVector,yVector]=obj.getSampleSpace(stepSize);
      figHandle=obj.plotControlInput;
      plotQuiver=quiver(xVector,yVector,xForce,yForce,4/stepSize^2,'LineWidth',1)
      plotQuiver.Color=[1,1,1];
      xlim([0 obj.solver.dims(1)])
      ylim([0 obj.solver.dims(2)])
      hold off
      ax=gca;
    end
    
    function [xVector,yVector]=getSampleSpace(obj,stepSize)
      xVector=0:stepSize:(obj.solver.dims(1)-1);
      yVector=0:stepSize:(obj.solver.dims(2)-1);
    end
    
    function figHandle=plotControlInput(obj)
      [xv,yv]=obj.solver.generator.getXYV();
      figHandle=imagesc(xv,yv,obj.solver.model.controlInput);
      set(gca,'YDir','normal');
      axis([0,obj.solver.dims(1)-1,0,obj.solver.dims(2)-1])
    end
    
    function [xForce,yForce]=getSampleSpaceForces(obj,stepSize)
      [sampledXVector,sampledYVector]=obj.getSampleSpace(stepSize);
      sumF=obj.getForceEquation;
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
    function sumForce=getForceEquation(obj)
      %first solver is the two Cell solver, second solver is the parameters to generate a two cell solver
      Hill=@(x)obj.solver.generator.getProductionRate(x);
      Gamma=@(x)obj.solver.generator.getDegredationRate(x);
      sumForce=@(x,y)[Hill(x)-Gamma(x)+obj.solver.model.controlInput(x+1,y+1);
        Hill(y)-Gamma(y)+obj.solver.model.controlInput(x+1,y+1)];
    end
  end
end