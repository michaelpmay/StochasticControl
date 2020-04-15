classdef ParameterSet
  properties
    node
  end
  methods
    function value=get(obj,name)
      index=obj.find(name);
      value=obj.indexValue(index);
    end
    function obj=set(obj,name,value)
      try
        index=obj.find(name);
        obj.node{index}=obj.node{index}.setValue(value);
      catch
        obj.node{end+1}=Parameter(name,value);
      end
      obj=obj.sort;
    end
    function ind=find(obj,name)
      nameString=string(name);
      ind=0;
      for i=1:length(obj.node)
        if nameString==obj.indexName(i)
          ind=i;
        end
      end
      if ind==0
        error('parameter name not found');
      end
    end
    function name=indexName(obj,index)
      name=obj.node{index}.getName;
    end
    function value=indexValue(obj,index)
      value=obj.node{index}.getValue;
    end
    function [names,values]=getAll(obj)
      names=obj.getAllNames;
      values=obj.getAllValues;
    end
    function names=getAllNames(obj)
      names=strings(1,length(obj.node));
      for i=1:obj.length
        names(i)=obj.indexName(i);
      end
    end
    function values=getAllValues(obj)
      values=zeros(1,length(obj.node));
      for i=1:obj.length
        values(i)=obj.indexValue(i);
      end
    end
    function len=length(obj)
      len=length(obj.node);
    end
    function obj=sort(obj)
      names=obj.getAllNames;
      [names,sortIndex]=sort(names);
      for i=1:obj.length
        sortNode{i}=obj.node{sortIndex(i)};
      end
      obj.node=sortNode;
    end
  end
end