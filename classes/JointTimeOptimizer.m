classdef JointTimeOptimizer
  properties
    modelSsa
    modelFsp
    score
    uRange=[-.005 -.001 0 .001 .005];
    initialState=[30 30]
    time=linspace(0,10,100);
    initialU
    dims=[50 50]
    initialLight=.3
  end
  properties(Hidden)
    generator
  end
  methods
    function obj=JointTimeOptimizer()
      
    end
    function [targetData,nonTargetData,u]=optimize(obj,model)
      ssa=SolverSSA(model);
      fsp=TwoCellFSP(model);
      singularFsp=SolverFSP();
      singularFsp.model=model;
      singularFsp.generator=FSPGenerator1D;
      singularFsp.generator.dims=[obj.dims(2)];
      singularFsp.model.initialState=zeros(obj.dims(2),1);
      singularFsp.model.initialState(obj.initialState(2)+1)=1;
      singleProbability{1}=singularFsp.model.initialState;
      jointProbability=obj.getInitialProbability;
      obj.score=ProbabilityScore(model);
      N=length(obj.time)-1;
      for i=1:N
        fprintf(['\n iteration: ',num2str(i),'/',num2str(N),'\n'])
        model(i).time=[obj.time(i) obj.time(i+1)];
        [model(i).controlInput,u(i)]=obj.getDynamicUControler(model(i),jointProbability);
        u
        if i==1
          model(i).initialState=obj.initialState(1);
        else
          model(i).initialState=ssaData(i-1).node{1}.state(1,end);
        end
        ssa.model=model(i);
        ssa.model.parameters(6)=u(i);
        ssaData(i)=ssa.run;
        
        %fsp.model=model(i);
        %fspData(i)=fsp.run;
        singularFsp.model=model(i);
        singularFsp.model.initialState=singleProbability{end};
        singularFsp.model.parameters(6)=u(i);
        singularFspData(i)=singularFsp.run();
        singleProbability{i+1}=singularFspData(i).state(:,end);
        %probabilityRow=fspData(i).state();
        jointProbability=zeros(obj.dims);
        jointProbability(ssaData(i).node{1}.state(end)+1,:)=[singleProbability{i+1}(:,end)];
        model(i+1)=model(i);
        pcolorProbability(jointProbability);
        drawnow();
        pause(.1)
      end
      [targetData]=obj.parseSsaData(ssaData);
      [nonTargetData]=obj.parseFspData(singularFspData);
    end
    function probability=getInitialProbability(obj)
      probability=zeros(obj.dims);
      probability(obj.initialState(1)+1,obj.initialState(2)+1)=1;
    end
    function [controler,u]=getDynamicUControler(obj,model,probability)
      [u,model]=obj.getDynamicU(model,probability(:));
      controler=ones(obj.dims)*u;
    end
    function [u,minModel]=getDynamicU(obj,model,probability)
      n=length(obj.uRange);
      modelFsp=TwoCellFSP(model);
      for i=1:length(obj.uRange)
        tempModel(i)=modelFsp;
        newInput=model.controlInput+obj.uRange(i);
        newInput(newInput<0)=0;
        tempModel(i).model.controlInput=newInput;
        dynamicScore(i)=obj.getDyanamicScore(tempModel(i),probability);
      end
      [~,minIndex]=min(dynamicScore);
      u=newInput(1,1);
      minModel=tempModel(minIndex).model;
    end
    function score=getDyanamicScore(obj,modelfsp,probability)
      infGenerator=obj.getInfGenerator(modelfsp);
      score=obj.score.getDynamicScore(probability,infGenerator);
    end
    function data=parseSsaData(obj,data)
      state(1)=data(1).node{1}.state(1);
      for i=1:size(data,2)
        state(end+1)=data(i).node{1}.state(end);
      end
      data=SSAData();
      data.node{1}.state=state;
      data.node{1}.time=obj.time;
    end
    function data=parseFspData(obj,data)
      probability=obj.getInitialProbability;
      state(:,2)=data(1).state(:,1);
      for i=1:length(data)
        state(:,end+1)=data(i).state(:,end);
      end
      data=GenericCMEData;
      data.state=state;
      data.time=obj.time;
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
    function probability=getJointDistribution(obj,yState,xProbability)
      probability=zeros(obj.modelFsp.dims);
      probability(yState,:)=xProbability;
    end
    function infGen=getInfGenerator(obj,modelFsp)
      infGen=modelFsp.generator.getInfGenerator(modelFsp.model);
    end
  end
end