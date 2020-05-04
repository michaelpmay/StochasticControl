classdef Tensor5D < TensorND
  methods
    function map=indexMap(obj)
      dims=obj.dims;
      for i=1:dims(1)
        for j=1:dims(2)
          for k=1:dims(3)
            for l=1:dims(4)
              for m=1:dims(5)
                x(i,j,k,l,m)=i;
                y(i,j,k,l,m)=j;
                z(i,j,k,l,m)=k;
                a(i,j,k,l,m)=l;
                b(i,j,k,l,m)=m;
              end
            end
          end
        end
      end
      map=[x(:),y(:),z(:),a(:),b(:)];
    end
  end
end