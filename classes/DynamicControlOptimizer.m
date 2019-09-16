classdef DynamicControlOptimizer
  properties
    modelFsp
    time=linspace(0,1,10)
    uRange=linspace(0,1,11);
    score
  end
  methods
    function obj=DynamicControlOptimizer(model)
      obj.modelFsp=model;
      obj.score=ProbabilityScore(model);
    end
    function [data, minModelFsp,u,sample]=optimize(obj)
      warning('off');
      minModelFsp(1)=obj.modelFsp;
      minModelFsp(1).model.time=[obj.time(1) obj.time(2)];
      probability=obj.getSteadyState;
      minModelFsp(1).model.initialState=obj.getInitialState(probability);
      data(1)=minModelFsp(1).run();
      u(1)=0;
      N=length(obj.time);
      for i=2:(length(obj.time)-1)
        fprintf(['iteration: ',num2str(i-1),'/',num2str(N-1),'\n'])
        sample=obj.sampleProbability(data(i-1).state(:,end),1);
        [u(i),minModelFsp(i)]=obj.getDynamicU(sample);
        minModelFsp(i).model.time=linspace(obj.time(i),obj.time(i+1), 5);
        minModelFsp(i).model.initialState=obj.getInitialState(data(i-1).state(:,end));
        data(i)=minModelFsp(i).run;
      end
      data=obj.parseData(data);
    end
    function u=globalOptimize(obj,minProb)
      probability=obj.getSteadyState;
      u=nan(obj.modelFsp.dims(1),obj.modelFsp.dims(2));
      numElementsString=num2str(sum(sum(probability>minProb)));
      index=0;
      for i=1:obj.modelFsp.dims(1)
        for j=1:obj.modelFsp.dims(2)   
          if probability(i,j)>minProb
            index=index+1;
            fprintf(['iteration: ',num2str(index),'/',numElementsString,'\n']);
            sample=getInitialState(obj,probability);
            [u(i,j),minModelFsp]=obj.getDynamicU(sample);
          end
        end
      end
    end
    function iterativeGlobalOptimize(obj,fileName,stepReps,numReps)
      probability=obj.getSteadyState;
      [sortProb,index]=sort(probability(:),'descend');
      [xMap,yMap]=obj.getElementMap;
      u=nan(obj.modelFsp.dims);
      n=length(index);
      ind=1;
      for j=1:numReps
        menu=ParallelMenu;
        for i=1:stepReps
        x=xMap(index(ind));
        y=yMap(index(ind));
        menu=menu.attachTicketItem(@obj.calculateSingleU,{probability,x,y});
        ind=ind+1;
        end
        output=menu.run();
        for i=1:stepReps
          x=menu.ticketItems{i}.input{2};
          y=menu.ticketItems{i}.input{3};
          u(x,y)=output{i};
        end
        save(fileName,'u')
      end
    end
    function u=calculateSingleU(obj,probability,xIndex,yIndex)
      sample=obj.getInitialState(probability(xIndex,yIndex));
      [u,~]=obj.getDynamicU(sample);
    end
    function initialState=getDeltaDist(obj,i,j)
      initialState=zeros(obj.modelFsp.dims);
      initialState(i,j)=1;
    end
    function initialState=getInitialState(obj,probability)
      initialState=zeros(obj.modelFsp.dims);
      sample=obj.sampleProbability(probability,1);
      initialState(sample(1)+1,sample(2)+1)=1;
      initialState=initialState(:);
    end
    function data=parseData(obj,data)
      time(1)=data(1).time(1);
      state(:,1)=data(1).state(:,1);
      for i=1:length(data)
        n=length(data(i).time(2:end));
        for j=1:n
          time(end+1)=data(i).time(j+1);
          state(:,end+1)=data(i).state(:,j+1);
        end
      end
      data=GenericCMEData(time,state);
    end
    function controlInput=getControlInput(obj)
      controlInput=obj.modelFsp.controlInput;
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
    function sample=sampleSteadyStateProbability(obj,modelFsp,numSamples)
      steadyStateProbability=modelFsp.getSteadyState();
      indecies=probabilitySampleFrom(steadyStateProbability(:),numSamples);
      sample=obj.mapToXYIndex(indecies);
    end
    function sample=sampleProbability(obj,probability,numSamples)
      indecies=probabilitySampleFrom(probability(:),numSamples);
      sample=obj.mapToXYIndex(indecies);
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
      n=length(obj.uRange);
      for i=1:n
        tempModel(i)=obj.modelFsp;
        tempModel(i).model.controlInput(Q+1)=tempModel(i).model.controlInput(Q+1)+obj.uRange(i);
        dynamicScore(i)=obj.getDyanamicScore(tempModel(i),obj.deltaDistribution(Q));
      end
      [~,minIndex]=min(dynamicScore);
      u=obj.uRange(minIndex);
      minModel=tempModel(minIndex);
    end
    function probability=deltaDistribution(obj,index)
      probability=zeros(obj.modelFsp.dims);
      probability(index(1)+1,index(2)+1)=1;
    end
    function score=getDyanamicScore(obj,modelfsp,probability)
      infGenerator=obj.getInfGenerator(modelfsp);
      score=obj.score.getDynamicScore(probability,infGenerator);
    end
    function steadyStateProbability=getSteadyState(obj)
      steadyStateProbability=obj.modelFsp.getSteadyState();
    end
    function infGen=getInfGenerator(obj,modelFsp)
      infGen=modelFsp.getInfGenerator;
    end
  end
end