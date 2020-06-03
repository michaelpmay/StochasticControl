classdef ViewModelFsp
  properties
    modelFsp
    score
    axes
  end
  methods
    function obj=ViewModelFsp(modelFsp)
      obj.modelFsp=modelFsp;
      obj.score=ProbabilityScore(modelFsp.dims);
    end
    function viewSteadyState(obj)
      probability=obj.modelFsp.getSteadyStateReshape;
      pcolorProbability(probability);
    end
    function viewSteadyStateWithTarget(obj)
      hold on 
      obj.viewSteadyState;
      target=obj.score.target;
      plot(target(2),target(1),'ro')
      hold off
      [xv,yv]=obj.modelFsp.getXYV;
      ax=gca;
      ax.XLim=[xv(1) xv(end)];
      ax.YLim=[yv(1) yv(end)];
    end
    function viewSteadyStateWithTargetScore(obj)
      hold on
      obj.viewSteadyStateWithTarget;
      score=obj.score.getScore(obj.modelFsp.getSteadyState);
      textScore=text(35,45,num2str(score));
      textScore.Color=[1 1 1];
      textScore.FontWeight='bold';
      textScore.FontSize=12;
      hold off
    end
    function viewControlInput(obj)
      pcolorProbability(obj.modelFsp.model.controlInput);
    end
    function viewMarginal(obj)
      probability=obj.modelFsp.getSteadyStateReshape;
      Px=sum(probability,1);
      Py=sum(probability,2);
      Pmax=max([Px(:);Py(:)]);
      Plim=ceil(Pmax*20)/20;
      [xv,yv]=obj.modelFsp.getXYV;
      hold on
      plot(xv,Px,'b-');
      plot(yv,Py,'r-');
      hold off
      ax=gca;
      ax.YLim=[0 Plim];
    end
    function viewMarginalWithTarget(obj)
      obj.viewMarginal;
      target=obj.score.target;
      hold on
      plot([target(2),target(2)],[0 1],'b--');
      plot([target(1),target(1)],[0 1],'r--');
      hold off
    end
  end
end