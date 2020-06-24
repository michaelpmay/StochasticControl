classdef TensorND
  properties
    elem
  end
  methods
    function obj=TensorND(elements)
      obj.elem=obj.sanitizeElements(elements);
    end
    function dims=dims(obj)
      dims=size(obj.elem);
      dims(dims==1)=[];
    end
    function rank=rank(obj)
      rank=length(obj.dims);
    end
    function indexMap(obj)
    end
    function tensor=contract(obj,index1,index2)
      map=obj.indexMap;
      offIndeces=obj.offIndecies([index1,index2]);
      dims=obj.dims;
      tensor=preAllocateTensor(dims(offIndeces));
      for i=1:length(map)
        if map(i,index1)==map(i,index2)
          for j=1:length(offIndeces)
            tensorMap{j}=map(i,offIndeces(j));
          end
          elemCell=num2cell(map(i,:));
          tensor(tensorMap{:})=tensor(tensorMap{:})+obj.elem(elemCell{:});
        end
      end
      tensor=Tensor(tensor);
    end
    function elem=getElements(obj)
      elem=obj.elem;
    end
    function indeces=offIndecies(obj,index)
      indeces=1:obj.rank;
      for i=1:length(index)
      indeces(indeces==index(i))=[];
      end
      if isempty(indeces)
        indeces=1;
      end
    end
    function outerTensor=outer(obj,tensor)
      tensor=obj.sanitizeTensor(tensor);
      objMap=obj.indexMap;
      tensorMap=tensor.indexMap;
      outerMap=obj.outerMap(tensor);
      outerTensor=[];
      ind=1;
      for i=1:size(objMap,1)
        for j=1:size(tensorMap,1)
          cellMap=num2cell(outerMap(ind,:));
          outerTensor(cellMap{:})=obj.getElem(i)*tensor.getElem(j);
          ind=ind+1;
        end
      end
      outerTensor=Tensor(outerTensor);
    end
    function outerMap=outerMap(obj,tensor)
      tensorMap=tensor.indexMap;
      objMap=obj.indexMap;
      outerMap=[];
      for i=1:size(objMap,1)
        for j=1:size(tensorMap)
          outerMap(end+1,:)=[objMap(i,:),tensorMap(j,:)];
        end
      end
    end
    function output=multiply(obj,tensor,objInds,tensorInds)
      tensor=obj.sanitizeTensor(tensor);
      assert(length(objInds)==length(tensorInds));
      output=obj.outer(tensor);
      for i=1:length(objInds)
        output=output.contract(objInds(i)-(i-1),tensorInds(i)-(i-1)+obj.rank);
      end
    end
    function tensor=sanitizeTensor(obj,tensor)
      if string(class(tensor))=="double"
        tensor=Tensor(tensor);
      end
    end
    function elements=sanitizeElements(obj,elements)
      elements=squeeze(elements);
    end
    function elem=getElem(obj,index)
      elem=obj.elem(index);
    end
  end
end