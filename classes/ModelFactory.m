classdef ModelFactory
  %valid [ka ga] = [.65 .0325] or [ka ga] = [.400 0.020]
  properties
    ko=.406 %.400 %.6500
    be=20
    mu=8
    ga=.0203 %0.020
    ka=0.0001
    eko=3.5821;%experimental ko [3.5821]
    ExperimentalInput=@(t,x,u)(u(1)*(t<270)+u(3)*(t>570)+...
      u(2)*((t>=270)&(t<=570)))
    ControlInput=@(t,x,field)field(f(1)+1,x(2)+1);
    frequencyInput=@(t,x,u)u(2)*sin(2*pi*u(1).*t)+u(3)
    u=[200.6588    1.3809   60.6751]
    eu=[249.588 1.3809 60.6751]
    time=linspace(0,780)
    stoichMatrix=[1,-1]
    dims=[50 50]
    controlable=true;
    ssaBoundary=60;
  end
  methods
    function model=makeModelObject(obj)
      if obj.controlable==true;
        model=ControlModel;
      else
        model=ModelPlugin;
      end
    end
    function model=birthDecayToyModel(obj)
      model=obj.makeModelObject();
      model.stoichMatrix=[1,-1];
      model.time=linspace(0,100,500);
      model.rxnRate=@(t,x,p)[p(1),p(2)*x(1)]
      model.parameters=[1,1];
      model.initialState=[0];
    end
    function model=birthDecayToyModel2D(obj)
      model=obj.makeModelObject();
      model.stoichMatrix=[1 -1  0  0
        0  0  1 -1];
      model.time=linspace(0,100,500);
      model.rxnRate=@(t,x,p)[p(1),p(2)*x(1),p(3),p(4)*x]
      model.parameters=[1,1,1,1];
      model.initialState=[0;0];
    end
    function model=unregulatedModelWithExperimentalInput(obj)
      model=obj.makeModelObject();
      model.stoichMatrix=obj.stoichMatrix;
      model.parameters=[obj.ko obj.ga obj.u];
      model.rxnRate=@(t,x,p)[p(1)+obj.ExperimentalInput(t,x,p(3:5)) ; p(2)*x(1)];
      model.initialState=[0];
      model.time=obj.time;
    end
    function model=unregulatedModelWithFrequencyInput(obj,frequency,amplitude,offset)
      model=obj.makeModelObject();
      model.stoichMatrix=obj.stoichMatrix;
      model.parameters=[obj.ko obj.ga frequency amplitude offset];
      model.rxnRate=@(t,x,p)[p(1)+obj.frequencyInput(t,x,p(3:5)) ; p(2)*x(1)];
      model.initialState=[0];
      model.time=obj.time;
    end
    function model=autoregulatedModelWithUniformInput(obj,lightInput)
      model=obj.makeModelObject();
      model.stoichMatrix=obj.stoichMatrix;
      model.parameters=[obj.ko obj.be obj.mu obj.ka obj.ga, lightInput];
      model.rxnRate=@(t,x,p)[hill(x,p(1),p(2),p(3),p(4))+p(6);linearDegredation(x,p(5))];
      model.initialState=[0];
      model.time=obj.time;
    end  
    function model=unregulatedModelWithoutInput(obj)
      model=obj.makeModelObject();
      model.stoichMatrix=obj.stoichMatrix;
      model.parameters=[obj.ka obj.ga];
      model.rxnRate=@(t,x,p)[p(1);p(2)*x(1)];
      model.initialState=[0];
      model.time=obj.time;
    end
    function model=autoregulatedModelWithoutInput(obj)
      model=obj.makeModelObject();
      model.stoichMatrix=obj.stoichMatrix;
      model.parameters=[obj.ko obj.be obj.mu obj.ka obj.ga];
      model.rxnRate=@(t,x,p)[hill(x,p(1),p(2),p(3),p(4));linearDegredation(x,p(5))];
      model.initialState=[0];
      model.time=obj.time;
    end
    function model=autoregulatedModelWithFrequencyInput(obj,frequency,amplitude,offset)
      model=ModelPlugin();
      model.stoichMatrix=obj.stoichMatrix;
      model.parameters=[obj.ko obj.be obj.mu obj.ka obj.ga, frequency, amplitude,offset];
      model.rxnRate=@(t,x,p)[hill(x,p(1),p(2),p(3),p(4))+obj.frequencyInput(t,x,p(6:8)); p(5)*x(1)];
      model.initialState=[0];
      model.time=obj.time;
    end
    function model=unregulatedModelWithUniformLight(obj,lightLevel)
      model=obj.makeModelObject();
      model.stoichMatrix=obj.stoichMatrix;
      model.parameters=[obj.ka obj.ga lightLevel];
      model.rxnRate=@(t,x,p)[p(1)+p(3) ; p(2)*x(1)];
      model.initialState=[0];
      model.time=obj.time;
    end
    function model=khammashFitModelNoGamma(obj)
      model=obj.makeModelObject();
      model.stoichMatrix=obj.stoichMatrix;
      model.parameters=[obj.ko obj.u];
      model.rxnRate=@(t,x,p)[p(1)+obj.ExperimentalInput(t,x,p(2:4)) ; .0203*x(1)];
      model.initialState=[0];
      model.time=obj.time;
    end
    function model=khammashFitModel(obj)
      model=obj.unregulatedModelWithExperimentalInput();
      model.parameters=[obj.eko obj.ga obj.eu]
    end
    function model=optimizedTwoCellModel(obj)
      model=obj.autoregulatedModelWithoutInput;
      load('inFiles/controlInput.mat');
      model.controlInput=controlInput;
      model=TwoCellFSP(model,obj.dims);
    end
    function model=nCellAutoregulatedModel(obj,N,input)
      model=obj.makeModelObject();
      model.rxnRate=@(t,x,p)RateEq(t,x,p);
      score=ProbabilityScore(obj.dims);
      model.time=obj.time;
      model.initialState=[score.target(1),score.target(2)*ones(1,N-1)]';
      model.stoichMatrix=[eye(N),-1*eye(N)];
      model.parameters=[obj.ko obj.be obj.mu obj.ka obj.ga];
      function R=RateEq(t,x,p)
        for k=1:N
          R(k)=(hill(x(k),p(1),p(2),p(3),p(4))+input(t,x))*(x(k)<obj.ssaBoundary);
        end
        for k=1:N
          R(end+1)=linearDegredation(x(k),p(5));
        end
      end
    end
    function model=infCellAutoregulatedModel(obj,N,input)
      load inFiles/reducedControlInput.mat
      model=obj.nCellAutoregulatedModel(N,input);
    end
    function model=nCellUnregulatedModel(obj,N,input)
      model=obj.makeModelObject();
      model.rxnRate=@(t,x,p)RateEq(t,x,p);
      model.time=obj.time;
      model.initialState=([floor(30*rand())]*ones(1,N))';
      model.stoichMatrix=[eye(N),-1*eye(N)];
      model.parameters=[obj.ka obj.ga];
      function R=RateEq(t,x,p)
        for k=1:N
          R(k)=p(1)+input(x(1)+1);
        end
        for k=1:N
          R(end+1)=linearDegredation(x(k),p(2));
        end
      end
    end
    function model=nCellUnregulatedSwapModel(obj,N,input,time)
      model=obj.nCellUnregulatedModel(N,input);
      model.rxnRate=@(t,x,p)RateEq(t,x,p);
      model.time=time;
      function R=RateEq(t,x,p)
        tVec=linspace(time(1),time(end),N+1);
        tVec=tVec(1:(end-1));
        ind=find(tVec<=t,N,'last');
        ind=ind(end);
        for k=1:N
          R(k)=p(1)+input(x(ind)+1);
        end
        for k=1:N
          R(end+1)=linearDegredation(x(k),p(2));
        end
      end
    end
    function model=simple2by2Model(obj)
      model=obj.makeModelObject();
      model.rxnRate=@(t,x,p)[p(1)+exp(-p(5)*t);p(2)*x(1);p(3)+exp(-p(6)*t);p(4)*x(2)]
      model.time=linspace(0,100,100);
      model.stoichMatrix=[-1  1  0  0;
                           0  0  1 -1];
      model.parameters=[1 1 1 1 0 0];
      model.initialState=[0 0];
    end
    function autoRegulatedModelWith1DMeanInput(obj,controler)
      model=obj.makeModelObject();
      model.stoichMatrix=obj.stoichMatrix;
      model.parameters=[obj.ko obj.be obj.mu obj.ka obj.ga];
      model.rxnRate=@(t,x,p)[hill(x,p(1),p(2),p(3),p(4))+controler(mean(x(2:end))+1);linearDegredation(x,p(5))];
      model.initialState=[0];
      model.time=obj.time;
    end
    function autoRegulatedModelWith2DMeanInput(obj,controler)
      model=obj.makeModelObject();
      model.stoichMatrix=obj.stoichMatrix;
      model.parameters=[obj.ko obj.be obj.mu obj.ka obj.ga];
      model.rxnRate=@(t,x,p)[hill(x,p(1),p(2),p(3),p(4))+controler(mean(x(2:end))+1);linearDegredation(x,p(5))];
      model.initialState=[0];
      model.time=obj.time;
    end
    function model=nCellAutoregulatedSwapModel(obj,N,input,time)
      model=obj.nCellAutoregulatedModel(N);
      model.time=time;
      model.rxnRate=@(t,x,p)RateEq(t,x,p);
      function R=RateEq(t,x,p)
        tVec=linspace(time(1),time(end),N+1);
        tVec=tVec(1:(end-1));
        ind=find(tVec<=t,N,'last');
        ind=ind(end);
        for k=1:N
          R(k)=(hill(x(k),p(1),p(2),p(3),p(4))+input(x(ind)));
        end
        for k=1:N
          R(end+1)=linearDegredation(x(k),p(5));
        end
      end
    end
    function model=buildAutoregulatedFrequencyResponseModel(...
            obj,freq,amp,dc,numCells,time)
          input=@(t,x)obj.frequencyInput(t,x,[freq,amp,dc])
      model=obj.nCellAutoregulatedModel(numCells,input);
      model.time=time;
    end
  end
end