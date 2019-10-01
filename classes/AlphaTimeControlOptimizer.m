classdef AlphaTimeControlOptimizer
  properties
    modelFsp
    score
    generator
    initialControler
    minBounds=1
    maxBounds=0
    dims=[50 50]
    time
    rate=2;
    alpha=.01;
    rDegredation=.90;
    aDegredation=.3;
  end
  properties(Hidden)
    iterableFsp=IterableFsp;
  end
  methods
    function obj=AlphaTimeControlOptimizer(modelFsp)
      obj.modelFsp=modelFsp;
      obj.score=ProbabilityScore(obj.modelFsp);
      obj.generator=TwoCellFSPGenerator(obj.modelFsp.model,obj.dims);
      obj.time=modelFsp.model.time;
      obj.initialControler=modelFsp.model.controlInput;
      obj.minBounds=0;
      obj.maxBounds=10;
      obj.iterableFsp.state=modelFsp.getSteadyState;
    end
    function modelFsp=getOptimumModelFsp(obj)
      build=ModelFactory;
      modelFsp=build.optimizedTwoCellModel;
    end
    function [probability,control]=optimize(obj)
      modelFsp=obj.modelFsp;
      modelFsp.model.controlInput=obj.initialControler;
      model=modelFsp.model;
      control{1}=obj.initialControler;
      probability{1}=modelFsp.getSteadyState;
      deltaT=obj.time(2)-obj.time(1);
      rate=obj.rate;
      alpha=.5;
      N=length(obj.time);
      for i=1:N
        printLoopIterations(i,N);
        model=obj.stepToNewControler(model,control{i},probability{i},rate,alpha,deltaT);
        obj=obj.stepToNewTime(model,deltaT);
        control{i+1}=model.controlInput;%updateControler
        probability{i+1}=obj.iterableFsp.getLastState;%updateProbability 
        alpha=alpha*obj.aDegredation;    
        rate=rate*obj.rDegredation;
      end
    end
    function controlInput=getOptimalControler(obj)
      file=load('inFiles/controlInput.mat');
      controlInput=file.controlInput;
    end
    function model=stepToNewControler(obj,model,probability,ssControler,stepRate,alpha,deltaT)
      gGrad=obj.getGreedyGrad(model,probability);
      sGrad=obj.getSteadyStateGrad(model);
      grad=obj.mixGrad(gGrad,sGrad,alpha);
      newControlInput=model.controlInput-grad*stepRate*deltaT;
      model.controlInput=obj.trimInput(newControlInput);
    end
    function grad=getGreedyGrad(obj,model,probability)
      %A=obj.generator.getInfGenerator(model);
      B=obj.generator.getBMatrix;
      grad=obj.score.C(:)'*(B.*probability(:)');
      grad=reshape(grad,obj.dims);
      %grad=obj.trimInput(grad);
    end
    function grad=getSteadyStateGrad(obj,model)
      grad=model.controlInput-obj.getOptimalControler;
    end
    function grad=trimInput(obj,grad)
      grad(grad<obj.minBounds)=obj.minBounds;
      grad(grad>obj.maxBounds)=obj.maxBounds;
    end
    function grad=mixGrad(obj,grad1,grad2,alpha)
      grad=alpha*grad1+(1-alpha)*grad2;
    end
    function obj=stepToNewTime(obj,model,timeStep)
      modelFsp=TwoCellFSP(model,obj.dims);
      infGenerator=modelFsp.getInfGenerator;
      stateGenerator=expm(infGenerator*timeStep);
      obj.iterableFsp=obj.iterableFsp.iterateStep(stateGenerator,timeStep);
    end
  end
end