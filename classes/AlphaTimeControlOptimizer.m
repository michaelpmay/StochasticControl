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
    rate=1;
    initialState
  end
  properties(Hidden)
    iterableFsp=IterableFsp;
  end
  methods
    function obj=AlphaTimeControlOptimizer(modelFsp)
      obj.modelFsp=modelFsp;
      obj.score=ProbabilityScore(obj.modelFsp);
      obj.generator=TwoCellFSPGenerator(obj.modelFsp.model,obj.dims);
      obj.time=linspace(1,10,100);
      obj.initialControler=ones(obj.dims)*.3;
      obj.initialState=zeros(obj.dims);
      obj.initialState(10,10)=1;
      obj.minBounds=0;
      obj.maxBounds=10;
      obj.iterableFsp.state=obj.initialState(:);
    end
    function modelFsp=getOptimumModelFsp(obj)
      build=ModelFactory;
      modelFsp=build.optimizedTwoCellModel;
    end
    function optimize(obj)
      modelFsp=obj.modelFsp;
      modelFsp.model.controlInput=obj.initialControler;
      model=modelFsp.model;
      control=obj.initialControler;
      probability=modelFsp.getSteadyState;
      deltaT=obj.time(2)-obj.time(1);
      rate=obj.rate;
      alpha=.5;
      for i=1:length(obj.time)
        model=obj.stepToNewControler(model,control,probability,rate,alpha);
        obj=obj.stepToNewTime(model,deltaT);
        control=model.controlInput;%updateControler
        probability=obj.iterableFsp.getLastState;%updatePRobability 
        alpha=alpha/1.1    
        rate=rate/1.01;
        subplot(1,2,1)
        pcolorProbability(control);
        colorbar();
        subplot(1,2,2)
        pcolorProbability(reshape(probability,obj.dims));        
        colorbar();
        drawnow();
        pause(.1);
      end
    end
    function controlInput=getOptimalControler(obj)
      file=load('inFiles/controlInput.mat');
      controlInput=file.controlInput;
    end
    function model=stepToNewControler(obj,model,probability,ssControler,stepRate,alpha)
      gGrad=obj.getGreedyGrad(model,probability);
      sGrad=obj.getSteadyStateGrad(model);
      grad=obj.mixGrad(gGrad,sGrad,alpha);
      newControlInput=model.controlInput-grad*stepRate;
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