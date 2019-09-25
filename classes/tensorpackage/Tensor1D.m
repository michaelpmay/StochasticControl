classdef Tensor1D < TensorND
  methods
    function map=indexMap(obj)
      dims=obj.dims;
      for i=1:dims(1)
        x(i)=i;
      end
      map=[x(:)];
    end
    function multiply(obj,tensor)
    end
  end
end