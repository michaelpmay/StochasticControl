classdef Tensor2D < TensorND
  methods
    function map=indexMap(obj)
      dims=obj.dims;
      for i=1:dims(1)
        for j=1:dims(2)
          x(i,j)=i;
          y(i,j)=j;
        end
      end
      map=[x(:),y(:)];
    end
  end
end