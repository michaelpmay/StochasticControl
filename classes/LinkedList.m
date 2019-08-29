classdef LinkedList
  properties (Hidden)
    list=java.util.LinkedList;
  end
  methods
    function obj=LinkedList(varargin)
      obj.list=java.util.LinkedList;
      if nargin==0   
      else
        for i=1:nargin
        obj.list.add(varargin{i});
        end
      end
    end
    function add(obj,listItem)
      obj.list.add(listItem);
    end
    function remove(obj,index)
      obj.list.remove(index);
    end
    function set(obj,index,value)
      obj.list.set(index-1,value);
    end
    function arrayLength=length(obj)
      arrayLength=length(obj.list.toArray);
    end
    function item=get(obj,index)
      item=obj.list.get(index-1);
    end
    function javaArray=toArray(obj)
      javaArray=obj.list.toArray;
    end
    function outArray=toMLArray(obj)
      javaArray=obj.list.toArray;
      sizeOfArray=size(javaArray);
      sizeOfElements=size(javaArray(1));
      outArray=zeros(max(sizeOfElements),max(sizeOfArray));
      for i=1:sizeOfArray
        outArray(:,i)=javaArray(i);
      end
    end
    function item=getLast(obj)
      item=obj.list.getLast();
    end
  end
end