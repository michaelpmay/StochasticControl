classdef SSAData
  properties
    node={}
  end
  
  methods
    
    function obj=appendNode(obj,data)
      obj.node{end+1}=data;
    end
    
    function obj=rmNode(obj,index)
      obj.node=[obj.node{1:index-1},obj.node{index+1:end}];
    end
    
    function data=getSnapshot(obj,timeIndex,speciesIndex)
      data.state=preAllocateVector(obj.length());
      for i=1:obj.length()
        data.state(i)=obj.node{i}.state(speciesIndex,timeIndex);
      end
      data.time=obj.node{1}.time(timeIndex);
    end
    function [count,binEdge]=getWindowHistogram(obj,speciesIndex,initialTimeIndex,finalTimeIndex)
      snapshotArray=[];
      for i=initialTimeIndex:finalTimeIndex
        snapshot=obj.getSnapshot(i,speciesIndex);
        snapshotArray(:,i)=snapshot.state;
      end
      nbins=max(snapshotArray);
      [count,binEdge]=hist(snapshotArray(:),nbins,'Normalization','probability');
      count=count/sum(count);
    end
    function data=getTimeSeries(obj,sampleIndex,speciesIndex)
      data.time=obj.node{sampleIndex}.time;
      data.state=obj.node{sampleIndex}.state(speciesIndex,:);
    end
    function data=getAllTimeSeries(obj,sampleIndex)
      data.time=obj.node{sampleIndex}.time;
      data.state=obj.node{sampleIndex}.state;
    end
    function visual=view(obj)
      visual=ViewSSAData(obj);
    end
    
    function len=length(obj)
      len=length(obj.node);
    end
    function obj=trimInitial(obj,timeIndex)
      for i=1:obj.length
        obj.node{i}.time=obj.node{i}.time(timeIndex:end);
        obj.node{i}.state=obj.node{i}.state(:,timeIndex:end);
      end
    end
  end
  
end