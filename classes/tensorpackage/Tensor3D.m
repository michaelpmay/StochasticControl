classdef Tensor3D < TensorND
  methods
    function map=indexMap(obj)
      dims=obj.dims;
      for i=1:dims(1)
        for j=1:dims(2)
          for k=1:dims(3)
            x(i,j,k)=i;
            y(i,j,k)=j;
            z(i,j,k)=k;
          end
        end
      end
      map=[x(:),y(:),z(:)];
    end
  end
end