classdef ModelFactory
  %valid [ka ga] = [.65 .0325] or [ka ga] = [.400 0.020]
  properties
    ko=.406 %.400 %.6500
    be=20
    mu=8
    ga=.0203 %0.020
    %alpha=.0203*20/320*1.437
    %alpha=0.001823813123176
    alpha=1;
    ka=0.0001
    eko=3.5821;%experimental ko [3.5821]
    %fullModelParameters=[1.1164,1.1164/20,1.0000,579.5275,0.0004,0.0024,2.0309,0.025,1.2718]
    fullModelParameters=[2/10,10/10/20,1,20,.05,.5,.5,.0142]
    ExperimentalInput=@(t,x,u)(u(1)*((t>0)&(t<270))+u(3)*(t>570)+u(2)*((t>=270)&(t<=570)))
    ControlInput2D=@(t,x,field)field(x(1)+1,x(2)+1);
    ControlInput1D=@(t,x,field)field(x(1)+1);
    frequencyInput=@(t,x,u)u(2)*sin(2*pi*u(1).*t)+u(3)
    uFitReduced=[0.4060  0.0000  0.1044]
    uFitFull=[0.4060  0.0000  0.04]
    u_exp=[320 0 20]
    time=linspace(0,780)
    dims=[50 50]
    controlable=true;
    ssaBoundary=60;
    maxGenes=100
  end
  methods
    function model=makeModelObject(obj)
      if obj.controlable==true
        model=ControlModel;
      else
        model=ModelPlugin;
      end
    end
    function model=birthDecayToyModel(obj)
      model=obj.makeModelObject();
      model.stoichMatrix=[1,-1];
      model.time=linspace(0,100,500);
      model.rxnRate=@(t,x,p)[p(1);p(2)*x(1)];
      model.parameters=[1,1];
      model.initialState=[0];
    end
    function model=birthDecayToyModel2D(obj)
      model=obj.makeModelObject();
      model.stoichMatrix=[1 -1  0  0
        0  0  1 -1];
      model.time=linspace(0,100,500);
      model.rxnRate=@(t,x,p)[p(1),p(2)*x(1),p(3),p(4)*x];
      model.parameters=[1,1,1,1];
      model.initialState=[0;0];
    end
    function model=unregulatedModelWithExperimentalInput(obj)
      model=obj.makeModelObject();
      model.name="Unregulated Model - Input is Experimental inpput [320 0 20]";
      model=obj.makeModelObject();
      model.stoichMatrix=[1,-1];
      model.parameters=[obj.ka obj.ga obj.u_exp];
      model.rxnRate=@(t,x,p)[p(1)+obj.ExperimentalInput(t,x,p(3:5)) ; p(2)*x(1)];
      model.initialState=[0];
      model.time=obj.time;
    end
    function model=unregulatedModelWithFitInput(obj)
      model=obj.makeModelObject();
      model.name="Unregulated Model - Input is Fit inpput";
      model.stoichMatrix=[1,-1];
      model.parameters=[obj.ka obj.ga obj.uFitReduced];
      model.rxnRate=@(t,x,p)[p(1)+obj.ExperimentalInput(t,x,p(3:5)) ; p(2)*x(1)];
      model.initialState=[0];
      model.time=obj.time;
    end
    function model=unregulatedModelWithExperimentalInputNoAlpha(obj)
      model=obj.makeModelObject();
      model.stoichMatrix=[1,-1];
      model.parameters=[obj.ka obj.ga obj.alpha];
      model.rxnRate=@(t,x,p)[p(1)+p(3)*obj.ExperimentalInput(t,x,obj.u) ; p(2)*x(1)];
      model.initialState=[0];
      model.time=obj.time;
    end
    function model=unregulatedModelWithFrequencyInput(obj,frequency,amplitude,offset)
      model=obj.makeModelObject();
      model.stoichMatrix=[1,-1];
      model.parameters=[obj.ka obj.ga frequency amplitude offset];
      model.rxnRate=@(t,x,p)[p(1)+obj.alpha*obj.frequencyInput(t,x,p(3:5)) ; p(2)*x(1)];
      model.initialState=[0];
      model.time=obj.time;
    end
    function model=unregulatedModelWithoutInput(obj)
      model=obj.makeModelObject();
      model.stoichMatrix=[1,-1];
      model.parameters=[obj.ka obj.ga];
      model.rxnRate=@(t,x,p)[p(1);p(2)*x(1)];
      model.initialState=[0];
      model.time=obj.time;
    end
    function model=unregulatedModelWithUniformLight(obj,lightLevel)
      model=obj.makeModelObject();
      model.stoichMatrix=[1,-1];
      model.parameters=[obj.ka obj.ga lightLevel];
      model.rxnRate=@(t,x,p)[(p(1)+obj.alpha*p(3))   ; p(2)*x(1)];
      model.initialState=[0];
      model.time=obj.time;
    end
    function model=unregulatedModelWithUniformLightSlowed(obj,lightLevel)
      model=obj.makeModelObject();
      model.stoichMatrix=[1,-1];
      model.parameters=[obj.ka obj.ga lightLevel];
      model.rxnRate=@(t,x,p)[(p(1)+obj.alpha*p(3))   ; p(2)*x(1)]/9.5;
      model.initialState=[0];
      model.time=obj.time;
    end
    function model=autoregulatedModelWithUniformLight(obj,lightInput)
      model=obj.makeModelObject();
      model.stoichMatrix=[1,-1];
      model.parameters=[obj.ko obj.be obj.mu obj.ka obj.ga, lightInput];
      model.rxnRate=@(t,x,p)[hill(x,p(1),p(2),p(3),p(4))+obj.alpha*p(6);linearDegredation(x,p(5))];
      model.initialState=[0];
      model.time=obj.time;
    end
    function model=autoregulatedModelWithUniformLightSlowed(obj,lightInput)
      model=obj.makeModelObject();
      model.stoichMatrix=[1,-1];
      model.parameters=[obj.ko obj.be obj.mu obj.ka obj.ga, lightInput];
      model.rxnRate=@(t,x,p)[hill(x,p(1),p(2),p(3),p(4))+obj.alpha*p(6);linearDegredation(x,p(5))]/9.5;
      model.initialState=[0];
      model.time=obj.time;
    end
    function model=autoregulatedModelWithoutInput(obj)
      model=obj.makeModelObject();
      model.stoichMatrix=[1,-1];
      model.parameters=[obj.ko obj.be obj.mu obj.ka obj.ga];
      model.rxnRate=@(t,x,p)[hill(x,p(1),p(2),p(3),p(4));linearDegredation(x,p(5))];
      model.initialState=[0];
      model.time=obj.time;
    end
    function model=autoregulatedModelWithFrequencyInput(obj,frequency,amplitude,offset)
      model=ModelPlugin();
      model.stoichMatrix=[1 -1];
      model.parameters=[obj.ko obj.be obj.mu obj.ka obj.ga, frequency, amplitude,offset];
      model.rxnRate=@(t,x,p)[hill(x,p(1),p(2),p(3),p(4))+obj.alpha*obj.frequencyInput(t,x,p(6:8)); p(5)*x(1)];
      model.initialState=[0];
      model.time=obj.time;
    end
    function model=khammashAutoregulatedFullModelWithControlInput(obj,controlInput)
      model=obj.khammashFullModel;
      model.parameters=[model.parameters obj.ko obj.be obj.mu obj.ka];
      model.rxnRate=@(t,x,p)[p(1);
        p(2)*x(1);
        p(1);
        p(2)*x(2);
        (p(3)+obj.alpha*controlInput)*x(1)*x(2);
        p(4)*x(3);
        p(5)*x(3);
        p(6)*x(3)*(obj.maxGenes-x(4));
        p(7)*x(4);
        hill(x(5),p(9),p(10),p(11),p(12))+p(8)*x(4);
        obj.ga*x(5)];
    end
    function model=fullAutoregModelWithControlInput(obj,controlInput)
      ControlInput2D=@(t,x)controlInput(x(5)+1,x(10)+1);
      model=obj.khammashFullModel;
      model.parameters=[model.parameters obj.ko obj.be obj.mu obj.ka];
      model.rxnRate=@(t,x,p)[
        p(1);
        (p(1)/20)*x(1);
        p(1)*3;
        (p(1)/20)*x(2);
        (p(3)+obk.alpha*ControlInput2D(t,x))*x(1)*x(2);
        p(4)*x(3);
        p(5)*x(3);
        p(6)*x(3)*(obj.maxGenes-x(4));
        p(7)*x(4);
        hill(x(5),p(9),p(10),p(11),p(12))+p(8)*x(4);
        obj.ga*x(5);
        p(1);
        (p(1)/20)*x(6);
        p(1)*3;
        (p(1)/20)*x(7);
        (p(3)+ControlInput2D(t,x))*x(6)*x(7);
        p(4)*x(8);
        p(5)*x(8);
        p(6)*x(8)*(obj.maxGenes-x(9));
        p(7)*x(9);
        hill(x(10),p(9),p(10),p(11),p(12))+p(8)*x(9);
        obj.ga*x(10)];
      model.stoichMatrix=[ 1  0  0  0  0;
        -1  0  0  0  0;
        0  1  0  0  0;
        0 -1  0  0  0;
        -1 -1  1  0  0;
        1  1 -1  0  0;
        0  0 -1  0  0
        0  0 -1  1  0;
        0  0  1 -1  0;
        0  0  0  0  1;
        0  0  0  0 -1]';
      model.stoichMatrix=[model.stoichMatrix,             zeros(size(model.stoichMatrix));
        zeros(size(model.stoichMatrix)), model.stoichMatrix];
      model.initialState=[1;1;0;0;0;1;1;0;0;0];
      model.time=obj.time;
    end
    function model=optimizedTwoCellModel(obj)
      model=obj.autoregulatedModelWithoutInput;
      load('data/controlers/FullControlerAutoregulatedModelControler');
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
          R(k)=(hill(x(k),p(1),p(2),p(3),p(4))+obj.alpha*input(t,x));
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
          R(k)=p(1)+obj.alpha*input(x(1)+1);
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
          R(k)=p(1)+obj.alpha*input(x(ind)+1);
        end
        for k=1:N
          R(end+1)=linearDegredation(x(k),p(2));
        end
      end
    end
    function model=simple2by2Model(obj)
      model=obj.makeModelObject();
      model.rxnRate=@(t,x,p)[p(1)+exp(-p(5)*t);p(2)*x(1);p(3)+exp(-p(6)*t);p(4)*x(2)];
      model.time=linspace(0,100,100);
      model.stoichMatrix=[-1  1  0  0;
        0  0  1 -1];
      model.parameters=[1 1 1 1 0 0];
      model.initialState=[0 0];
    end
    function model=autoRegulatedModelWith1DMeanInput(obj,controler)
      model=obj.makeModelObject();
      model.stoichMatrix=[1,-1];
      model.parameters=[obj.ko obj.be obj.mu obj.ka obj.ga];
      model.rxnRate=@(t,x,p)[hill(x,p(1),p(2),p(3),p(4))+obj.alpha*controler(mean(x(2:end))+1);linearDegredation(x,p(5))];
      model.initialState=[0];
      model.time=obj.time;
    end
    function model=autoRegulatedModelWith2DMeanInput(obj,controler)
      model=obj.makeModelObject();
      model.stoichMatrix=[1,-1];
      model.parameters=[obj.ko obj.be obj.mu obj.ka obj.ga];
      model.rxnRate=@(t,x,p)[hill(x,p(1),p(2),p(3),p(4))+obj.alpha*controler(mean(x(2:end))+1);linearDegredation(x,p(5))];
      model.initialState=[0];
      model.time=obj.time;
    end
    function model=nCellAutoregulatedSwapModel(obj,numCells,numSwaps,input,time)
      model=obj.nCellAutoregulatedModel(numCells);
      model.time=time;
      model.rxnRate=@(t,x,p)RateEq(t,x,p);
      function R=RateEq(t,x,p)
        tVec=linspace(time(1),time(end),numSwaps+1);
        tVec=tVec(1:(end-1));
        ind=find(tVec<=t,numCells,'last');
        ind=ind(end);
        ind=mod(ind-1,numCells)+1;
        for k=1:numCells
          R(k)=(hill(x(k),p(1),p(2),p(3),p(4))+obj.alpha*input(x(ind)+1));
        end
        for k=1:numCells
          R(end+1)=linearDegredation(x(k),p(5));
        end
      end
    end
    function model=twoCellAutoregulatedSwapModel(obj,numSwaps,input,time)
      numCells=2;
      model=obj.nCellAutoregulatedModel(numCells);
      model.time=time;
      model.rxnRate=@(t,x,p)RateEq(t,x,p);
      function R=RateEq(t,x,p)
        tVec=linspace(time(1),time(end),numSwaps+1);
        tVec=tVec(1:(end-1));
        ind=find(tVec<=t,numCells,'last');
        ind=ind(end);
        ind=[mod(ind-1,numCells)+1,mod(ind,numCells)+1];
        for k=1:numCells
          R(k)=(hill(x(k),p(1),p(2),p(3),p(4))+obj.alpha*input(x(ind(1))+1,x(ind(2))+1));
        end
        for k=1:numCells
          R(end+1)=linearDegredation(x(k),p(5));
        end
      end
    end
    function model=buildAutoregulatedFrequencyResponseModel(...
        obj,freq,amp,dc,numCells,time)
      input=@(t,x)obj.frequencyInput(t,x,[freq,amp,dc]);
      model=obj.nCellAutoregulatedModel(numCells,input);
      model.time=time;
    end
    function model=twoCellAutoregulatedPredictiveModel(obj,numSwaps,input,time)
      numCells=2;
      model=obj.nCellAutoregulatedModel(numCells);
      model.time=time;
      model.rxnRate=@(t,x,p)RateEq(t,x,p);
      function R=RateEq(t,x,p)
        tVec=linspace(time(1),time(end),numSwaps+1);
        tVec=tVec(1:(end-1));
        ind=find(tVec<=t,numCells,'last');
        ind=ind(end);
        ind=[mod(ind-1,numCells)+1,mod(ind,numCells)+1];
        for k=1:numCells
          R(k)=(hill(x(k),p(1),p(2),p(3),p(4))+obj.alpha*input(x(ind(1))+1,x(ind(2))+1));
        end
        for k=1:numCells
          R(end+1)=linearDegredation(x(k),p(5));
        end
      end
      function prediction=prediction(probability)
        x=[1:length(probability)]-1
        mean=x'*P;
        prediction=mean
      end
    end
    function model=fullModel(obj)
      model=obj.makeModelObject();
      model.stoichMatrix=[ 1  0  0  0  0;  %p(1)
        -1  0  0  0  0;  %p(2)*x(1);
        0  1  0  0  0;  %3*p(1);
        0 -1  0  0  0;  %p(2)*x(2);
        -1 -1  1  0  0;  %p(3)*x(1)*x(2);
        1  1 -1  0  0;  %p(4)*x(3);
        0  0 -1  0  0;  %p(5)*x(3);
        0  0 -1  1  0;  %p(6)*x(3)*(obj.maxGenes-x(4));
        0  0  1 -1  0;  %p(7)*x(4);
        0  0  0  0  1;  %p(8)*x(4);
        0  0  0  0 -1]';  %obj.ga*x(5)
      model.parameters=obj.fullModelParameters;
      model.rxnRate=@(t,x,p)[p(1);
        p(2)*x(1);
        3*p(1);
        p(2)*x(2);
        p(3)*x(1)*x(2);
        p(4)*x(3);
        p(5)*x(3);
        p(6)*x(3)*(obj.maxGenes-x(4));
        p(7)*x(4);
        p(8)*x(4);
        obj.ga*x(5)];
      model.initialState=[0;0;0;0;0];
      model.time=obj.time;
    end
    function model=khammashFullAutoModelWithControlInput(obj,controlInput,scale)
      load data/parameters/khammashFullModelWithLightInputFixedU
      controlInput2D=@(t,x)controlInput(x(5)+1,x(10)+1);
      model=obj.khammashFullModelWithLightInputFixedU;
      model.parameters=[parameters obj.ko obj.be obj.mu obj.ka];
      model.rxnRate=@(t,x,p)[
        p(1);
        (p(1)/20)*x(1);
        3*p(1);
        (p(1)/20)*x(2);
        (p(3)*controlInput2D(t,x))*x(1)*x(2);
        p(4)*x(3);
        (p(5))*x(3);
        p(6)*x(3)*(obj.maxGenes-x(4));
        (p(7))*x(4);
        p(8)*x(4)+hill(x(5),p(9),p(10),p(11),p(12));
        obj.ga*x(5);
        p(1);
        (p(1)/20)*x(6);
        3*p(1);
        (p(1)/20)*x(7);
        (p(3)*controlInput2D(t,x))*x(6)*x(7);
        p(4)*x(8);
        (p(5))*x(8);
        p(6)*x(8)*(obj.maxGenes-x(9));
        (p(7))*x(9);
        p(8)*x(9)+hill(x(10),p(9),p(10),p(11),p(12));
        obj.ga*x(10)];
      model.initialState=[model.initialState;model.initialState];
      model.stoichMatrix=[model.stoichMatrix,zeros(size(model.stoichMatrix));zeros(size(model.stoichMatrix)),model.stoichMatrix]
    end
    function model=fullModelWithLightInput(obj,input)
      model=obj.fullModel;
      model.parameters=obj.fullModelParameters;
      model.rxnRate=@(t,x,p)[
        p(1);
        (p(2))*x(1);
        3*p(1);
        (p(2))*x(2);
        (p(3)*input)*x(1)*x(2);
        p(4)*x(3);
        (p(5))*x(3);
        p(6)*x(3)*(obj.maxGenes-x(4));
        (p(7))*x(4);
        p(8)*x(4);
        obj.ga*x(5)];
    end
    function model=fullModelWithExperimentalInput(obj)
      model=obj.fullModel;
      model.parameters=obj.fullModelParameters;
      model.rxnRate=@(t,x,p)[p(1);
        (p(2))*x(1);
        3*p(1);
        (p(2))*x(2);
        (p(3)*obj.ExperimentalInput(t,x,obj.u_exp))*x(1)*x(2);
        p(4)*x(3);
        (p(5))*x(3);
        p(6)*x(3)*(obj.maxGenes-x(4));
        (p(7))*x(4);
        p(8)*x(4);
        obj.ga*x(5)];
    end
    function model=fullModelWithFitInput(obj)
      model=obj.fullModel;
      model.parameters=[obj.fullModelParameters,obj.uFitFull];
      model.rxnRate=@(t,x,p)[p(1);
        p(2)*x(1);
        3*p(1);
        p(2)*x(2);
        (p(3)*obj.ExperimentalInput(t,x,p(9:11)))*x(1)*x(2);
        p(4)*x(3);
        p(5)*x(3);
        p(6)*x(3)*(obj.maxGenes-x(4));
        p(7)*x(4);
        p(8)*x(4);
        obj.ga*x(5)];
    end
    function model=fullModelFrequencyInput(obj,frequency,amplitude,dc)
      model=obj.fullModelWithExperimentalInput
      input=@(t,x)amplitude*sin(2*pi*frequency*t)+dc
      model.rxnRate=@(t,x,p)[
        p(1);
        (p(2))*x(1);
        3*p(1);
        (p(2))*x(2);
        (p(3)*input(t,x))*x(1)*x(2);
        p(4)*x(3);
        (p(5))*x(3);
        p(6)*x(3)*(obj.maxGenes-x(4));
        (p(7))*x(4);
        p(8)*x(4);
        obj.ga*x(5)];
    end
    function model=fullAutoModelWithFrequencyInput(obj,frequency,amplitude,dc)
      model=obj.fullModelWithExperimentalInput;
      model.parameters(9:12)=[obj.ko obj.be obj.mu obj.ka];
      model.rxnRate=@(t,x,p)[
        p(1);
        (p(1)/20)*x(1);
        3*p(1);
        (p(1)/20)*x(2);
        (p(3)*(amplitude*sin(2*pi*frequency*t)+dc))*x(1)*x(2);
        p(4)*x(3);
        (p(5))*x(3);
        p(6)*x(3)*(obj.maxGenes-x(4));
        (p(7))*x(4);
        p(8)*x(4)+hill(x(5),p(9),p(10),p(11),p(12));
        obj.ga*x(5)];
    end
    function model=fullAutoModelWithUniformLight(obj,input)
      model=obj.fullModelWithExperimentalInput;
      model.parameters(9:13)=[obj.ko obj.be obj.mu obj.ka input];
      model.rxnRate=@(t,x,p)[
        p(1);
        (p(1)/20)*x(1);
        3*p(1);
        (p(1)/20)*x(2);
        (p(3)*p(13))*x(1)*x(2);
        p(4)*x(3);
        (p(5))*x(3);
        p(6)*x(3)*(obj.maxGenes-x(4));
        (p(7))*x(4);
        p(8)*x(4)+hill(x(5),p(9),p(10),p(11),p(12));
        obj.ga*x(5)];
    end
    function model=fullModelWithUniformLight(obj,input)
      model=obj.fullModel;
      model.parameters(9)=[input];
      model.rxnRate=@(t,x,p)[
        p(1);
        (p(2))*x(1);
        3*p(1);
        (p(2)/20)*x(2);
        (p(3)*p(9))*x(1)*x(2);
        p(4)*x(3);
        (p(5))*x(3);
        p(6)*x(3)*(obj.maxGenes-x(4));
        (p(7))*x(4);
        p(8)*x(4);
        obj.ga*x(5)];
    end
    function model=calibratedFullAutoModel(obj,calibration)
      model=obj.fullAutoModel;
      model.parameters(13)=1;
      model.rxnRate=@(t,x,p)[
        p(1);
        (p(1)/20)*x(1);
        3*p(1);
        (p(1)/20)*x(2);
        (p(3)*calibrate(p(13),calibration))*x(1)*x(2);
        p(4)*x(3);
        (p(5))*x(3);
        p(6)*x(3)*(obj.maxGenes-x(4));
        (p(7))*x(4);
        p(8)*x(4)+hill(x(5),p(9),p(10),p(11),p(12));
        obj.ga*x(5)];
      function output=calibrate(input,calibration)
        if input<=calibration(1,1)
          output=calibration(2,1);
        elseif input>=(calibration(1,end))
          output=calibration(2,end);
        else
          output=interp1(calibration(1,:),calibration(2,:),input);
        end
      end
    end
    function model=calibratedFullModel(obj,calibration)
      model=obj.fullModelWithUniformLight(0);
      model.rxnRate=@(t,x,p)[p(1);
        (p(2))*x(1);
        3*p(1);
        (p(2)/20)*x(2);
        (p(3)*calibrate(p(9),calibration))*x(1)*x(2);
        p(4)*x(3);
        (p(5))*x(3);
        p(6)*x(3)*(obj.maxGenes-x(4));
        (p(7))*x(4);
        p(8)*x(4);
        obj.ga*x(5)];
      function output=calibrate(input,calibration)
        if input<=calibration(1,1)
          output=calibration(2,1);
        elseif input>=(calibration(1,end))
          output=calibration(2,end);
        else
         output=interp1(calibration(1,:),calibration(2,:),input);
        end
      end
    end
    function model=fullAutoModel(obj)
      model=obj.fullModelWithFitInput;
      model.parameters(9:12)=[obj.ko obj.be obj.mu obj.ka];
      model.rxnRate=@(t,x,p)[
        p(1);
        (p(2))*x(1);
        3*p(1);
        (p(2))*x(2);
        (p(3))*x(1)*x(2);
        p(4)*x(3);
        (p(5))*x(3);
        p(6)*x(3)*(obj.maxGenes-x(4));
        (p(7))*x(4);
        p(8)*x(4)+hill(x(5),p(9),p(10),p(11),p(12));
        obj.ga*x(5)];
    end
    function model=calibratedFullAutoModelWithFrequencyInput(obj,freq,amp,dc)
      layer=DataLayer();
      data=layer.get('CalibrationCurveAutoregulatedFullReduced');
      calibration=data.calibration;
      model=obj.fullAutoModel;
      model.parameters(13)=1;
      model.rxnRate=@(t,x,p)[
        p(1);
        (p(1)/20)*x(1);
        3*p(1);
        (p(1)/20)*x(2);
        (p(3)*calibrate(amp*sin(2*pi*freq*t)+dc,calibration))*x(1)*x(2);
        p(4)*x(3);
        (p(5))*x(3);
        p(6)*x(3)*(obj.maxGenes-x(4));
        (p(7))*x(4);
        p(8)*x(4)+hill(x(5),p(9),p(10),p(11),p(12));
        obj.ga*x(5)];
      function output=calibrate(input,calibration)
        if input<=calibration(1,1)
          output=calibration(2,1);
        elseif input>=(calibration(1,end))
          output=calibration(2,end);
        else
          output=interp1(calibration(1,:),calibration(2,:),input);
        end
      end
    end
    function model=fullAutoModelWith2dControl(obj,controlInput)
      model=obj.fullAutoModel;
      model.initialState=[model.initialState;model.initialState]
      model.stoichMatrix=[model.stoichMatrix,zeros(size(model.stoichMatrix));
        zeros(size(model.stoichMatrix)),model.stoichMatrix];
      model.rxnRate=@(t,x,p)[
        p(1);
        (p(1)/20)*x(1);
        3*p(1);
        (p(1)/20)*x(2);
        (p(3)*controlInput(x(5)+1,x(10)+1))*x(1)*x(2);
        p(4)*x(3);
        (p(5))*x(3);
        p(6)*x(3)*(obj.maxGenes-x(4));
        (p(7))*x(4);
        p(8)*x(4)+hill(x(5),p(9),p(10),p(11),p(12));
        obj.ga*x(5);
        p(1);
        (p(1)/20)*x(6);
        3*p(1);
        (p(1)/20)*x(7);
        (p(3)*controlInput(x(5)+1,x(10)+1))*x(6)*x(7);
        p(4)*x(8);
        (p(5))*x(8);
        p(6)*x(8)*(obj.maxGenes-x(4));
        (p(7))*x(9);
        p(8)*x(9)+hill(x(10),p(9),p(10),p(11),p(12));
        obj.ga*x(10)];
    end
    function model=fullUnregModelWith2dControl(obj,controlInput)
      model=obj.fullAutoModel;
      model.initialState=[model.initialState;model.initialState]
      model.stoichMatrix=[model.stoichMatrix,zeros(size(model.stoichMatrix));
        zeros(size(model.stoichMatrix)),model.stoichMatrix];
      model.rxnRate=@(t,x,p)[
        p(1);
        (p(1)/20)*x(1);
        3*p(1);
        (p(1)/20)*x(2);
        (p(3)*controlInput(x(5)+1,x(10)+1))*x(1)*x(2);
        p(4)*x(3);
        (p(5))*x(3);
        p(6)*x(3)*(obj.maxGenes-x(4));
        (p(7))*x(4);
        p(8)*x(4);
        obj.ga*x(5);
        p(1);
        (p(1)/20)*x(6);
        3*p(1);
        (p(1)/20)*x(7);
        (p(3)*controlInput(x(5)+1,x(10)+1))*x(6)*x(7);
        p(4)*x(8);
        (p(5))*x(8);
        p(6)*x(8)*(obj.maxGenes-x(4));
        (p(7))*x(9);
        p(8)*x(9);
        obj.ga*x(10)];
    end
    function model=calibratedFullAutoModelWith2dControl(obj,controlInput)
      model=obj.fullAutoModel;
      model.initialState=[model.initialState;model.initialState]
      model.stoichMatrix=[model.stoichMatrix,zeros(size(model.stoichMatrix));
        zeros(size(model.stoichMatrix)),model.stoichMatrix];
      load('data/file/makeAutoModelCalibration/calibration')
      calibrationFS=calibrationFS;
      model.rxnRate=@(t,x,p)[
        p(1);
        (p(1)/20)*x(1);
        3*p(1);
        (p(1)/20)*x(2);
        (p(3)*cinput(x+1))*x(1)*x(2);
        p(4)*x(3);
        (p(5))*x(3);
        p(6)*x(3)*(obj.maxGenes-x(4));
        (p(7))*x(4);
        p(8)*x(4)+hill(x(5),p(9),p(10),p(11),p(12));
        obj.ga*x(5);
        p(1);
        (p(1)/20)*x(6);
        3*p(1);
        (p(1)/20)*x(7);
        (p(3)*cinput(x+1))*x(6)*x(7);
        p(4)*x(8);
        (p(5))*x(8);
        p(6)*x(8)*(obj.maxGenes-x(4));
        (p(7))*x(9);
        p(8)*x(9)+hill(x(10),p(9),p(10),p(11),p(12));
        obj.ga*x(10)];
      function output=cinput(x)
        input=@(t)amp*sin(2*pi*freq*t)+dc;
        output=interp1(calibrationFS(1,:),calibrationFS(2,:),controlInput(x(5)+1,x(10)+1));
        if isnan(output)
          output=calibrationFS(2,end);
        end
      end
    end
    function model=fullAutoregulatedModelNCellSwap(obj,controlInput,numSwaps,numCells,timeChange,relaxationTime)
      model=obj.fullAutoModelWithUniformLight();
      model.parameters(13)=1;
      inputsBlkDiag=cell(1,numCells);
      for i=1:length(inputsBlkDiag)
        inputsBlkDiag{i}=model.stoichMatrix;
      end
      model.stoichMatrix=blkdiag(inputsBlkDiag{:});
      m=length(model.initialState);
      model.initialState=repmat(model.initialState,numCells,1);
      individualRate=@model.rxnRate;
      model.rxnRate=@reactionRate;
      model.time=-relaxationTime:.5:(timeChange*numSwaps);
      function rate=reactionRate(t,x,p)
        targetCellSpeciesIndex=5*(floor(t/timeChange)+1);
        if targetCellSpeciesIndex<5
          targetCellSpeciesIndex=5;
        end
        input=controlInput(x(targetCellSpeciesIndex)+1);
        rate=zeros(11*numCells,1);
        for i=1:numCells
          p(end)=input;
          rates=individualRate(t,x((1:5)+5*(i-1)),p);
          rate((1:11)+(i-1)*11)=[rates];
        end
      end
    end
    function model=twoCellSwapInitialCondition(obj,controlInput,condition)
      model=obj.fullAutoModelWithInput();
      model.parameters(13)=1;
      numCells=2;
      numSwaps=4;
      timeEnd=2000;
      relaxationTime=500;
      
      inputsBlkDiag=cell(1,numCells);
      for i=1:length(inputsBlkDiag)
        inputsBlkDiag{i}=model.stoichMatrix;
      end
      model.stoichMatrix=blkdiag(inputsBlkDiag{:});
      m=length(model.initialState);
      model.initialState=repmat(model.initialState,numCells,1);
      individualRate=@model.rxnRate;
      model.rxnRate=@reactionRate;
      model.time=-relaxationTime:.5:timeEnd;
      model.parameters={model.parameters,controlInput,timeEnd,numCells,condition,individualRate};
      function rate=reactionRate(t,x,v)
        p=v{1};
        controlerInput=v{2};
        swapTimeChange=v{3};
        numCell=v{4};
        conditions=v{5};
        individualRates=v{6};
        targetCellSpeciesIndex=5;
        input=controlerInput(x(targetCellSpeciesIndex)+1);
        rate=zeros(11*numCell,1);
        if t<0
          p(13:14)=conditions;
        else
          p(13:14)=input;
        end
        rate=[p(1);
          (p(2))*x(1);
          3*p(1);
          (p(2))*x(2);
          (p(3)*p(13))*x(1)*x(2);
          p(4)*x(3);
          (p(5))*x(3);
          p(6)*x(3)*(obj.maxGenes-x(4));
          (p(7))*x(4);
          p(8)*x(4)+hill(x(5),p(9),p(10),p(11),p(12));
          obj.ga*x(5)
          p(1);
          (p(2))*x(6);
          3*p(1);
          (p(2))*x(7);
          (p(3)*p(14))*x(6)*x(7);
          p(4)*x(8);
          (p(5))*x(8);
          p(6)*x(8)*(obj.maxGenes-x(9));
          (p(7))*x(9);
          p(8)*x(9)+hill(x(10),p(9),p(10),p(11),p(12));
          obj.ga*x(10)];
        %rates=individualRates(t,x((1:5)+5*(k-1)),p);
      end
    end
    function model=mixModelFull(obj)
      model=obj.makeModelObject();
      model.stoichMatrix=[ 1  0  0;
                          -1  0  0;
                          -1  1  0;
                           1 -1  0
                           0  0  1;
                           0  0 -1]';
                           
      model.rxnRate=@(t,x,p)[p(1)*[p(2)-x(1)]*[p(3)-x(1)];
               p(4)*x(1);
               p(5)*x(1)*(p(6)-x(2));
               p(7)*x(2);
               p(8)*x(2);
               obj.ga*x(3)];
      model.parameters=[1 1 1 1 1 1 1 1];
      model.name="Mixed Model - Full Version";
      model.initialState=[0 0 0]';
      model.time=obj.time;
    end
    function model=mixModelFullExperimentalInput(obj)
      model=obj.makeModelObject();
      model.stoichMatrix=[ 1  0  0;
                          -1  0  0;
                          -1  1  0;
                           1 -1  0
                           0  0  1;
                           0  0 -1]';
                           
      model.rxnRate=@(t,x,p)[obj.ExperimentalInput(t,x,obj.uFitFull)*[p(2)-x(1)]*[p(3)-x(1)];
               p(4)*x(1);
               p(5)*x(1)*(p(6)-x(2));
               p(7)*x(2);
               p(8)*x(2);
               obj.ga*x(3)];
      model.parameters=[1 1 1 1 1 1 1 1];
      model.name="Mixed Model - Full Version";
      model.initialState=[0 0 0]';
      model.time=obj.time;
    end
    function model=speedFullModel(obj,speed)
      model=obj.fullModel;
      model.rxnRate=@(t,x,p)[
        speed*p(1);
        speed*p(2)*x(1);
        speed*3*p(1);
        speed*p(2)*x(2);
        speed*p(3)*x(1)*x(2);
        speed*p(4)*x(3);
        speed*p(5)*x(3);
        speed*p(6)*x(3)*(obj.maxGenes-x(4));
        speed*p(7)*x(4);
        p(8)*x(4);
        obj.ga*x(5)];
    end
    function model=speedFullModelWithUniformLight(obj,speed,light)
      model=obj.fullModel;
      model.rxnRate=@(t,x,p)[
        speed*p(1);
        speed*p(2)*x(1);
        speed*3*p(1);
        speed*p(2)*x(2);
        speed*light*x(1)*x(2);
        speed*p(4)*x(3);
        speed*p(5)*x(3);
        speed*p(6)*x(3)*(obj.maxGenes-x(4));
        speed*p(7)*x(4);
        p(8)*x(4);
        obj.ga*x(5)];
    end
    function model=speedFullModelFitInput(obj,speed)
      model=obj.fullModel;
      model.parameters=[obj.fullModelParameters,obj.uFitFull];
      model.rxnRate=@(t,x,p)[
        speed*p(1);
        speed*p(2)*x(1);
        speed*3*p(1);
        speed*p(2)*x(2);
        speed*(p(3)*obj.ExperimentalInput(t,x,p(9:11)))*x(1)*x(2);
        speed*p(4)*x(3);
        speed*p(5)*x(3);
        speed*p(6)*x(3)*(obj.maxGenes-x(4));
        speed*p(7)*x(4);
        p(8)*x(4);
        obj.ga*x(5)];
    end
  end
end
