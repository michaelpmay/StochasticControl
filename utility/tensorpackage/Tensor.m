classdef Tensor
  properties
    container
  end
  methods
    function obj=Tensor(elements)
      dims=size(elements);
      dims(dims==1)=[];
      rank=length(dims);
      switch rank
        case 1
          obj.container=Tensor1D(elements);
        case 2
          obj.container=Tensor2D(elements);
        case 3
          obj.container=Tensor3D(elements);
        case 4
          obj.container=Tensor4D(elements);
        case 5
          obj.container=Tensor5D(elements);
        case 6
          obj.container=Tensor6D(elements);
        case 7
          obj.container=Tensor7D(elements);
        case 8
          obj.container=Tensor8D(elements);
      end
    end
    function dims=dims(obj)
      dims=obj.container.dims;
    end
    function rank=rank(obj)
      rank=obj.container.rank;
    end
    function indexMap=indexMap(obj)
      indexMap=obj.container.indexMap;
    end
    function elem=getElements(obj)
      elem=obj.container.getElements;
    end
    function indeces=offIndecies(obj,index1,index2)
      indeces=obj.container.offindeces(obj,index1,index2);
    end
    function tensor=contract(obj,index1,index2)
      tensor=obj.container.contract(index1,index2);
    end
    function tensor=multiply(obj,tensor,index1,index2)
      tensor=obj.container.multiply(tensor,index1,index2);
    end
    function elem=getElem(obj,index)
      elem=obj.container.getElem(index);
    end
    function outer=outer(obj,tensor)
      outer=obj.container.outer(tensor);
    end
  end
end
