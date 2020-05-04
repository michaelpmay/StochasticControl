classdef Tensor6D < TensorND
  methods
    function map=indexMap(obj)
      dims=obj.dims;
      for i=1:dims(1)
        for j=1:dims(2)
          for k=1:dims(3)
            for l=1:dims(4)
              for m=1:dims(5)
                for n=1:dims(6)
                  x(i,j,k,l,m,n)=i;
                  y(i,j,k,l,m,n)=j;
                  z(i,j,k,l,m,n)=k;
                  a(i,j,k,l,m,n)=l;
                  b(i,j,k,l,m,n)=m;
                  c(i,j,k,l,m,n)=n;
                end
              end
            end
          end
        end
      end
      map=[x(:),y(:),z(:),a(:),b(:),c(:)];
    end
  end
end