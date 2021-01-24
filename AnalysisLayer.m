classdef AnalysisLayer
  methods(Static)
    function data=TestFile(obj)
      data.string="TEST";
    end
    function data=AnalysisODEFrequencySeparation_ReducedModels()
      build=ModelFactory;
      wRange=[0.01 0.001];
      deltaT=2./wRange;
      tStep=deltaT/80;
      amp=.2/build.alpha;
      dc=.2/build.alpha;%dc > amp at all times!!
      numCycles=1000;
      initialConditions={[0],[40]};
      for i=1:length(wRange)
        for j=1:length(initialConditions)
          model{i,j}=build.autoregulatedModelWithFrequencyInput(wRange(i),amp,dc);
          model{i,j}.time=linspace(0,tStep(i)*numCycles,tStep(i)*numCycles);
          model{i,j}.initialState=initialConditions{j};
          ode{i,j}=SolverODE(model{i,j});
          trajectory{i,j}=ode{i,j}.run();
        end
      end
      data.trajectory_LIC_w0p01=trajectory{1,1};
      data.trajectory_LIC_w0p0001=trajectory{2,1};
      data.trajectory_HIC_w0p01=trajectory{1,2};
      data.trajectory_HIC_w0p0001=trajectory{2,2};
      data.wRange=wRange;
      freq=wRange(1);
      input=@(t,x,p)build.frequencyInput(t,x,p);
      timeRange=linspace(0,2/freq,100)
      data.input=input(timeRange,0,[freq amp dc]);
      data.time=2*timeRange/max(timeRange);
      data.upperbound=145*ones(size(timeRange));
      data.lowerbound=90*ones(size(timeRange));
    end
    function data=AnalysisODEFrequencySeparation_FullModels()
      builder=ModelFactoryTestModels;
      wRange=logspace(-4,-2,3);
      tSteadyState=6000;
      deltaT=2./wRange;
      tStep=deltaT/80;
      amp=.2/builder.alpha;
      dc=.2/builder.alpha;%dc > amp at all times!!
      pBucket=ParallelMenu;
      func={};
      for j=1:3
        for i=1:length(wRange)
          tEnd=3./wRange(i);
          time=[0:tStep(i):(tEnd)];
          ode{i}=SolverODE;
          ode{i}.integrator=@ode23;
          switch j
            case 1
              model{i}=builder.fullAutoModelWithFrequencyInput(wRange(i),amp,dc);
              initialmodel{i}=builder.fullAutoModelWithFrequencyInput(wRange(i),0,dc);
            case 2
              model{i}=builder.autoregulatedModelWithFrequencyInput(wRange(i),amp,dc);
              initialmodel{i}=builder.autoregulatedModelWithFrequencyInput(wRange(i),0,dc);
            case 3
              model{i}=builder.calibratedFullAutoModelWithFrequencyInput(wRange(i),amp,dc);
              initialmodel{i}=builder.calibratedFullAutoModelWithFrequencyInput(wRange(i),0,2*dc);
          end
          initialmodel{i}.time=0:3500;
          initialOde{i}=SolverODE(initialmodel{i});
          traj=initialOde{i}.run;
          initialState=traj.state(:,end);
          ode{i}.model=model{i};
          ode{i}.model.time=time;
          ode{i}.model.initialState=initialState;
          func{end+1}=@()ode{i}.run;
          pBucket=pBucket.add(func{end},{});
        end
      end
      trajectories=pBucket.run();
      ind=1;
      for j=1:3
        for i=1:length(wRange)
          data{i,j}=trajectories{ind};
          ind=ind+1;
        end
      end
    end 
    function data=AnalysisODEFrequencyOmegaCrit_ReducedModel()
      build=ModelFactory;
      freq=linspace(0.0043525,0.0043522,2);
      T=1./freq;
      amp=[.21]/build.alpha;%.315
      dc=.210/build.alpha;
      initialState=[0, 40];
      time=[0 1000];
      steps=6500;%500000
      menu=ParallelMenu;
      for i=1:length(freq)
        time=[0 200*T(i)];
        for j=1:length(amp)
          for k=1:length(initialState)
            menu=menu.attachTicketItem(@analyzeAutoregulatedFrequency,{freq(i),amp(j),dc,initialState(k),linspace(time(1),time(2),steps)});
          end
        end
      end
      trajectory=menu.run;
      data.wHigh_LIC=trajectory{1};
      data.wHigh_HIC=trajectory{2};
      data.wLow_LIC=trajectory{3};
      data.wLow_HIC=trajectory{4};
      data.frequency=freq;
      data.amp=amp;
      data.dc=dc;
      data.initialState=initialState;
      data.time=time;
      function data=analyzeAutoregulatedFrequency(frequency,intensity,offset,state,time)
        build=ModelFactory;
        model=build.autoregulatedModelWithFrequencyInput(frequency,intensity,offset);
        solver=SolverODE(model);
        solver.model.time=time;
        solver.model.initialState=state;
        data=solver.run();
      end
    end
    function data=AnalysisODESSAFrequency_ReducedModel()
      build=ModelFactory;
      freq=0.005;
      amp=[.21]/build.alpha;%.315
      dc=.210/build.alpha;
      initialState=[0 40];
      time=[0 5000];
      steps=6500;%500000
      data.ODE_HIC=analyzeODE_AutoregulatedReducedModel(freq,amp,dc,initialState(2),linspace(time(1),time(2),steps));
      data.ODE_LIC=analyzeODE_AutoregulatedReducedModel(freq,amp,dc,initialState(1),linspace(time(1),time(2),steps));
      data.SSA=analyzeSSA_AutoregulatedReducedModel(freq,amp,dc,initialState(1),linspace(time(1),time(2),steps));
      data.frequency=freq;
      data.amp=amp;
      data.dc=dc;
      data.initialState=initialState;
      data.time=time;
      data.input=amp*sin(2*pi*freq*data.ODE_LIC.time)+dc;
      function data=analyzeODE_AutoregulatedReducedModel(frequency,intensity,offset,state,time);
        build=ModelFactory;
        model=build.autoregulatedModelWithFrequencyInput(frequency,intensity,offset);
        model.time=time;
        model.initialState=state;
        ode=SolverODE(model);
        data=ode.run();
      end
      function data=analyzeSSA_AutoregulatedReducedModel(frequency,intensity,offset,state,time);
        build=ModelFactory;
        model=build.autoregulatedModelWithFrequencyInput(frequency,intensity,offset);
        model.time=time;
        model.initialState=state;
        ode=SolverSSA(model);
        data=ode.run();
      end
    end
    function data=AnalysisFSPReducedModelControlPairs
      layer=DataLayer();
      layer.forceAnalysis=true;
      data.UU=layer.get('AnalysisFSPReducedModelControlPairs_UnregulatedUniform');
      data.UF=layer.get('AnalysisFSPReducedModelControlPairs_UnregulatedFull');
      data.AU=layer.get('AnalysisFSPReducedModelControlPairs_AutoregulatedUniform');
      data.AF=layer.get('AnalysisFSPReducedModelControlPairs_AutoregulatedFull');
      data.AR=layer.get('AnalysisFSPReducedModelControlPairs_AutoregulatedReduced');
    end
    function data=AnalysisFSPReduced_Flow_Joint_Marginal(model)
      flow=FlowField;
      dims=[50 50];
      fsp=TwoCellFSP(model,dims);
      data.target=[30 10];
      data.steadystate=fsp.getSteadyStateReshape();
      data.controlInput=model.controlInput;
      stepSize=4;
      [data.forcesX,data.forcesY]=flow.getSampleSpaceForces(fsp,stepSize);
      [data.sampleX,data.sampleY]=flow.getSampleSpace(fsp,stepSize);
      scorer=ProbabilityScore([50 50]);
      data.score=scorer.getScore(data.steadystate);
      data.stepSize=4;
    end
    function data=AnalysisFSPReducedModelControlPairs_UnregulatedUniform()
      factory=ModelFactory;
      layer=DataLayer();
      controls=layer.get('ControlInputs_ReducedModels');
      model=factory.unregulatedModelWithoutInput();
      model.controlInput=controls.UniformControlUnregulatedModelControler;
      data=AnalysisLayer.AnalysisFSPReduced_Flow_Joint_Marginal(model);
    end
    function data=AnalysisFSPReducedModelControlPairs_UnregulatedFull()
      factory=ModelFactory;
      layer=DataLayer();
      controls=layer.get('ControlInputs_ReducedModels');
      model=factory.unregulatedModelWithoutInput();
      model.controlInput=controls.FullControlUnregulatedModelControler;
      data=AnalysisLayer.AnalysisFSPReduced_Flow_Joint_Marginal(model);
    end
    function data=AnalysisFSPReducedModelControlPairs_AutoregulatedUniform()
      factory=ModelFactory;
      layer=DataLayer();
      controls=layer.get('ControlInputs_ReducedModels');
      model=factory.autoregulatedModelWithoutInput();
      model.controlInput=controls.UniformControlAutoregulatedModelControler;
      data=AnalysisLayer.AnalysisFSPReduced_Flow_Joint_Marginal(model);
    end
    function data=AnalysisFSPReducedModelControlPairs_AutoregulatedFull()
      factory=ModelFactory;
      layer=DataLayer();
      controls=layer.get('ControlInputs_ReducedModels');
      model=factory.autoregulatedModelWithoutInput();
      model.controlInput=controls.FullControlAutoregulatedModelControler;
      data=AnalysisLayer.AnalysisFSPReduced_Flow_Joint_Marginal(model);
    end
    function data=AnalysisFSPReducedModelControlPairs_AutoregulatedReduced()
      factory=ModelFactory;
      layer=DataLayer();
      controls=layer.get('ControlInputs_ReducedModels');
      model=factory.autoregulatedModelWithoutInput();
      model.controlInput=controls.ReducedControlAutoregulatedModelControler;
      data=AnalysisLayer.AnalysisFSPReduced_Flow_Joint_Marginal(model);
    end
    function data=AnalysisSSAFullModelControlPairs()
      clear all
      addpath(genpath('utility'))
      build=ModelFactoryTestModels;
      dataLayer=DataLayer();
      controllers=dataLayer.get('ControlInputs_FullModels');
      controlInput=controllers.FullControlAutoregulatedModelControler_FMCalibration;
      controlInput(300,300)=0;
      model=build.fullAutoModelWith2dControl(controlInput);
      [time,state]=simulate(controlInput,model);
      data.FullControlAutoregulatedModelControler.time=time;
      data.FullControlAutoregulatedModelControler.state=state;
      [data.FullControlAutoregulatedModelControler.steadystate,data.FullControlAutoregulatedModelControler.score]=getJoint(state);
      data.FullControlAutoregulatedModelControler.target=[30,10];
      
      controlInput=controllers.UniformControlAutoregulatedModelControler_FMCalibration;
      controlInput(300,300)=0;
      model=build.fullAutoModelWith2dControl(controlInput);
      [time,state]=simulate(controlInput,model);
      data.UniformControlAutoregulatedModelControler.time=time;
      data.UniformControlAutoregulatedModelControler.state=state;
      [data.UniformControlAutoregulatedModelControler.steadystate,data.UniformControlAutoregulatedModelControler.score]=getJoint(state);
      data.UniformControlAutoregulatedModelControler.target=[30,10];
      
      controlInput=controllers.FullControlUnregulatedModelControler_FMCalibration;
      controlInput(300,300)=0;
      model=build.fullUnregModelWith2dControl(controlInput);
      [time,state]=simulate(controlInput,model);
      data.FullControlUnregulatedModelControler.time=time;
      data.FullControlUnregulatedModelControler.state=state;
      [data.FullControlUnregulatedModelControler.steadystate,data.FullControlUnregulatedModelControler.score]=getJoint(state);
      data.FullControlUnregulatedModelControler.target=[30,10];
      
      controlInput=controllers.UniformControlUnregulatedModelControler_FMCalibration;
      controlInput(300,300)=0;
      model=build.fullUnregModelWith2dControl(controlInput);
      [time,state]=simulate(controlInput,model);
      data.UniformControlUnegulatedModelControler.time=time;
      data.UniformControlUnegulatedModelControler.state=state;
      [data.UniformControlUnegulatedModelControler.steadystate,data.UniformControlUnegulatedModelControler.score]=getJoint(state);
      data.UniformControlUnegulatedModelControler.target=[30,10];
      
      controlInput=controllers.ReducedControlAutoregulatedModelControler_FMCalibration;
      controlInput(300,300)=0;
      model=build.fullAutoModelWith2dControl(controlInput);
      [time,state]=simulate(controlInput,model);
      data.ReducedControlAutoregulatedModelControler.time=time;
      data.ReducedControlAutoregulatedModelControler.state=state;
      [data.ReducedControlAutoregulatedModelControler.steadystate,data.ReducedControlAutoregulatedModelControler.score]=getJoint(state);
      data.ReducedControlAutoregulatedModelControler.target=[30 10];
      function [time,state]=simulate(controlInput,model)
        controlInput(300,300)=0;
        model.controlInput=controlInput;
        ssa=SolverSSA(model);
        ssa.integrator=SSAIntegratorParsed;
        tEnd=10000;
        ssa.model.time=linspace(0,tEnd,tEnd*2+1);
        bucket=ParallelMenu;
        ssa.integrator.verbose=true;
        N=24;
        maxNumCompThreads(N);
        for i=1:N
          bucket=bucket.add(@ssa.run,{});
        end
        trajectory=bucket.run;
        for i=1:N
          time{i}=trajectory{i}.node{1}.time;
          state{i}=trajectory{i}.node{1}.state;
        end
      end
      function [Pxy,score]=getJoint(state)
        trim=5000;
        stateX=[];
        stateY=[];
        for i=1:length(state)
          stateX=[stateX,state{i}(5,trim:end)];
          stateY=[stateY,state{i}(10,trim:end)];
        end
        Pxy=zeros(80);
        for i=1:length(stateX)
          Pxy(stateX(i)+1,stateY(i)+1)=Pxy(stateX(i)+1,stateY(i)+1)+1;
        end
        Pxy=Pxy./sum(sum(Pxy));
        scorer=ProbabilityScore([80 80]);
        score=scorer.getScore(Pxy);
      end
    end
    function data=OptimizeControlerFullModels()
      %not needed
    end
    function data=OptimizeControlerReducedModels()
      data.FullControlAutoregulatedModelControler=makeFullControlerAutoregulatedModelOptimization(1,70);
      data.UniformControlAutoregulatedModelControler=makeUniformControlerAutoregulatedModelOptimization(1,20);
      data.FullControlUnregulatedModelControler=makeFullControlerUnregulatedModelOptimization(1,70);
      data.UniformControlUnregulatedModelControler=makeUniformControlerUnregulatedModelOptimization(1,20);
      data.ReducedControlAutoregulatedModelControler=makeReducedControlerAutoregulatedModelOptimization(1,120);
      
      function controlInput=makeFullControlerAutoregulatedModelOptimization(numIterations,gNumIterations)
        builder=ModelFactory;
        model=builder.autoregulatedModelWithoutInput();
        layer=DataLayer;
        controller=layer.get('ControlInputs_ReducedModels');
        model.controlInput=controller.FullControlAutoregulatedModelControler;
        modelFsp=TwoCellFSP(model,[50 50]);
        
        optimizer=GradientControlerOptimizer;
        optimizer.initialRate=5000;
        optimizer.saveInject=false;
        optimizer.numIterations=numIterations;
        optimizer.gradCalc=FullGradientCalculator();
        optimizer.gradCalc.gmresMaxIter=gNumIterations;
        modelFsp=optimizer.visit(modelFsp);
        controlInput=modelFsp.model.controlInput;
      end
      function controlInput=makeUniformControlerAutoregulatedModelOptimization(numIterations,gNumIterations)
        builder=ModelFactory;
        model=builder.autoregulatedModelWithoutInput();
        layer=DataLayer();
        controller=layer.get('ControlInputs_ReducedModels');
        model.controlInput=controller.UniformControlAutoregulatedModelControler;
        modelFsp=TwoCellFSP(model,[50 50]);
        
        optimizer=GradientControlerOptimizer;
        optimizer.initialRate=5000;
        optimizer.saveInject=false;
        optimizer.numIterations=numIterations;
        optimizer.gradCalc=UniformGradientCalculator(modelFsp);
        optimizer.gradCalc.gmresMaxIter=gNumIterations;
        modelFsp=optimizer.visit(modelFsp);
        controlInput=modelFsp.model.controlInput;
      end
      function controlInput=makeFullControlerUnregulatedModelOptimization(numIterations,gNumIterations)
        builder=ModelFactory;
        model=builder.unregulatedModelWithoutInput();
        layer=DataLayer();
        controller=layer.get('ControlInputs_ReducedModels');
        model.controlInput=controller.FullControlUnregulatedModelControler;
        modelFsp=TwoCellFSP(model,[50 50]);
        optimizer=GradientControlerOptimizer;
        optimizer.initialRate=5000;
        optimizer.saveInject=false;
        optimizer.numIterations=numIterations;
        optimizer.gradCalc=FullGradientCalculator();
        optimizer.gradCalc.gmresMaxIter=gNumIterations;
        modelFsp=optimizer.visit(modelFsp)
        controlInput=modelFsp.model.controlInput;
        
      end
      function controlInput=makeUniformControlerUnregulatedModelOptimization(numIterations,gNumIterations)
        builder=ModelFactory;
        model=builder.unregulatedModelWithoutInput();
        layer=DataLayer();
        controller=layer.get('ControlInputs_ReducedModels');
        model.controlInput=controller.UniformControlUnregulatedModelControler;
        modelFsp=TwoCellFSP(model,[50 50]);
        optimizer=GradientControlerOptimizer;
        optimizer.initialRate=5000;
        optimizer.saveInject=false;
        optimizer.numIterations=numIterations;
        optimizer.gradCalc=UniformGradientCalculator(modelFsp);
        optimizer.gradCalc.gmresMaxIter=gNumIterations;
        modelFsp=optimizer.visit(modelFsp)
        controlInput=modelFsp.model.controlInput;
      end
      function controlInput=makeReducedControlerAutoregulatedModelOptimization(numIterations,gNumIterations)
        builder=ModelFactory;
        model=builder.autoregulatedModelWithoutInput();
        layer=DataLayer();
        controller=layer.get('ControlInputs_ReducedModels');
        model.controlInput=controller.ReducedControlAutoregulatedModelControler;
        modelFsp=TwoCellFSP(model,[50 50]);
        optimizer=GradientControlerOptimizer;
        optimizer.initialRate=5000;
        optimizer.saveInject=true;
        optimizer.numIterations=numIterations;
        optimizer.gradCalc=ReducedGradientCalculator(modelFsp);
        optimizer.gradCalc.gmresMaxIter=gNumIterations;
        modelFsp=optimizer.visit(modelFsp);
        controlInput=modelFsp.model.controlInput;
      end
    end
    function data=ModelFit_UnregulatedFullModel()
      parameters=[2/10,10/10/20,1,20,.05,.5,.5,.015,0.4060  0.0000  0.03];
      for i=1:200
        [ode{i},error(i)]=fit(parameters);
      end
      [error,minIndex]=min(error);
      parameters=ode{minIndex}.model.parameters;
      data.UnregulatedFullModelParameters=parameters;
      data.model=ode{minIndex}.model;
      data.error=error;
      function [ode,error]=fit(parameters)
        addpath(genpath('utility/'))
        realdata=KhammashTimeSeriesData;
        realdata.state=realdata.state./max(realdata.state).*20;
        optimizer=ParameterOptimizer;
        optimizer.index=5;
        optimizer.strategy=ParameterOptimizerParallelBeeSwarm;
        optimizer.data=realdata;
        optimizer.strategy.numBees=4;
        optimizer.strategy.numSteps=1;
        optimizer.strategy=optimizer.strategy.setLogBounds([-5 -5 -5 -5 -5 -5 -5 -5 -5 -5 -5;
          1  1  0  1  1  1  1  3  0  0  0]);
        optimizer.strategy.subOptimizer.maxIter=5;
        optimizer.strategy.subOptimizer.initialRate=.001;
        optimizer.strategy.subOptimizer.minRate=.0001;
        indVec=[1,2,3,4,5,6,7,8 9 11 13 15 16 17 18 19];
        optimizer.strategy.subOptimizer.errorFunction=@(y,x)sum(((y(indVec)-x(indVec)./max(x)*20)./y(indVec)).^2);
        build = ModelFactoryTestModels;
        
        model=build.fullModelWithFitInput;
        model.parameters=parameters;
        ode=SolverODE(model);
        [ode,error]=optimizer.optimize(ode);
        parameters=ode.model.parameters;
      end
    end
    function data=ModelFit_UnregulatedReducedModel()
      parameters=getParameters();
      for i=1:5
        [ode{i},error(i)]=fit(parameters);
      end
      [~,minIndex]=min(error);
      parameters=ode{minIndex}.model.parameters;
      close all
      data.UnregulatedReducedModelParameters=parameters;
      data.model=ode{minIndex}.model;
      data.error=min(error);
      function [ode,error]=fit(parameters)
        realdata=KhammashTimeSeriesData;
        realdata.state=realdata.state./max(realdata.state).*20;
        optimizer=ParameterOptimizer;
        optimizer.index=1;
        optimizer.strategy=ParameterOptimizerBeeSwarm;
        indVec=[6,7,8 9 11 13 15 16 17 18 19];
        optimizer.strategy.subOptimizer.errorFunction=@(y,x)sum(((y(indVec)-x(indVec))./y(indVec)).^2);
        optimizer.data=realdata;
        optimizer.strategy.numBees=16;
        optimizer.strategy.numSteps=1;
        optimizer.strategy=optimizer.strategy.setLogBounds([-10 log10(.0203) log10(0.4060) -10 -10;
          -10  log10(.0203)  log10(0.4060)  5  5]);
        optimizer.strategy.subOptimizer.maxIter=5;
        optimizer.strategy.subOptimizer.initialRate=.05;
        optimizer.strategy.subOptimizer.minRate=.0001;
        build = ModelFactory;
        model=build.unregulatedModelWithFitInput;
        model.parameters=parameters;
        ode=SolverODE(model);
        [ode,error]=optimizer.visit(ode);
      end
      function parameters=getParameters()
        defaultParameters=[1.0000e-06 0.0203 .4060 1.0000e-06 0.0607];
        try
          layer=DataLayer;
          data=load('data/file/dataModelFit_UnregulatedReducedModel');
          parameters=data.UnregulatedReducedModelParameters;
        catch
          parameters=defaultParameters;
        end
      end
    end
    function data=AnalysisODEHysteresis_ReducedModelUnregulated()
      build=ModelFactoryTestModels;
      unregModel=build.unregulatedModelWithUniformLight(0);%parameter on model to tweak is 6
      data=AnalysisLayer.HysteresisAnalysis(unregModel,3,1);%parameter on model to tweak is 6
    end
    function data=AnalysisODEHysteresis_ReducedModelAutoregulated()
      build=ModelFactoryTestModels;
      autoModel=build.autoregulatedModelWithUniformLight(0);
      data=AnalysisLayer.HysteresisAnalysis(autoModel,6,1);%parameter on model to tweak is 6
      dxUp=diff(data.upTrajectory);
      [~,ind]=max(abs(dxUp));
      data.UpperBound=data.range(ind);
      dxDown=diff(data.downTrajectory);
      [~,ind]=max(abs(dxDown));
      data.LowerBound=data.range(ind+1);
    end
    function data=AnalysisODEHysteresis_FullModelUnregulated()
      build=ModelFactoryTestModels;
      fullModel=build.fullModelWithUniformLight(0);
      data=AnalysisLayer.HysteresisAnalysis(fullModel,9,5);%parameter on model to tweak is 3save data/file/ideaFullModelHisteresis
    end
    function data=AnalysisODEHysteresis_FullModelAutoregulated()
      build=ModelFactoryTestModels;
      fullAutoModel=build.fullAutoModelWithUniformLight(0);
      data=AnalysisLayer.HysteresisAnalysis(fullAutoModel,13,5);%parameter on model to tweak is 3
    end
    function data=AnalysisODEFrequency_ReducedModels_Input()
      amp=.21;
      dc=.21;
      freq=.01;
      upperBound=.3;
      lowerBound=.1;
      timeRange=linspace(0,2/freq,100);
      build=ModelFactory();
      input=@(t,x,p)build.frequencyInput(t,x,p);
      data.input=input(timeRange,0,[freq amp dc]);
      data.time=2*timeRange/max(timeRange);
      data.upperbound=upperBound*ones(size(timeRange));
      data.lowerbound=lowerBound*ones(size(timeRange));
    end
    function data=AnalysisSSATwoCellSwapReducedModel()
      build=ModelFactory;
      datalayer=DataLayer();
      numSwaps=256;
      numCells=2;
      controllers=datalayer.get('ControlInputs_ReducedModels');
      controlInput=controllers.FullControlAutoregulatedModelControler;
      controlInput(200,200)=0;
      time=0:1000*numSwaps;
      model=build.twoCellAutoregulatedSwapModel(numSwaps,controlInput,time);
      modelSSA=SolverSSA(model);
      trajectory=modelSSA.run;
      parsedData=trajectory.parse(1);
      stateMax=max(max(trajectory.node{1}.state));
      bins=0:2:stateMax;
      L=1:1000;
      X=[];
      for i=1:3
        index=mod(i-1,2)+1;
        X=[X,trajectory.node{1}.state(index,L)];
        Y=[X,trajectory.node{1}.state(index,L)];
        L=L+1000;
      end
      for i=1:length(X)
        U(i)=controlInput(X(i)+1,Y(i)+1);
      end
      initialWindow=1:100;
      finalWindow=900:1000;
      initialNonTargetData=[];
      finalNonTargetData=[];
      initialTargetData=[];
      finalTargetData=[];
      for i =1:numSwaps
        initialFrame=initialWindow+1000*(i-1);
        finalFrame=finalWindow+1000*(i-1);
        targetCellIndex=mod(i-1,numCells)+1;
        nonTargetCellsIndex=1:numCells;
        nonTargetCellsIndex(nonTargetCellsIndex==targetCellIndex)=[];
        initialNonTargetData=[initialNonTargetData,parsedData.node{1}.state(nonTargetCellsIndex,initialFrame)];
        finalNonTargetData= [finalNonTargetData,parsedData.node{1}.state(nonTargetCellsIndex,finalFrame)];
        initialTargetData= [initialTargetData,parsedData.node{1}.state(targetCellIndex,initialFrame)];
        finalTargetData  = [finalTargetData,parsedData.node{1}.state(targetCellIndex,finalFrame)];
      end
      build=ModelFactory;
      model=build.autoregulatedModelWithoutInput;
      controlInput=controllers.FullControlAutoregulatedModelControler;
      model.controlInput=controlInput;
      fsp=TwoCellFSP(model,[50 50]);
      probability=fsp.getSteadyStateReshape();
      Px=sum(probability,1);
      Py=sum(probability,2);
      data.trajectory=trajectory;
      data.U=U;
      data.initialNonTargetData=initialNonTargetData;
      data.finalNonTargetData=finalNonTargetData;
      data.initialTargetData=initialTargetData;
      data.finalTargetData =finalTargetData;
      data.targetMarginal=Py;
      data.nonTargetMarginal=Px;
    end
    function data=AnalysisSSATwoCellFullModel()
      build=ModelFactory;
      datalayer=DataLayer();
      controllers=datalayer.get('ControlInputs_FullModels');
      controlInput=controllers.FullControlAutoregulatedModelControler_FMCalibration;
      controlInput(200,200)=0;
      time=0:200000;
      model=build.fullAutoModelWith2dControl(controlInput);
      model.time=time;
      model.initialState=[19 59  0 15 27 19 59  0 15 14];
      modelSSA=SolverSSA(model);
      trajectory=modelSSA.run;
      Pxy=zeros(80,80);
      for i =1:size(trajectory.node{1}.state,2)
        x=trajectory.node{1}.state(5,i)+1;
        y=trajectory.node{1}.state(10,i)+1;
        Pxy(x,y)=Pxy(x,y)+1;
      end
      Pxy=Pxy./sum(sum(Pxy));
      Px=sum(Pxy,1);
      Py=sum(Pxy,2);
      scorer=ProbabilityScore([80,80]);
      score=scorer.getScore(Pxy);
      for i =1:size(trajectory.node{1}.state,2)
        x=trajectory.node{1}.state(5,i)+1;
        y=trajectory.node{1}.state(10,i)+1;
        U(i)=controlInput(x,y);
      end
      Pxy=Pxy./sum(sum(Pxy));
      data.trajectory=trajectory;
      data.time=trajectory.node{1}.time;
      data.U=U;
      data.P=Pxy;
      data.score=score;
      data.targetMarginal=Py;
      data.nonTargetMarginal=Px;
      data.X=trajectory.node{1}.state(5,:);
      data.Y=trajectory.node{1}.state(10,:);
      data.target=[30 10];
      data.mean=mean(trajectory.node{1}.state(:,2000:end)');
      data.TScore=scorer.getSSATimeTrajectoryScore([trajectory.node{1}.state(5,4000:end);trajectory.node{1}.state(10,4000:end)]);
    end
    function data=AnalysisSSATwoCellFullModelReducedControl()
      build=ModelFactory;
      datalayer=DataLayer();
      controllers=datalayer.get('ControlInputs_FullModels');
      controlInput=controllers.ReducedControlAutoregulatedModelControler_FMCalibration;
      controlInput(200,200)=0;
      time=0:200000;
      model=build.fullAutoModelWith2dControl(controlInput)
      model.time=time;
      modelSSA=SolverSSA(model);
      trajectory=modelSSA.run;
      Pxy=zeros(80,80);
      for i =1:size(trajectory.node{1}.state,2)
        x=trajectory.node{1}.state(5,i)+1;
        y=trajectory.node{1}.state(10,i)+1;
        Pxy(x,y)=Pxy(x,y)+1;
      end
      Pxy=Pxy./sum(sum(Pxy));
      Px=sum(Pxy,1);
      Py=sum(Pxy,2);
      scorer=ProbabilityScore([80,80]);
      score=scorer.getScore(Pxy);
      for i =1:size(trajectory.node{1}.state,2)
        x=trajectory.node{1}.state(5,i)+1;
        y=trajectory.node{1}.state(10,i)+1;
        U(i)=controlInput(x,y);
      end
      Pxy=Pxy./sum(sum(Pxy));
      data.trajectory=trajectory;
      data.time=trajectory.node{1}.time;
      data.U=U;
      data.P=Pxy;
      data.score=score;
      data.targetMarginal=Py;
      data.nonTargetMarginal=Px;
      data.X=trajectory.node{1}.state(5,:);
      data.Y=trajectory.node{1}.state(10,:);
      data.target=[30 10];
      data.TScore=scorer.getSSATimeTrajectoryScore([trajectory.node{1}.state(5,4000:end);trajectory.node{1}.state(10,4000:end)]);
    end
    function data=AnalysisSSATwoCellReducedModel()
      build=ModelFactory;
      datalayer=DataLayer();
      controllers=datalayer.get('ControlInputs_ReducedModels');
      controlInput=controllers.FullControlAutoregulatedModelControler;
      controlInput(200,200)=0;
      time=0:200000;
      controlFunction=@(t,x)controlInput(x(1)+1,x(2)+1);
      model=build.nCellAutoregulatedModel(2,controlFunction);
      model.time=time;
      modelSSA=SolverSSA(model);
      trajectory=modelSSA.run;
      Pxy=zeros(80,80);
      for i =1:size(trajectory.node{1}.state,2)
        x=trajectory.node{1}.state(1,i)+1;
        y=trajectory.node{1}.state(2,i)+1;
        Pxy(x,y)=Pxy(x,y)+1;
      end
      Pxy=Pxy./sum(sum(Pxy));
      Px=sum(Pxy,1);
      Py=sum(Pxy,2);
      scorer=ProbabilityScore([80,80]);
      score=scorer.getScore(Pxy);
      for i =1:size(trajectory.node{1}.state,2)
        U(i)=controlInput(trajectory.node{1}.state(1,i)+1,trajectory.node{1}.state(2,i)+1);
      end
      Pxy=Pxy./sum(sum(Pxy));
      data.trajectory=trajectory;
      data.time=trajectory.node{1}.time;
      data.U=U;
      data.P=Pxy;
      data.score=score;
      data.targetMarginal=Py;
      data.nonTargetMarginal=Px;
      data.X=trajectory.node{1}.state(1,:);
      data.Y=trajectory.node{1}.state(2,:);
      data.target=[30 10];
      data.TScore=scorer.getSSATimeTrajectoryScore([trajectory.node{1}.state(1,4000:end);trajectory.node{1}.state(2,4000:end)]);
    end
    function data=AnalysisSSATwoCellReducedModelReducedControl()
      build=ModelFactory;
      datalayer=DataLayer();
      controllers=datalayer.get('ControlInputs_ReducedModels');
      controlInput=controllers.ReducedControlAutoregulatedModelControler;
      controlInput(200,200)=0;
      time=0:200000;
      controlFunction=@(t,x)controlInput(x(1)+1,x(2)+1);
      model=build.nCellAutoregulatedModel(2,controlFunction);
      model.time=time;
      modelSSA=SolverSSA(model);
      trajectory=modelSSA.run;
      Pxy=zeros(80,80);
      for i =1:size(trajectory.node{1}.state,2)
        x=trajectory.node{1}.state(1,i)+1;
        y=trajectory.node{1}.state(2,i)+1;
        Pxy(x,y)=Pxy(x,y)+1;
      end
      Pxy=Pxy./sum(sum(Pxy));
      Px=sum(Pxy,1);
      Py=sum(Pxy,2);
      scorer=ProbabilityScore([80,80]);
      score=scorer.getScore(Pxy);
      for i =1:size(trajectory.node{1}.state,2)
        x=trajectory.node{1}.state(1,i)+1;
        y=trajectory.node{1}.state(2,i)+1;
        U(i)=controlInput(x,y);
      end
      Pxy=Pxy./sum(sum(Pxy));
      data.trajectory=trajectory;
      data.time=trajectory.node{1}.time;
      data.U=U;
      data.P=Pxy;
      data.score=score;
      data.targetMarginal=Py;
      data.nonTargetMarginal=Px;
      data.X=trajectory.node{1}.state(1,:);
      data.Y=trajectory.node{1}.state(2,:);
      data.target=[30 10];
      data.TScore=scorer.getSSATimeTrajectoryScore([data.X;data.Y]);
    end
    function data=AnalysisSSAFourCellSwapReducedModel()
      build=ModelFactory;
      datalayer=DataLayer();
      numSwaps=256;
      numCells=4;
      controllers=datalayer.get('ControlInputs_ReducedModels');
      controlInput=controllers.ReducedControlAutoregulatedModelControler;
      controlInput(200,200)=0;
      time=0:1000*numSwaps;
      model=build.nCellAutoregulatedSwapModel(numCells,numSwaps,controlInput,time);
      modelSSA=SolverSSA(model);
      trajectory=modelSSA.run;
      parsedData=trajectory.parse(1);
      stateMax=max(max(trajectory.node{1}.state));
      L=1:1000;
      X=[];
      for i=1:3
        X=[X,trajectory.node{1}.state(i,L)];
        Y=[X,trajectory.node{1}.state(i,L)];
        L=L+1000;
      end
      for i=1:length(X)
        U(i)=controlInput(X(i)+1,Y(i)+1);
      end
      initialWindow=1:100;
      finalWindow=900:1000;
      initialNonTargetData=[];
      finalNonTargetData=[];
      initialTargetData=[];
      finalTargetData=[];
      for i =1:numSwaps
        initialFrame=initialWindow+1000*(i-1);
        finalFrame=finalWindow+1000*(i-1);
        targetCellIndex=mod(i-1,numCells)+1;
        nonTargetCellsIndex=1:numCells;
        nonTargetCellsIndex(nonTargetCellsIndex==targetCellIndex)=[];
        initialNonTargetData=[initialNonTargetData,parsedData.node{1}.state(nonTargetCellsIndex,initialFrame)];
        finalNonTargetData= [finalNonTargetData,parsedData.node{1}.state(nonTargetCellsIndex,finalFrame)];
        initialTargetData= [initialTargetData,parsedData.node{1}.state(targetCellIndex,initialFrame)];
        finalTargetData  = [finalTargetData,parsedData.node{1}.state(targetCellIndex,finalFrame)];
      end
      build=ModelFactory;
      model=build.autoregulatedModelWithoutInput;
      model.controlInput=controllers.ReducedControlAutoregulatedModelControler;
      fsp=TwoCellFSP(model,[50 50]);
      probability=fsp.getSteadyStateReshape();
      Px=sum(probability,1);
      Py=sum(probability,2);
      data.trajectory=trajectory;
      data.U=U;
      data.initialNonTargetData=initialNonTargetData;
      data.finalNonTargetData=finalNonTargetData;
      data.initialTargetData=initialTargetData;
      data.finalTargetData =finalTargetData;
      data.targetMarginal=Py;
      data.nonTargetMarginal=Px;
    end
    function data=ControlInputs_FullModels()
      layer=DataLayer;
      controllers=layer.get('ControlInputs_ReducedModels');
      calibrationCurve=layer.get('CalibrationCurveAutoregulatedFullReduced');
      data.FullControlAutoregulatedModelControler_FMCalibration=calibrate(controllers.FullControlAutoregulatedModelControler,calibrationCurve.calibration);
      data.UniformControlAutoregulatedModelControler_FMCalibration=calibrate(controllers.UniformControlAutoregulatedModelControler,calibrationCurve.calibration);
      data.FullControlUnregulatedModelControler_FMCalibration=calibrate(controllers.FullControlUnregulatedModelControler,calibrationCurve.calibration);
      data.UniformControlUnregulatedModelControler_FMCalibration=calibrate(controllers.UniformControlUnregulatedModelControler,calibrationCurve.calibration);
      data.ReducedControlAutoregulatedModelControler_FMCalibration=calibrate(controllers.ReducedControlAutoregulatedModelControler,calibrationCurve.calibration);
      
      function output=calibrate(input,calibration)
        input(input<calibration(1,1))=calibration(1,1);
        input(input>calibration(1,end))=calibration(1,end);
        output=interp1(calibration(1,:),calibration(2,:),input);
      end
    end
    function data=ControlInputs_ReducedModels()
      load 'data/controlers/Controllers_ReducedModels.mat'
    end
    function data=ControlInputs_ReducedModelsOld()
      load 'data/controlers/Controllers_ReducedModelsOld.mat'
    end
    function data=CalibrationCurveUnregulatedFullReduced()
      layer=DataLayer;
      layer.forceAnalysis=true;
      data1=layer.get('CalibrationCurveUnregulatedReducedResponse');
      data2=layer.get('CalibrationCurveUnregulatedFullResponse');
      bound=min([max(data1.upAnalysis),max(data2.upAnalysis)]);
      rangeProtein=[0:.01:bound];
      find(diff(data1.upAnalysis)==0,1)
      trajectoryPF=interp1(data1.upAnalysis,data1.uRange,rangeProtein);
      trajectoryPR=interp1(data2.upAnalysis,data2.uRange,rangeProtein);
      calibration=[trajectoryPF;trajectoryPR;rangeProtein];
      ind=1;
      for i=1:size(calibration,2)
        if any(isnan(calibration(:,i)))
          %do nothing
        else
          newCalibration(:,ind)=calibration(:,i);
          ind=ind+1;
        end
      end
      calibration=newCalibration;
      data.calibration=calibration;
    end
    function data=CalibrationCurveAutoregulatedFullReduced()
      layer=DataLayer;
      layer.forceAnalysis=true;
      data1=layer.get('CalibrationCurveAutoregulatedReducedResponse');
      data2=layer.get('CalibrationCurveAutoregulatedFullResponse');
      bound=min([max(data1.upAnalysis),max(data2.upAnalysis)]);
      rangeProtein=[0:.01:bound];
      find(diff(data1.upAnalysis)==0,1)
      trajectoryPF=interp1(data1.upAnalysis,data1.uRange,rangeProtein);
      trajectoryPR=interp1(data2.upAnalysis,data2.uRange,rangeProtein);
      calibration=[trajectoryPF;trajectoryPR;rangeProtein];
      ind=1;
      for i=1:size(calibration,2)
        if any(isnan(calibration(:,i)))
          %do nothing
        else
          newCalibration(:,ind)=calibration(:,i);
          ind=ind+1;
        end
      end
      calibration=newCalibration;
      data.calibration=calibration;
    end
    function data=CalibrationCurveUnregulatedReducedResponse()
      lightIndex=3;
      speciesIndex=1;
      uRange=0:.001:1.5;
      build=ModelFactory;
      model=build.unregulatedModelWithUniformLight(0);
      modelOde=SolverODE(model);
      analyzer=HisteresisAnalysis(modelOde);
      analyzer.time=linspace(0,3500,70);
      analyzer.speciesIndex=speciesIndex;
      analyzer.uRange=uRange;
      [upAnalysis,downAnalysis]=analyzer.analyze(lightIndex);
      range=analyzer.uRange;
      data.uRange=uRange;
      data.upAnalysis=upAnalysis;
      data.downAnalysis=downAnalysis;
    end
    function data=CalibrationCurveUnregulatedFullResponse()
      lightIndex=9;
      speciesIndex=5;
      uRange=0:.001:1.5;
      build=ModelFactory;
      model=build.fullModelWithUniformLight(0);
      modelOde=SolverODE(model);
      analyzer=HisteresisAnalysis(modelOde);
      analyzer.time=linspace(0,3500,70);
      analyzer.speciesIndex=speciesIndex;
      analyzer.uRange=uRange;
      [upAnalysis,downAnalysis]=analyzer.analyze(lightIndex);
      range=analyzer.uRange;
      data.uRange=uRange;
      data.upAnalysis=upAnalysis;
      data.downAnalysis=downAnalysis;
    end
    function data=CalibrationCurveAutoregulatedReducedResponse()
      lightIndex=6;
      speciesIndex=1;
      uRange=0:.0001:1;
      build=ModelFactory;
      model=build.autoregulatedModelWithUniformLight(0);
      modelOde=SolverODE(model);
      analyzer=HisteresisAnalysis(modelOde);
      analyzer.time=linspace(0,3500,70);
      analyzer.speciesIndex=speciesIndex;
      analyzer.uRange=uRange;
      [upAnalysis,downAnalysis]=analyzer.analyze(lightIndex);
      range=analyzer.uRange;
      data.uRange=uRange;
      data.upAnalysis=upAnalysis;
      data.downAnalysis=downAnalysis;
    end
    function data=CalibrationCurveAutoregulatedFullResponse()
      lightIndex=13;
      speciesIndex=5;
      uRange=0:.0001:1.5;
      build=ModelFactory;
      model=build.fullAutoModelWithUniformLight(0);
      modelOde=SolverODE(model);
      analyzer=HisteresisAnalysis(modelOde);
      analyzer.time=linspace(0,3500,70);
      analyzer.speciesIndex=speciesIndex;
      analyzer.uRange=uRange;
      [upAnalysis,downAnalysis]=analyzer.analyze(lightIndex);
      range=analyzer.uRange;
      data.uRange=uRange;
      data.upAnalysis=upAnalysis;
      data.downAnalysis=downAnalysis;
    end
    function data=CalibrationCurveHysteresisCalibratedModel()
      layer=DataLayer();
      loaddata=layer.get('CalibrationCurveAutoregulatedFullReduced');
      build=ModelFactory;
      calibratedModel=build.calibratedFullAutoModel(loaddata.calibration);
      uRange=linspace(0,.5,201);
      [upAnalysisC,downAnalysisC]=performAnalysis(calibratedModel,13,5,uRange);
      data.upTrajectory=upAnalysisC;
      data.downTrajectory=downAnalysisC;
      data.range=uRange;
      function [upAnalysis,downAnalysis]=performAnalysis(model,lightIndex,speciesIndex,uRange)
        modelOde=SolverODE(model);
        analyzer=HisteresisAnalysis(modelOde);
        analyzer.time=linspace(0,3500,50);
        analyzer.speciesIndex=speciesIndex;
        analyzer.uRange=uRange;
        [upAnalysis,downAnalysis]=analyzer.analyze(lightIndex);
        %plot(analyzer.uRange,upAnalysis,spec1,analyzer.uRange,downAnalysis,spec2);
        range=analyzer.uRange;
      end
    end
    function data=ModelFitODEUnregulatedReducedModel_Calibration()
      build=ModelFactory;
      x=build.u_exp([2 3 1]);
      y=build.uFitReduced([2 3 1]);
      data.calibration(1,:)=interp1(x,y,linspace(x(1),x(end)),'cubic');
      data.calibration(2,:)=linspace(x(1),x(end));
      data.TruePoints=[y;x];
    end
    function data=ModelFitODEUnregulatedFullModel_Calibration()
      build=ModelFactory;
      x=build.u_exp([2 3 1]);
      y=build.uFitFull([2 3 1]);
      data.calibration(1,:)=interp1(x,y,linspace(x(1),x(end)),'cubic');
      data.calibration(2,:)=linspace(x(1),x(end));
      data.TruePoints=[y;x];
    end
    function data=ModelFitODEUnregulatedFullModel()
      build=ModelFactoryTestModels;
      model=build.fullModelWithFitInput;
      model.time=[-500 model.time];
      ode=SolverODE(model);
      trajectory=ode.run();
      data.time=trajectory.time(2:end);
      data.state=trajectory.state(:,2:end);
    end
    function data=ModelFitODEUnregulatedReducedModel()
      build=ModelFactoryTestModels;
      model=build.unregulatedModelWithFitInput;
      ode=SolverODE(model);
      trajectory=ode.run();
      data.time=trajectory.time;
      data.state=trajectory.state;
    end
    function data=ModelFitSSAUnregulatedReducedModel_Low()
      build=ModelFactoryTestModels;
      model=build.unregulatedModelWithUniformLight(build.uFitReduced(2));
      model.time=0:.5:5000;
      ode=SolverSSA(model);
      trajectory=ode.run();
      trajectory.trimInitial(2000);
      data.time=trajectory.node{1}.time;
      data.state=trajectory.node{1}.state;
    end
    function data=ModelFitSSAUnregulatedReducedModel_Med()
      build=ModelFactoryTestModels;
      model=build.unregulatedModelWithUniformLight(build.uFitReduced(3));
      model.time=0:.5:5000;
      ode=SolverSSA(model);
      trajectory=ode.run();
      trajectory.trimInitial(2000);
      data.time=trajectory.node{1}.time;
      data.state=trajectory.node{1}.state;
    end
    function data=ModelFitSSAUnregulatedReducedModel_Hig()
      build=ModelFactoryTestModels;
      model=build.unregulatedModelWithUniformLight(build.uFitReduced(1));
      model.time=0:.5:5000;
      ode=SolverSSA(model);
      trajectory=ode.run();
      trajectory.trimInitial(2000);
      data.time=trajectory.node{1}.time;
      data.state=trajectory.node{1}.state;
    end
    function data=ModelFitSSAUnregulatedReducedModel_Calib()
      layer=DataLayer;
      layer.forceAnalysis=true;
      data=layer.get('CalibrationCurveUnregulatedFullReduced');
      build=ModelFactoryTestModels;
      model=build.unregulatedModelWithUniformLight(data.calibration(1,2000));
      model.time=0:.5:10000;
      ssa=SolverSSA(model);
      trajectory=ssa.run();
      trajectory.trimInitial(3000);
      data.time=trajectory.node{1}.time;
      data.state=trajectory.node{1}.state;
    end
    function data=ModelFitSSAUnregulatedFullModel_Low()
      build=ModelFactoryTestModels;
      model=build.fullModelWithUniformLight(build.uFitFull(2));
      model.time=0:.5:5000;
      ode=SolverSSA(model);
      trajectory=ode.run();
      trajectory.trimInitial(2000);
      data.time=trajectory.node{1}.time;
      data.state=trajectory.node{1}.state;
    end
    function data=ModelFitSSAUnregulatedFullModel_Med()
      build=ModelFactoryTestModels;
      model=build.fullModelWithUniformLight(build.uFitFull(3));
      model.time=0:.5:5000;
      ode=SolverSSA(model);
      trajectory=ode.run();
      trajectory.trimInitial(2000);
      data.time=trajectory.node{1}.time;
      data.state=trajectory.node{1}.state;
    end
    function data=ModelFitSSAUnregulatedFullModel_Hig()
      build=ModelFactoryTestModels;
      model=build.fullModelWithUniformLight(build.uFitFull(1));
      model.time=0:.5:5000;
      ode=SolverSSA(model);
      trajectory=ode.run();
      trajectory.trimInitial(2000);
      data.time=trajectory.node{1}.time;
      data.state=trajectory.node{1}.state;
    end
    function data=ModelFitSSAUnregulatedFullModel_Calib()
      layer=DataLayer;
      data=layer.get('CalibrationCurveUnregulatedFullReduced');
      build=ModelFactoryTestModels;
      model=build.fullModelWithUniformLight(data.calibration(2,2000));
      model.time=0:.5:20000;
      ode=SolverSSA(model);
      trajectory=ode.run();
      trajectory.trimInitial(3000);
      data.time=trajectory.node{1}.time;
      data.state=trajectory.node{1}.state;
      data.mean=mean(trajectory.node{1}.state)
    end
    function data=ModelFitODE_ExperimentalData()
      realData=KhammashTimeSeriesData;
      data.time=realData.time;
      data.state=realData.state;
    end
    function data=AnalysisSSAFSPPredictiveReducedModelControl()
      quartiles=[.80];
      data=getData(quartiles);
      function data=getData(quart)
        build=ModelFactory;
        layer=DataLayer;
        controller=layer.get('ControlInputs_ReducedModels');
        controlInput=controller.FullControlAutoregulatedModelControler;
        controlInput(200,200)=0;
        time=0:.5:100000;
        dT=time(2)-time(1);
        model=build.autoregulatedModelWithUniformLight(0);
        model.time=[0 dT];
        ssaX=SolverSSA(model);
        ssaY=SolverSSA(model);
        fsp=SolverFSP(model,[50]);
        currentX=30;
        currentY=10;
        ssaX.model.initialState=currentX;
        ssaY.model.initialState=currentY;
        currentYPrediction=ones(50,1);
        currentYPrediction=currentYPrediction/sum(currentYPrediction);
        fsp.model.initialState=currentYPrediction;
        historyYPrediction=zeros(1,length(time));
        historyX=zeros(1,length(time));
        historyY=zeros(1,length(time));
        historyU=zeros(1,length(time));
        historyP=zeros(50,length(time));
        for i =1:length(time)
          prediction=quartile(currentYPrediction,quart);
          state=[currentX,prediction];
          input=controlInput(state(1)+1,state(2)+1);
          ssaX.model.parameters(6)=input;
          ssaY.model.parameters(6)=input;
          fsp.model.parameters(6)=input;
          ssaXdata=ssaX.run();
          ssaYdata=ssaY.run();
          fspdata=fsp.run();
          currentX=ssaXdata.node{1}.state(end);
          currentY=ssaYdata.node{1}.state(end);
          currentYPrediction=fspdata.state(:,end);
          ssaX.model.initialState=currentX;
          ssaY.model.initialState=currentY;
          fsp.model.initialState=currentYPrediction;
          historyX(i)=currentX;
          historyY(i)=currentY;
          historyU(i)=input;
          historyYPrediction(i)=prediction;
          historyP(:,i)=currentYPrediction;
        end
        Pxy=zeros(80,80);
        trim=3000;
        for i=trim:length(historyX)
          if (historyX(i)<80) && (historyY(i)<80)
            Pxy(historyX(i)+1,historyY(i)+1)=Pxy(historyX(i)+1,historyY(i)+1)+1;
          end
        end
        Pxy=Pxy./sum(sum(Pxy));
        score=ProbabilityScore([80 80]);
        data.U=historyU;
        data.steadystate=Pxy;
        data.time=time;
        data.X=historyX;
        data.Y=historyY;
        data.P=historyP;
        data.predictionY=historyYPrediction;
        data.Pscore=score.getScore(Pxy);
        data.TScore=score.getSSATimeTrajectoryScore([data.X;data.Y]);
        data.target=[30 10];
      end
      function prediction=quartile(probability,ratio)
        cprobability=cumsum(probability);
        index=find(cprobability>ratio,1);
        probability=probability*0;
        probability(index)=1;
        x=[1:length(probability)]-1;
        prediction=x*probability;
        prediction=round(prediction);
      end
    end
    function data=AnalysisSSAFSPPredictiveFullModelControl()
      quartiles=[.80];
      data=getData(quartiles);
      function data=getData(quart)
        build=ModelFactory;
        layer=DataLayer;
        controller=layer.get('ControlInputs_ReducedModels');
        controlInput=controller.FullControlAutoregulatedModelControler;
        controlInput(200,200)=0;
        calibration=layer.get('CalibrationCurveAutoregulatedFullReduced');
        calibration=calibration.calibration;
        time=0:.5:100000;
        dT=time(2)-time(1);
        model=build.autoregulatedModelWithUniformLight(0);
        model.time=[0 dT];
        model1=build.calibratedFullAutoModel(calibration);
        model1.time=[0 dT];
        model1.initialState(5)=30;
        model2=build.calibratedFullAutoModel(calibration);
        model2.time=[0 dT];
        model2.initialState(5)=10;
        ssaX=SolverSSA(model1);
        ssaY=SolverSSA(model2);
        fsp=SolverFSP(model,[50]);
        currentX=model1.initialState;
        currentY=model2.initialState;
        ssaX.model.initialState=currentX;
        ssaY.model.initialState=currentY;
        currentYPrediction=ones(50,1);
        currentYPrediction=currentYPrediction/sum(currentYPrediction);
        fsp.model.initialState=currentYPrediction;
        historyYPrediction=zeros(1,length(time));
        historyX=zeros(1,length(time));
        historyY=zeros(1,length(time));
        historyU=zeros(1,length(time));
        historyP=zeros(50,length(time));
        for i =1:length(time)
          prediction=quartile(currentYPrediction,quart);
          state=[currentX(5),prediction];
          input=controlInput(state(1)+1,state(2)+1);
          ssaX.model.parameters(13)=input;
          ssaY.model.parameters(13)=input;
          fsp.model.parameters(6)=input;
          ssaXdata=ssaX.run();
          ssaYdata=ssaY.run();
          fspdata=fsp.run();
          currentX=ssaXdata.node{1}.state(:,end);
          currentY=ssaYdata.node{1}.state(:,end);
          currentYPrediction=fspdata.state(:,end);
          ssaX.model.initialState=currentX;
          ssaY.model.initialState=currentY;
          fsp.model.initialState=currentYPrediction;
          historyX(i)=currentX(5,end);
          historyY(i)=currentY(5,end);
          historyU(i)=input;
          historyYPrediction(i)=prediction;
          historyP(:,i)=currentYPrediction;
        end
        Pxy=zeros(80,80);
        trim=3000;
        for i=trim:length(historyX)
          if (historyX(i)<80) && (historyY(i)<80)
            Pxy(historyX(i)+1,historyY(i)+1)=Pxy(historyX(i)+1,historyY(i)+1)+1;
          end
        end
        Pxy=Pxy./sum(sum(Pxy));
        score=ProbabilityScore([80 80]);
        data.U=historyU;
        data.steadystate=Pxy;
        data.time=time;
        data.X=historyX;
        data.Y=historyY;
        data.P=historyP;
        data.predictionY=historyYPrediction;
        data.Pscore=score.getScore(Pxy);
        data.TScore=score.getSSATimeTrajectoryScore([data.X;data.Y]);
        data.target=[30 10];
      end
      function prediction=quartile(probability,ratio)
        cprobability=cumsum(probability);
        index=find(cprobability>ratio,1);
        probability=probability*0;
        probability(index)=1;
        x=[1:length(probability)]-1;
        prediction=x*probability;
        prediction=round(prediction);
      end
    end
    function data=AnalysisSSAFSPPredictiveFullModelReducedControl()
      quartiles=[.80];
      data=getData(quartiles);
      function data=getData(quart)
        build=ModelFactory;
        layer=DataLayer;
        controller=layer.get('ControlInputs_ReducedModels');
        controlInput=controller.ReducedControlAutoregulatedModelControler;
        controlInput(200,200)=0;
        calibration=layer.get('CalibrationCurveAutoregulatedFullReduced');
        calibration=calibration.calibration;
        time=0:.5:100000;
        dT=time(2)-time(1);
        model=build.autoregulatedModelWithUniformLight(0);
        model.time=[0 dT];
        model1=build.calibratedFullAutoModel(calibration);
        model1.time=[0 dT];
        model1.initialState(5)=30;
        model2=build.calibratedFullAutoModel(calibration);
        model2.time=[0 dT];
        model2.initialState(5)=10;
        ssaX=SolverSSA(model1);
        ssaY=SolverSSA(model2);
        fsp=SolverFSP(model,[50]);
        currentX=model1.initialState;
        currentY=model2.initialState;
        ssaX.model.initialState=currentX;
        ssaY.model.initialState=currentY;
        currentYPrediction=ones(50,1);
        currentYPrediction=currentYPrediction/sum(currentYPrediction);
        fsp.model.initialState=currentYPrediction;
        historyYPrediction=zeros(1,length(time));
        historyX=zeros(1,length(time));
        historyY=zeros(1,length(time));
        historyU=zeros(1,length(time));
        historyP=zeros(50,length(time));
        for i =1:length(time)
          prediction=quartile(currentYPrediction,quart);
          state=[currentX(5),prediction];
          input=controlInput(state(1)+1,state(2)+1);
          ssaX.model.parameters(13)=input;
          ssaY.model.parameters(13)=input;
          fsp.model.parameters(6)=input;
          ssaXdata=ssaX.run();
          ssaYdata=ssaY.run();
          fspdata=fsp.run();
          currentX=ssaXdata.node{1}.state(:,end);
          currentY=ssaYdata.node{1}.state(:,end);
          currentYPrediction=fspdata.state(:,end);
          ssaX.model.initialState=currentX;
          ssaY.model.initialState=currentY;
          fsp.model.initialState=currentYPrediction;
          historyX(i)=currentX(5,end);
          historyY(i)=currentY(5,end);
          historyU(i)=input;
          historyYPrediction(i)=prediction;
          historyP(:,i)=currentYPrediction;
        end
        Pxy=zeros(80,80);
        trim=3000;
        for i=trim:length(historyX)
          if (historyX(i)<80) && (historyY(i)<80)
            Pxy(historyX(i)+1,historyY(i)+1)=Pxy(historyX(i)+1,historyY(i)+1)+1;
          end
        end
        Pxy=Pxy./sum(sum(Pxy));
        score=ProbabilityScore([80 80]);
        data.U=historyU;
        data.steadystate=Pxy;
        data.time=time;
        data.X=historyX;
        data.Y=historyY;
        data.P=historyP;
        data.predictionY=historyYPrediction;
        data.Pscore=score.getScore(Pxy);
        data.TScore=score.getSSATimeTrajectoryScore([data.X;data.Y]);
        data.target=[30 10];
      end
      function prediction=quartile(probability,ratio)
        cprobability=cumsum(probability);
        index=find(cprobability>ratio,1);
        probability=probability*0;
        probability(index)=1;
        x=[1:length(probability)]-1;
        prediction=x*probability;
        prediction=round(prediction);
      end
    end
    function data=AnalysisSSAFSPPredictiveFullModelControlSlowed()
      quartiles=[.80];
      data=getData(quartiles);
      function data=getData(quart)
        build=ModelFactory;
        layer=DataLayer;
        controller=layer.get('ControlInputs_ReducedModels');
        controlInput=controller.FullControlAutoregulatedModelControler;
        controlInput(200,200)=0;
        calibration=layer.get('CalibrationCurveAutoregulatedFullReduced');
        calibration=calibration.calibration;
        time=0:.5:100000;
        dT=time(2)-time(1);
        model=build.autoregulatedModelWithUniformLightSlowed(0);
        model.time=[0 dT];
        model1=build.calibratedFullAutoModel(calibration);
        model1.time=[0 dT];
        model1.initialState(5)=30;
        model2=build.calibratedFullAutoModel(calibration);
        model2.time=[0 dT];
        model2.initialState(5)=10;
        ssaX=SolverSSA(model1);
        ssaY=SolverSSA(model2);
        fsp=SolverFSP(model,[50]);
        currentX=model1.initialState;
        currentY=model2.initialState;
        ssaX.model.initialState=currentX;
        ssaY.model.initialState=currentY;
        currentYPrediction=ones(50,1);
        currentYPrediction=currentYPrediction/sum(currentYPrediction);
        fsp.model.initialState=currentYPrediction;
        historyYPrediction=zeros(1,length(time));
        historyX=zeros(1,length(time));
        historyY=zeros(1,length(time));
        historyU=zeros(1,length(time));
        historyP=zeros(50,length(time));
        for i =1:length(time)
          prediction=quartile(currentYPrediction,quart);
          state=[currentX(5),prediction];
          input=controlInput(state(1)+1,state(2)+1);
          ssaX.model.parameters(13)=input;
          ssaY.model.parameters(13)=input;
          fsp.model.parameters(6)=input;
          ssaXdata=ssaX.run();
          ssaYdata=ssaY.run();
          fspdata=fsp.run();
          currentX=ssaXdata.node{1}.state(:,end);
          currentY=ssaYdata.node{1}.state(:,end);
          currentYPrediction=fspdata.state(:,end);
          ssaX.model.initialState=currentX;
          ssaY.model.initialState=currentY;
          fsp.model.initialState=currentYPrediction;
          historyX(i)=currentX(5,end);
          historyY(i)=currentY(5,end);
          historyU(i)=input;
          historyYPrediction(i)=prediction;
          historyP(:,i)=currentYPrediction;
        end
        Pxy=zeros(80,80);
        trim=3000;
        for i=trim:length(historyX)
          if (historyX(i)<80) && (historyY(i)<80)
            Pxy(historyX(i)+1,historyY(i)+1)=Pxy(historyX(i)+1,historyY(i)+1)+1;
          end
        end
        Pxy=Pxy./sum(sum(Pxy));
        score=ProbabilityScore([80 80]);
        data.U=historyU;
        data.steadystate=Pxy;
        data.time=time;
        data.X=historyX;
        data.Y=historyY;
        data.P=historyP;
        data.predictionY=historyYPrediction;
        data.Pscore=score.getScore(Pxy);
        data.TScore=score.getSSATimeTrajectoryScore([data.X;data.Y]);
        data.target=[30 10];
      end
      function prediction=quartile(probability,ratio)
        cprobability=cumsum(probability);
        index=find(cprobability>ratio,1);
        probability=probability*0;
        probability(index)=1;
        x=[1:length(probability)]-1;
        prediction=x*probability;
        prediction=round(prediction);
      end
    end
    function data=AnalysisSSAFSPPredictiveReducedModelReducedControl()
      quartiles=[.7];
      data=getData(quartiles);
      function data=getData(quart)
        build=ModelFactory;
        layer=DataLayer;
        controller=layer.get('ControlInputs_ReducedModels');
        controlInput=controller.ReducedControlAutoregulatedModelControler;
        controlInput(200,200)=0;
        time=0:.5:100000;
        dT=time(2)-time(1);
        model=build.autoregulatedModelWithUniformLight(0);
        model.time=[0 dT];
        ssaX=SolverSSA(model);
        ssaY=SolverSSA(model);
        fsp=SolverFSP(model,[50]);
        currentX=30;
        currentY=10;
        ssaX.model.initialState=currentX;
        ssaY.model.initialState=currentY;
        currentYPrediction=ones(50,1);
        currentYPrediction=currentYPrediction/sum(currentYPrediction);
        fsp.model.initialState=currentYPrediction;
        historyYPrediction=zeros(1,length(time));
        historyX=zeros(1,length(time));
        historyY=zeros(1,length(time));
        historyU=zeros(1,length(time));
        historyP=zeros(50,length(time));
        for i =1:length(time)
          prediction=quartile(currentYPrediction,quart);
          state=[currentX,prediction];
          input=controlInput(state(1)+1,state(2)+1);
          ssaX.model.parameters(6)=input;
          ssaY.model.parameters(6)=input;
          fsp.model.parameters(6)=input;
          ssaXdata=ssaX.run();
          ssaYdata=ssaY.run();
          fspdata=fsp.run();
          currentX=ssaXdata.node{1}.state(end);
          currentY=ssaYdata.node{1}.state(end);
          currentYPrediction=fspdata.state(:,end);
          ssaX.model.initialState=currentX;
          ssaY.model.initialState=currentY;
          fsp.model.initialState=currentYPrediction;
          historyX(i)=currentX;
          historyY(i)=currentY;
          historyU(i)=input;
          historyYPrediction(i)=prediction;
          historyP(:,i)=currentYPrediction;
        end
        Pxy=zeros(80,80);
        trim=3000;
        for i=trim:length(historyX)
          if (historyX(i)<80) && (historyY(i)<80)
            Pxy(historyX(i)+1,historyY(i)+1)=Pxy(historyX(i)+1,historyY(i)+1)+1;
          end
        end
        Pxy=Pxy./sum(sum(Pxy));
        score=ProbabilityScore([80 80]);
        data.U=historyU;
        data.steadystate=Pxy;
        data.time=time;
        data.X=historyX;
        data.Y=historyY;
        data.P=historyP;
        data.predictionY=historyYPrediction;
        data.Pscore=score.getScore(Pxy);
        data.TScore=score.getSSATimeTrajectoryScore([data.X;data.Y]);
        data.target=[30 10];
      end
      function prediction=quartile(probability,ratio)
        cprobability=cumsum(probability);
        index=find(cprobability>ratio,1);
        probability=probability*0;
        probability(index)=1;
        x=[1:length(probability)]-1;
        prediction=x*probability;
        prediction=round(prediction);
      end
    end
    function data=HysteresisAnalysis(model,lightIndex,speciesIndex)
      uRange=0:.01:1;
      modelOde=SolverODE(model);
      analyzer=HisteresisAnalysis(modelOde);
      analyzer.time=linspace(0,2000,1500);
      analyzer.speciesIndex=speciesIndex;
      analyzer.uRange=uRange;
      [upAnalysis,downAnalysis]=analyzer.analyze(lightIndex);
      data.upTrajectory=upAnalysis;
      data.downTrajectory=downAnalysis;
      data.range=uRange;
    end
    function data=AnalysisSSAControlPair(model)
      ssa=SolverSSA(model);
      ssa.time=linspce(0,40000,.5);
      
    end
    function data=CalibrationUPhi()
      
    end
  end
end