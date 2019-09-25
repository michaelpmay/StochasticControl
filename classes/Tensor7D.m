classdef Tensor7D < TensorND
  methods
    function map=indexMap(obj)
      dims=obj.dims;
      for i=1:dims(1)
        for j=1:dims(2)
          for k=1:dims(3)
            for l=1:dims(4)
              for m=1:dims(5)
                for n=1:dims(6)
                  for o=1:dims(7)
                  x(i,j,k,l,m,n,o)=i;
                  y(i,j,k,l,m,n,o)=j;
                  z(i,j,k,l,m,n,o)=k;
                  a(i,j,k,l,m,n,o)=l;
                  b(i,j,k,l,m,n,o)=m;
                  c(i,j,k,l,m,n,o)=n;
                  d(i,j,k,l,m,n,o)=o;
                  end
                end
              end
            end
          end
        end
      end
      map=[x(:),y(:),z(:),a(:),b(:),c(:),d(:)];
    end
  end
end