classdef DynamicControlOptimizer
  properties
    modelFsp
    time=linspace(0,10,10)
    uRange=linspace(0,1,10);
    score
  end
  properties (Hidden)
    
  end
  methods
    function obj=DynamicControlOptimizer(model)
      obj.modelFsp=model;
      obj.score=ProbabilityScore(model);
    end
    function optimize(obj)    
      for i=1:length(obj.time)
        sample=obj.sampleProbability(1);
        [u,minModel]=obj.getDynamicU(sample);
        
      end
    end
    function controlInput=getControlInput(obj)
      controlInput=obj.modelFsp.controlInput
    end
    function plotSamples(obj,numSamples)
      sampleVec=obj.sampleProbability(numSamples);
      pcolorProbability(obj.getSteadyState);
      hold on
      for i=1:size(sampleVec,1)
        plot(sampleVec(i,1),sampleVec(i,2),'ro');
      end
      hold off
    end
    function sample=sampleProbability(obj,numSamples)
      steadyStateProbability=obj.modelFsp.getSteadyState();
      indecies=probabilitySampleFrom(steadyStateProbability(:),numSamples);
      sample=obj.mapToXYIndex(indecies)
    end
    function sample=mapToXYIndex(obj,index)
      [xMap,yMap]=obj.getElementMap();
      for i=1:length(index)
        sample(i,:)=[xMap(index(i))-1,yMap(index(i))-1];
      end
    end
    function [XVec,YVec]=getElementMap(obj)
      xVec=1:obj.modelFsp.dims(1);
      yVec=1:obj.modelFsp.dims(2);
      [Y,X]=meshgrid(xVec,yVec);
      XVec=X(:);
      YVec=Y(:);
    end
    function [u,minModel]=getDynamicU(obj,Q)
      n=length(obj.uRange)      
      for i=1:n
        tempModel(i)=obj.modelFsp;
        tempModel(i).controlInput(Q+1)=tempModel(i).controlInput(Q+1)+obj.uRange(i)
        dynamicScore(i)=obj.getDyanamicScore(tempModel(i))
      end
      [minScore,minIndex]=min(dynamicScore)
      u=obj.uRange(minIndex);
      minModel=tempModel(minIndex);
    end
    function score=getDyanamicScore(obj,modelfsp)
      infGenerator=modelfsp.generator.getInfGenerator(modelfsp.controlInput);
      probability=modelfsp.getSteadyState();
      score=obj.score.getDynamicScore(probability,infGenerator);
    end
    function steadyStateProbability=getSteadyState(obj)
      steadyStateProbability=obj.modelFsp.getSteadyState();
    end
  end
end