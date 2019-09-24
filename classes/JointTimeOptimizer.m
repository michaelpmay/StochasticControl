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
  end
  methods
    function obj=JointTimeOptimizer()
      
    end
    function [analysis]=analyze(obj,model)
      for i=1:length(obj.deltaTRange)
        analysis{i}=obj.optimizeForFixedDeltaT(model,obj.deltaTRange(i))
      end
    end
    function analysis=parallelAnalyze(obj,model)
      menu=ParallelMenu;
      for i=1:length(obj.deltaTRange)
        menu=menu.attachTicketItem(@obj.optimizeForFixedDeltaT,{model,obj.deltaTRange(i)})
      end
      analysis=menu.run;
    end
    function [analysis]=optimizeForFixedDeltaT(obj,model,deltaT)
      [obj,ssa,~,singularFsp]=obj.initializeLoopVariables(model,deltaT);
      jointProbability=obj.getInitialProbability();
      singleProbability{1}=jointProbability(obj.initialState(1)+1,:)';
      time=obj.time(1):deltaT:obj.time(end);
      N=length(time)-1;
      for i=1:N
        printLoopIterations(i,N);
        model(i).time=[time(i) time(i+1)];
        [model(i).controlInput,u(i),dynamicScore(i)]=obj.getDynamicUControler(model(i),jointProbability,deltaT);
        
        if i==1
          model(i).initialState=obj.initialState(1);
        else
          model(i).initialState=ssaData(i-1).node{1}.state(1,end);
        end
        ssa.model=model(i);
        ssa.model.parameters(6)=u(i);
        ssaData(i)=ssa.run;
        singularFsp.model=model(i);
        singularFsp.model.initialState=singleProbability{end};
        singularFsp.model.parameters(6)=u(i);
        singularFspData(i)=singularFsp.run();
        singleProbability{i+1}=singularFspData(i).state(:,end);
        %probabilityRow=fspData(i).state();
        jointProbability=obj.getJointDistribution(ssaData(i).node{1}.state(end),singleProbability{i+1}(:,end));
        model(i+1)=model(i);
        score(i)= obj.score.getScore(jointProbability);
      end
      [targetData]=obj.parseSsaData(ssaData,time);
      [nonTargetData]=obj.parseFspData(singularFspData,time);
      analysis.targetData=targetData;
      analysis.nonTargetData=nonTargetData;
      analysis.time=time;
      analysis.u=u;
      analysis.dynamicScore=dynamicScore;
      analysis.score=score;
    end
    function optimizeForFixedDeltaTFast(obj)
      [obj,ssa,jointFsp,singularFsp]=obj.initializeLoopVariables(model);
      singularFsp=IterableFsp();
      singularFsp.state=obj.getInitialProbability;
      sProbability=singularFsp.initialState;
      jointProbability=obj.getJointDistribution(obj.initialState(1),sProbability)
      obj=obj.updateStateGenerators(modelFsp,deltaT);
      time=obj.time(1):deltaT:obj.time(end);
      maxTimeIndex=length(time);
      for i=1:maxTimeIndex-1
        infGenerator=obj.getBestInfGenerator(jointProbability,deltaT);
        singularFsp=singularFsp.iterateStep(infGenerator,deltaT);
        sProbability=singularFsp.getLastState();
        jointProbability=obj.getJointDistribution(obj.initialState(1),sProbability);%todo
      end
    end
    function [obj,ssa,jointFsp,singularFsp]=initializeLoopVariables(obj,model,deltaT)
      ssa=SolverSSA(model);
      jointFsp=TwoCellFSP(model,obj.dims);
      singularFsp=obj.initilize1DFSP(model);
      obj.score=ProbabilityScore(obj);
      obj=obj.updateStateGenerators(jointFsp,deltaT);
    end
    function fsp=initilize1DFSP(obj,model)
      fsp=SolverFSP;
      fsp.model=model;
      fsp.generator=FSPGenerator1D;
      fsp.generator.dims=[obj.dims(2)];
      fsp.model.initialState=zeros(obj.dims(2),1);
      fsp.model.initialState(obj.initialState(2)+1)=1;
    end
    
    function bestInfGen=getBestInfGenerator(obj,probability,deltaT)
      for i=1:length(obj.uRange)
        dynamicScore(i)=obj.score.getDynamicScore(probability,obj.stateGenerators{i});
      end
      [~,minIndex]=min(dynamicScore);
      bestInfGen=obj.stateGenerators(minIndex);
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
          tempModelFsp.model.controlInput=ones(obj.dims)*obj.uRange(i);
          infGenerator=tempModelFsp.getInfGenerator();
          obj.stateGenerators{i}=expm(infGenerator*deltaT);
        end
      end
    end
    
    function score=getDyanamicScore(obj,probability,stateGenerator,deltaT)
      score=obj.score.getDynamicScore(probability,stateGenerator,deltaT);
    end
    
    function ssaData=stepSsaToNewTime(obj,ssa,model,time,lightInput)
      ssa.model=model;
      ssa.model.time=time;
      ssa.model.parameters(6)=lightInput;
      ssaData=ssa.run;
    end
    
    function model=setInput(obj,model,inputValue)
      model.controlInput=ones(obj.dims)*inputValue;
    end
    
    function data=parseSsaData(obj,data,time)
      state(1)=data(1).node{1}.state(1);
      for i=1:size(data,2)
        state(end+1)=data(i).node{1}.state(end);
      end
      data=SSAData();
      data.node{1}.state=state;
      data.node{1}.time=time;
    end
    function data=parseFspData(obj,data,time)
      probability=obj.getInitialProbability;
      state(:,2)=data(1).state(:,1);
      for i=1:length(data)
        state(:,end+1)=data(i).state(:,end);
      end
      data=GenericCMEData;
      data.state=state;
      data.time=time;
    end
    function obj=initializeModelSsa(obj,model)
      obj.modelSsa=SolverSSA(model);
      obj.modelSsa.model.initialState=obj.initialState(1);
      obj.modelSsa.model.time=[obj.time(1),obj.time(2)];
    end
    function obj=initializeModelFsp(obj,model)
      obj.modelFsp=TwoCellFSP(model);
      obj.score=ProbabilityScore(obj);
      obj.modelFsp.model.time=[obj.time(1),obj.time(2)];
      obj.modelFsp.model.controlInput=ones(obj.dims)*obj.initialLight;
      obj.modelFsp.generator=TwoCellFSPGenerator(model);
    end
    function probability=getJointDistribution(obj,xState,yProbability)
      probability=zeros(obj.dims);
      probability(xState+1,:)=yProbability;
    end
    function infGen=getInfGenerator(obj,modelFsp)
      infGen=modelFsp.generator.getInfGenerator(modelFsp.model);
    end
  end
end
