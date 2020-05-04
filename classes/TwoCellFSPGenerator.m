classdef TwoCellFSPGenerator
  properties
    model
    dims
  end
  properties(Hidden)
    aMatrix
    bMatrix
  end
  methods
    function obj=TwoCellFSPGenerator(model,dims)
        obj.model=model;
        obj.dims=dims;
        obj.aMatrix=obj.getAMatrix();
        obj.bMatrix=obj.getBMatrix();
    end
    function hArray=getHArray(obj)
      [xv,yv] = obj.getXYV();
      hArray=zeros([obj.dims(1),obj.dims(2),obj.dims(1),obj.dims(2)]);
      for i=1:length(xv)
        for j=1:length(yv)
          for k=1:length(xv)
            for l=1:length(yv)
              if k==(i-1)&&(l==j)
                hArray(i,j,k,l)=hArray(i,j,k,l)+obj.getProductionRate(xv(k));
                hArray(k,l,k,l)=hArray(k,l,k,l)-obj.getProductionRate(xv(k));
              elseif k==(i+1)&&(l==j)
                hArray(k,l,i,j)=hArray(k,l,i,j)+obj.getProductionRate(xv(i));
                hArray(i,j,i,j)=hArray(i,j,i,j)-obj.getProductionRate(xv(i));
              elseif l==(j-1)&&(k==i)
                hArray(i,j,k,l)=hArray(i,j,k,l)+obj.getProductionRate(yv(l));
                hArray(k,l,k,l)=hArray(k,l,k,l)-obj.getProductionRate(yv(l));
              elseif l==(j+1)&&(k==i)
                hArray(k,l,i,j)=hArray(k,l,i,j)+obj.getProductionRate(yv(j));
                hArray(i,j,i,j)=hArray(i,j,i,j)-obj.getProductionRate(yv(j));
              end
            end
          end
        end
      end
    end
    function bArray=getBArray(obj)
      [xv,yv] = obj.getXYV();
      bArray=zeros([obj.dims(1),obj.dims(2),obj.dims(1),obj.dims(2)]);
      for i=1:length(xv)
        for j=1:length(yv)
          for k=1:length(xv)
            for l=1:length(yv)
              if (k==(i-1)) && (l==j)
                bArray(i,j,k,l)=bArray(i,j,k,l)+1;
                bArray(k,l,k,l)=bArray(k,l,k,l)-1;
              elseif (k==i) && (l==(j-1))
                bArray(i,j,k,l)=bArray(i,j,k,l)+1;
                bArray(k,l,k,l)=bArray(k,l,k,l)-1;
              end
            end
          end
        end
      end
    end
    function gArray=getGArray(obj)
      [xv,yv] = obj.getXYV();
      gArray=zeros([obj.dims(1),obj.dims(2),obj.dims(1),obj.dims(2)]);
      for i=1:length(xv)
        for j=1:length(yv)
          for k=1:length(xv)
            for l=1:length(yv)
              if k==(i-1)&&(l==j)
                gArray(k,l,i,j)=gArray(k,l,i,j)+obj.getDegredationRate(xv(i));
                gArray(i,j,i,j)=gArray(i,j,i,j)-obj.getDegredationRate(xv(i));
              elseif k==(i+1)&&(l==j)
                gArray(i,j,k,l)=gArray(i,j,k,l)+obj.getDegredationRate(xv(k));
                gArray(k,l,k,l)=gArray(k,l,k,l)-obj.getDegredationRate(xv(k));
              elseif l==(j-1)&&(k==i)
                gArray(k,l,i,j)=gArray(k,l,i,j)+obj.getDegredationRate(yv(j));
                gArray(i,j,i,j)=gArray(i,j,i,j)-obj.getDegredationRate(yv(j));
              elseif l==(j+1)&&(k==i)
                gArray(i,j,k,l)=gArray(i,j,k,l)+obj.getDegredationRate(yv(l));
                gArray(k,l,k,l)=gArray(k,l,k,l)-obj.getDegredationRate(yv(l));
              end
            end
          end
        end
      end
    end
    function rate=getProductionRate(obj,x)
      rate=obj.model.evaluateRateEquation(0,x);
      rate=rate(1);
    end
    function rate=getDegredationRate(obj,x)
      rate=obj.model.evaluateRateEquation(0,x);
      rate=rate(2);
    end
    function aArray=getAArray(obj)
      aArray=obj.getHArray+obj.getGArray;
    end
    function bMatrix=getBMatrix(obj)
      bArray=obj.getBArray();
      bMatrix=reshape(bArray,[prod(obj.dims),prod(obj.dims)]);
    end
    function aMatrix=getAMatrix(obj)
      aArray=obj.getAArray();
      aMatrix=reshape(aArray,[prod(obj.dims),prod(obj.dims)]);
    end
    function infGenerator=getInfGenerator(obj,model)
      infGenerator=(obj.getAMatrix+obj.getBMatrix.*model.controlInput(:)');
    end
    function [xv, yv]=getXYV(obj)
      xv=0:(obj.dims(1)-1);
      yv=0:(obj.dims(2)-1);
    end
  end
end