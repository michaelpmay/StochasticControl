classdef ModelFactory
%valid [ka ga] = [.65 .0325] or [ka ga] = [.400 0.020]
  properties
    ko=.406 %.400 %.6500
    be=20
    mu=8
    ga=.0203 %0.020 
    ka=0.0001
    eko=3.5821;%experimental ko
    ExperimentalInput=@(t,x,u)(u(1)*(t<270)+u(3)*(t>570)+...
                               u(2)*((t>=270)&(t<=570)))
    ControlInput=@(t,x,field)field(f(1)+1,x(2)+1);
    frequencyInput=@(t,x,u)u(2)*(abs(sawtooth(2*pi*u(1)*t)))
    u=[200.6588    1.3809   60.6751]
    time=linspace(0,780)
    stoichMatrix=[1,-1]
    dims=[50 50]
  end
  methods
    function model=birthDecayToyModel(obj)
      model=ModelPlugin();
      model.stoichMatrix=[1,-1];
      model.time=linspace(0,100,500);
      model.rxnRate=@(t,x,p)[p(1),p(2)*x(1)]
      model.parameters=[1,1];
      model.initialState=[0];
    end
    function model=birthDecayToyModel2D(obj)
      model=ModelPlugin();
      model.stoichMatrix=[1 -1  0  0
                          0  0  1 -1];
      model.time=linspace(0,100,500);
      model.rxnRate=@(t,x,p)[p(1),p(2)*x(1),p(3),p(4)*x]
      model.parameters=[1,1,1,1];
      model.initialState=[0;0];
    end
    function model=unregulatedModelWithExperimentalInput(obj)
      model=ModelPlugin();
      model.stoichMatrix=obj.stoichMatrix;
      model.parameters=[obj.ko obj.ga obj.u];
      model.rxnRate=@(t,x,p)[p(1)+obj.ExperimentalInput(t,x,p(3:5)) ; p(2)*x(1)];
      model.initialState=[0];
      model.time=obj.time;
    end
    function model=unregulatedModelWithFrequencyInput(obj,frequency,amplitude)
      model=ModelPlugin();
      model.stoichMatrix=obj.stoichMatrix;
      model.parameters=[obj.ko obj.ga frequency amplitude];
      model.rxnRate=@(t,x,p)[p(1)+obj.frequencyInput(t,x,p(3:4)) ; p(2)*x(1)];
      model.initialState=[0];
      model.time=obj.time;
    end
    function model=unregulatedModelWithoutInput(obj)
      model=ModelPlugin();
      model.stoichMatrix=obj.stoichMatrix;
      model.parameters=[obj.ko obj.ga];
      model.rxnRate=@(t,x,p)[p(1);p(2)*x(1)];
      model.initialState=[0];
      model.time=obj.time;
    end
    function model=autoregulatedModelWithoutInput(obj)
      model=ModelPlugin();
      model.stoichMatrix=obj.stoichMatrix;
      model.parameters=[obj.ko obj.be obj.mu obj.ka obj.ga];
      model.rxnRate=@(t,x,p)[hill(x,p(1),p(2),p(3),p(4));linearDegredation(x,p(5))];
      model.initialState=[0];
      model.time=obj.time;
    end
    function model=autoregulatedModelWithFrequencyInput(obj,frequency,amplitude)
      model=ModelPlugin();
      model.stoichMatrix=obj.stoichMatrix;
      model.parameters=[obj.ko obj.be obj.mu obj.ka obj.ga, frequency, amplitude];
      model.rxnRate=@(t,x,p)[hill(x,p(1),p(2),p(3),p(4))+obj.frequencyInput(t,x,p(6:7)) ; p(5)*x(1)];
      model.initialState=[0];
      model.time=obj.time;
    end
    function model=unregulatedModelWithConstantLight(obj,lightLevel)
      model=ModelPlugin();
      model.stoichMatrix=obj.stoichMatrix;
      model.parameters=[0 obj.ga lightLevel];
      model.rxnRate=@(t,x,p)[p(1)+lightLevel ; p(2)*x(1)];
      model.initialState=[0];
      model.time=obj.time;
    end
    function model=khammashFitModelNoGamma(obj)
      model=ModelPlugin();
      model.stoichMatrix=obj.stoichMatrix;
      model.parameters=[obj.ko obj.u];
      model.rxnRate=@(t,x,p)[p(1)+obj.ExperimentalInput(t,x,p(2:4)) ; .0203*x(1)];
      model.initialState=[0];
      model.time=obj.time;
    end
    function model=khammashFitModel(obj)
      model=obj.unregulatedModelWithExperimentalInput()
    end
    function model=nCellSSA(obj,N,input)
      model=ModelPlugin;
      model.rxnRate=@(t,x,p)RateEq(t,x,p);
      model.time=obj.time;
      model.initialState=[floor(30*rand())]*ones(1,N);
      model.stoichMatrix=[eye(N),-1*eye(N)];
      model.parameters=[obj.ko obj.be obj.mu obj.ka obj.ga];
      function R=RateEq(t,x,p)
        for k=1:N
          R(k)=hill(x(k),p(1),p(2),p(3),p(4))+input(x,t);
        end
        for k=1:N
          R(end+1)=linearDegredation(x(k),p(5));
        end
      end
    end
  end
end