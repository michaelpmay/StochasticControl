classdef ReducedModelFSP < GenericFSP & ReducedModelParameters
  %UNTITLED2 Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    dims =[50 50]
  end
  properties (Hidden)
    maxU=50
    aMatrix
    bMatrix
  end
  methods (Hidden)
    function obj=ReducedModelFSP()
      obj.aMatrix=obj.getAMatrix;
      obj.bMatrix=obj.getBMatrix;
      obj.controlInput=zeros(obj.dims);
      obj.time=linspace(0,10,100);
      obj.initialState=zeros(obj.dims);
      obj.initialState(1,1)=1;
    end
    function hArray=getHArray(obj)
      field=obj.getHillFun;
      [xv,yv] = obj.getXYV();
      hArray=zeros([obj.dims(1),obj.dims(2),obj.dims(1),obj.dims(2)]);
      for i=1:length(xv)
        for j=1:length(yv)
          for k=1:length(xv)
            for l=1:length(yv)
              if k==(i-1)&&(l==j)
                hArray(i,j,k,l)=hArray(i,j,k,l)+field(xv(k));
                hArray(k,l,k,l)=hArray(k,l,k,l)-field(xv(k));
              elseif k==(i+1)&&(l==j)
                hArray(k,l,i,j)=hArray(k,l,i,j)+field(xv(i));
                hArray(i,j,i,j)=hArray(i,j,i,j)-field(xv(i));
              elseif l==(j-1)&&(k==i)
                hArray(i,j,k,l)=hArray(i,j,k,l)+field(yv(l));
                hArray(k,l,k,l)=hArray(k,l,k,l)-field(yv(l));
              elseif l==(j+1)&&(k==i)
                hArray(k,l,i,j)=hArray(k,l,i,j)+field(yv(j));
                hArray(i,j,i,j)=hArray(i,j,i,j)-field(yv(j));
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
      field=obj.getGammaFun;
      [xv,yv] = obj.getXYV();
      gArray=zeros([obj.dims(1),obj.dims(2),obj.dims(1),obj.dims(2)]);
      for i=1:length(xv)
        for j=1:length(yv)
          for k=1:length(xv)
            for l=1:length(yv)
              if k==(i-1)&&(l==j)
                gArray(k,l,i,j)=gArray(k,l,i,j)+field(xv(i));
                gArray(i,j,i,j)=gArray(i,j,i,j)-field(xv(i));
              elseif k==(i+1)&&(l==j)
                gArray(i,j,k,l)=gArray(i,j,k,l)+field(xv(k));
                gArray(k,l,k,l)=gArray(k,l,k,l)-field(xv(k));
              elseif l==(j-1)&&(k==i)
                gArray(k,l,i,j)=gArray(k,l,i,j)+field(yv(j));
                gArray(i,j,i,j)=gArray(i,j,i,j)-field(yv(j));
              elseif l==(j+1)&&(k==i)
                gArray(i,j,k,l)=gArray(i,j,k,l)+field(yv(l));
                gArray(k,l,k,l)=gArray(k,l,k,l)-field(yv(l));
              end
            end
          end
        end
      end
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
    function infGenerator=getInfGenerator(obj)
      infGenerator=(obj.aMatrix+obj.bMatrix.*obj.controlInput(:)');
    end
    function reshapedInitialState=getInitialState(obj)
      reshapedInitialState=obj.initialState(:);
    end
    function data=formatTrajectory(obj,data)
      newState=zeros([obj.dims(1),obj.dims(2),obj.time])
      for i=1:length(data.time)
        newState(:,:,i)=reshape(data.state(:,i),[obj.dims(1),obj.dims(2)]);
      end
      data=ReducedModelFSPData(data.time,newState,data.meta);
    end
    function Pss=getSteadyState(obj)
      Pss=reshape(obj.getSteadyState@GenericFSP,obj.dims);
      Pss=ReducedModelFSPData(Pss);
      Pss=obj.appendMetaData(Pss);
    end
    function data=appendMetaData(obj,data)
      data=obj.appendMetaData@GenericFSP(data);
      data.meta.infGenerator=obj.getInfGenerator;
      data.meta.xv=0:(obj.dims(1)-1);
      data.meta.yv=0:(obj.dims(2)-1);
      data.meta.ka=obj.ka;
      data.meta.mu=obj.mu;
      data.meta.be=obj.be;
      data.meta.ga=obj.ga;
      data.meta.ko=obj.ko;
      data.meta.controlInput=obj.controlInput;
    end
    function grad=getGrad(obj)
      P=obj.getSteadyState();
      invLambda=inv_chol(obj.bMatrix.*obj.controlInput(:)'+obj.aMatrix);
      grad=invLambda*(obj.bMatrix.*P.state(:)');
      function Y = inv_chol(L)
        N = size(L, 1) ;
        Y = zeros(N, N) ;
        R = L' ;
        S = inv(diag(diag(R))) ;
        for j=N:-1:1
          for i=j:-1:1
            Y(i,j) = S(i,j) - R(i,i+1:end)*Y(i+1:end,j) ;
            Y(i,j) = Y(i,j)/R(i,i) ;
            Y(j,i) = conj(Y(i,j)) ;
          end
        end
      end
    end
    function getGradFsolve(obj)
      P=obj.getSteadyState();
      P=P.state(:);
      V=P'*(obj.bMatrix.*P');
      W=P'*(obj.aMatrix+obj.bMatrix.*obj.controlInput(:)');
      Fun=@(DnP)(V+W*DnP)
      fsolve(Fun,zeros(2500,2500))
    end
    function [xv, yv]=getXYV(obj)
      xv=0:(obj.dims(1)-1);
      yv=0:(obj.dims(2)-1);
    end
  end
end

