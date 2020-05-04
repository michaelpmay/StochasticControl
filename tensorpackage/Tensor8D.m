classdef Tensor8D < TensorND
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
                    for p=1:dims(8)
                      x(i,j,k,l,m,n,o,p)=i;
                      y(i,j,k,l,m,n,o,p)=j;
                      z(i,j,k,l,m,n,o,p)=k;
                      a(i,j,k,l,m,n,o,p)=l;
                      b(i,j,k,l,m,n,o,p)=m;
                      c(i,j,k,l,m,n,o,p)=n;
                      d(i,j,k,l,m,n,o,p)=o;
                      e(i,j,k,l,m,n,o,p)=p;
                    end
                  end
                end
              end
            end
          end
        end
      end
      map=[x(:),y(:),z(:),a(:),b(:),c(:),d(:),e(:)];
    end
  end
end