 classdef JointTimeOptimizer
  properties
    model
    score
    uRange=linspace(0,1,10)
    initialState=[30 30]
    time=[0 10]
    initialU
    dims=[50 50]
    initialLight=.3
    deltaTRange=.1:.1:5
  end
  properties(Hidden)
    generator
    stateGenerators=[]
    singularStateGenerators=[]
  end
  methods
    function obj=JointTimeOptimizer()
      
    end
    function [analysis]=analyze(obj,model)
      for i=1:length(obj.deltaTRange)
        analysis{i}=obj.optimizeForFixedDeltaT(obj.deltaTRange(i));
      end
    end
    function analysis=parallelAnalyze(obj,model)
      menu=ParallelMenu;
      for i=1:length(obj.deltaTRange)
        menu=menu.attachTicketItem(@obj.optimizeForFixedDeltaT,{obj.deltaTRange(i)});
      end
      analysis=menu.run;
    end
    function [analysis]=optimizeForFixedDeltaT(obj,deltaT)
      build=ModelFactory;
      model=build.autoregulatedModelWithUniformInput(.0);
      modelFsp=make1DModel(obj,model);
      obj=obj.updateStateGenerators(modelFsp,deltaT);
      obj.score=ProbabilityScore(obj.dims);
      xModelFsp=makeIterableFsp(obj,1);
      yModelFsp=makeIterableFsp(obj,2);
      maxTimeIndex=length(obj.time);
      for i=1:maxTimeIndex
        [index,score(i)]=obj.getBestStateGeneratorIndex(xModelFsp,yModelFsp);
        xModelFsp=xModelFsp.iterateGenerator(index,obj.time(i));
        yModelFsp=yModelFsp.iterateGenerator(index,obj.time(i));
        sample(i)=sampleFrom(xModelFsp.getLastState,1);
        xModelFsp.state(:,end+1)=zeros(obj.dims(1),1);
        xModelFsp.state(sample(i)+1,end)=1;
        xModelFsp.time(end+1)=xModelFsp.time(end);
        u(i)=obj.uRange(index);
      end
      analysis.targetState=sample;
      analysis.nonTargetState=yModelFsp.state;
      analysis.time=yModelFsp.time;
      analysis.score=score;
      analysis.u=u;
    end
    function make1DModels(obj,model)
      generators=obj.updateStateGenerators
    end
    function modelFsp=make1DModel(obj,model)
      modelFsp=SolverFSP();
      modelFsp.model=model;
      modelFsp.dims=obj.dims(1);
      modelFsp.generator=FSPGenerator1D;
    end
    function modelFsp=makeIterableFsp(obj,dimIndex)
      modelFsp=IterableFspWithGenerators;
      modelFsp.generator=obj.stateGenerators;
      modelFsp.state=zeros(obj.dims(dimIndex),1);
      modelFsp.state(obj.initialState(dimIndex)+1)=1;
    end
    function sample=sampleFrom(obj,probability)
      sample=probabilitySampleFrom(probability(:),1);
      x=0:(obj.dims(1)-1);
      y=0:(obj.dims(2)-1);
      [X,Y]=meshgrid(x,y);
      map=[X(:),Y(:)];
      sample=map(sample,:);
    end
    function fsp=initilize1DFSP(obj,model)
      fsp=SolverFSP;
      fsp.model=model;
      fsp.generator=FSPGenerator1D;
      fsp.generator.dims=[obj.dims(2)];
      fsp.model.initialState=zeros(obj.dims(2),1);
      fsp.model.initialState(obj.initialState(2)+1)=1;
    end
    function fsp=intializeIterableJointFsp(obj)
      fsp=IterableFsp;
      initialState=obj.getInitialProbability();
      fsp.state=initialState(:);
      fsp.time=[0];
    end
    function [minIndex,minScore]=getBestStateGeneratorIndex(obj,xModel,yModel)
      for i=1:length(obj.uRange)
        xProbability=xModel.testGenerator(i);
        yProbability=yModel.testGenerator(i);
        jointProbability=joint(xProbability,yProbability);
        dynamicScore(i)=obj.score.getScore(jointProbability);
      end
      [minScore,minIndex]=min(dynamicScore);
    end
    function probability=getInitialProbability(obj)
      probability=zeros(obj.dims);
      probability(obj.initialState(1)+1,obj.initialState(2)+1)=1;
    end
    
    function [controler,u,score]=getDynamicUControler(obj,model,probability,deltaT)
       [u,model,score]=obj.getDynamicU(model,probability(:),deltaT);
      controler=model.controlInput;
    end
    
    function [u,model,score]=getDynamicU(obj,model,probability,deltaT)
      n=length(obj.uRange);
      modelFsp=TwoCellFSP(model,obj.dims);
      obj=obj.updateStateGenerators(modelFsp,deltaT);
      for i=1:length(obj.uRange)
        dynamicScore(i)=obj.score.getDynamicScore(probability,obj.stateGenerators{i});
      end
      [~,minIndex]=min(dynamicScore);
      u=obj.uRange(minIndex);
      model=obj.setInput(model,u);
      score=dynamicScore(minIndex);
    end
    
    function obj=updateStateGenerators(obj,modelFsp,deltaT)
      if isempty(obj.stateGenerators)
        fprintf('Updating State Transition Matricies\n')
        for i=1:length(obj.uRange)
          tempModelFsp=modelFsp;
          tempModelFsp.model.parameters(6)=obj.uRange(i);
          infGenerator=tempModelFsp.getInfGenerator();
          obj.stateGenerators{i}=expm(infGenerator*deltaT);
        end
      end
    end
  end
end
