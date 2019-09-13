classdef TwoCellFSPGenerator
  properties
    model
  end
  properties(Hidden)
    aMatrix
    bMatrix
  end
  methods
    function obj=TwoCellFSPGenerator()
    end
    function hArray=makeHArray(obj,model)
      [xv,yv] = obj.getXYV(model);
      hArray=zeros([model.dims(1),model.dims(2),model.dims(1),model.dims(2)]);
      for i=1:length(xv)
        for j=1:length(yv)
          for k=1:length(xv)
            for l=1:length(yv)
              if k==(i-1)&&(l==j)
                hArray(i,j,k,l)=hArray(i,j,k,l)+obj.getProductionRate(xv(k),model);
                hArray(k,l,k,l)=hArray(k,l,k,l)-obj.getProductionRate(xv(k),model);
              elseif k==(i+1)&&(l==j)
                hArray(k,l,i,j)=hArray(k,l,i,j)+obj.getProductionRate(xv(i),model);
                hArray(i,j,i,j)=hArray(i,j,i,j)-obj.getProductionRate(xv(i),model);
              elseif l==(j-1)&&(k==i)
                hArray(i,j,k,l)=hArray(i,j,k,l)+obj.getProductionRate(yv(l),model);
                hArray(k,l,k,l)=hArray(k,l,k,l)-obj.getProductionRate(yv(l),model);
              elseif l==(j+1)&&(k==i)
                hArray(k,l,i,j)=hArray(k,l,i,j)+obj.getProductionRate(yv(j),model);
                hArray(i,j,i,j)=hArray(i,j,i,j)-obj.getProductionRate(yv(j),model);
              end
            end
          end
        end
      end
    end
    function bArray=makeBArray(obj,model)
      [xv,yv] = obj.getXYV(model);
      bArray=zeros([model.dims(1),model.dims(2),model.dims(1),model.dims(2)]);
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
    function gArray=makeGArray(obj,model)
      [xv,yv] = obj.getXYV(model);
      gArray=zeros([model.dims(1),model.dims(2),model.dims(1),model.dims(2)]);
      for i=1:length(xv)
        for j=1:length(yv)
          for k=1:length(xv)
            for l=1:length(yv)
              if k==(i-1)&&(l==j)
                gArray(k,l,i,j)=gArray(k,l,i,j)+obj.getDegredationRate(xv(i),model);
                gArray(i,j,i,j)=gArray(i,j,i,j)-obj.getDegredationRate(xv(i),model);
              elseif k==(i+1)&&(l==j)
                gArray(i,j,k,l)=gArray(i,j,k,l)+obj.getDegredationRate(xv(k),model);
                gArray(k,l,k,l)=gArray(k,l,k,l)-obj.getDegredationRate(xv(k),model);
              elseif l==(j-1)&&(k==i)
                gArray(k,l,i,j)=gArray(k,l,i,j)+obj.getDegredationRate(yv(j),model);
                gArray(i,j,i,j)=gArray(i,j,i,j)-obj.getDegredationRate(yv(j),model);
              elseif l==(j+1)&&(k==i)
                gArray(i,j,k,l)=gArray(i,j,k,l)+obj.getDegredationRate(yv(l),model);
                gArray(k,l,k,l)=gArray(k,l,k,l)-obj.getDegredationRate(yv(l),model);
              end
            end
          end
        end
      end
    end
    function rate=getProductionRate(obj,x,model)
      rate=model.evaluateRateEquation(0,x);
      rate=rate(1);
    end
    function rate=getDegredationRate(obj,x,model)
      rate=model.evaluateRateEquation(0,x);
      rate=rate(2);
    end
    function aArray=makeAArray(obj,model)
      aArray=obj.makeHArray(model)+obj.makeGArray(model);
    end
    function bMatrix=makeBMatrix(obj,model)
      bArray=obj.makeBArray(model);
      bMatrix=reshape(bArray,[prod(model.dims),prod(model.dims)]);
    end
    function aMatrix=makeAMatrix(obj,model)
      aArray=obj.makeAArray(model);
      aMatrix=reshape(aArray,[prod(model.dims),prod(model.dims)]);
    end
    function infGenerator=getInfGenerator(obj,model)
      obj=obj.updateABMatrix(model)
      infGenerator=(obj.aMatrix+obj.bMatrix.*model.controlInput(:)');
    end
    function obj=updateABMatrix(obj,model)
      if isempty(obj.aMatrix)
        obj.aMatrix=obj.makeAMatrix(model);
      end
      if isempty(obj.bMatrix)
        obj.bMatrix=obj.makeBMatrix(model);
      end
    end
    function aMatrix=getAMatrix(model)
      obj=obj.updateABMatrix;
      aMatrix=obj.aMatrix;
    end
    function bMatrix=getBMatrix(model)
      obj=obj.updateABMatrix;
      bMatrix=obj.bMatrix;
    end
    function [xv, yv]=getXYV(obj,model)
      xv=0:(model.dims(1)-1);
      yv=0:(model.dims(2)-1);
    end
    end
end