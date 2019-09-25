classdef Tensor4D < TensorND
  methods
    function map=indexMap(obj)
      dims=obj.dims;
      for i=1:dims(1)
        for j=1:dims(2)
          for k=1:dims(3)
            for l=1:dims(4)
              x(i,j,k,l)=i;
              y(i,j,k,l)=j;
              z(i,j,k,l)=k;
              a(i,j,k,l)=l;
            end
          end
        end
      end
      map=[x(:),y(:),z(:),a(:)];
    end
  end
end