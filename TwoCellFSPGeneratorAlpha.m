classdef TwoCellFSPGeneratorAlpha < TwoCellFSPGenerator
  properties
    alpha=0.0203*20/300
  end
  methods
    function bArray=getBArray(obj)
      [xv,yv] = obj.getXYV();
      bArray=zeros([obj.dims(1),obj.dims(2),obj.dims(1),obj.dims(2)]);
      for i=1:length(xv)
        for j=1:length(yv)
          for k=1:length(xv)
            for l=1:length(yv)
              if (k==(i-1)) && (l==j)
                bArray(i,j,k,l)=bArray(i,j,k,l)+obj.alpha;
                bArray(k,l,k,l)=bArray(k,l,k,l)-obj.alpha;
              elseif (k==i) && (l==(j-1))
                bArray(i,j,k,l)=bArray(i,j,k,l)+obj.alpha;
                bArray(k,l,k,l)=bArray(k,l,k,l)-obj.alpha;
              end
            end
          end
        end
      end
    end
  end
end