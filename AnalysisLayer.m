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
      wRange=logspace(-4,-2,4);
      deltaT=2./wRange;
      tStep=deltaT/80;
      amp=.2/builder.alpha;
      dc=.2/builder.alpha;%dc > amp at all times!!
      minTime=4000 ;
      numCycles=100;
      pBucket=ParallelMenu;
      func={};
      for j=1:3
        for i=1:length(wRange)
          tEnd=20./wRange(i);
          time=0:tStep(i):tEnd;
          ode{i}=SolverODE;
          switch j
            case 1
              model{i}=builder.fullAutoModelWithFrequencyInput(wRange(i),amp,dc);
              initialmodel{i}=builder.fullAutoModelWithFrequencyInput(wRange(i),0,dc);
            case 2
              model{i}=builder.autoregulatedModelWithFrequencyInput(wRange(i),amp,dc);
              initialmodel{i}=builder.autoregulatedModelWithFrequencyInput(wRange(i),0,dc);
            case 3
              model{i}=builder.calibratedFullAutoModelWithFrequencyInput(wRange(i),amp,dc);
              initialmodel{i}=builder.calibratedFullAutoModelWithFrequencyInput(wRange(i),0,dc);
          end
          initialmodel{i}.time=0:2000;
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
      data.trajectories=pBucket.nonParallelRun();
      input=@(t,x,p)build.frequencyInput(t,x,p);
      timeRange=linspace(0,2/freq,100)
      data.input=input(timeRange,0,[freq amp dc]);
      data.time=2*timeRange/max(timeRange);
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
        time=[0 200*T(i)]
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
      controllers=dataLayer.ControlInputs_FullModels;
      controlInput=controllers.FullControlAutoregulatedModelControler_FMCalibration;
      controlInput(300,300)=0;
      model=build.fullAutoModelWith2dControl(controlInput);
      [time,state]=simulate(controlInput,model);
      data.FullControlAutoregulatedModelControler.time=time;
      data.FullControlAutoregulatedModelControler.state=state;
      controlInput=controllers.UniformControlAutoregulatedModelControler_FMCalibration;
      controlInput(300,300)=0;
      model=build.fullAutoModelWith2dControl(controlInput);
      [time,state]=simulate(controlInput,model);
      data.UniformControlAutoregulatedModelControler.time=time;
      data.UniformControlAutoregulatedModelControler.state=state;
      
      controlInput=controllers.FullControlUnregulatedModelControler_FMCalibration;
      controlInput(300,300)=0;
      model=build.fullUnregModelWith2dControl(controlInput);
      [time,state]=simulate(controlInput,model);
      data.FullControlUnregulatedModelControler.time=time;
      data.FullControlUnregulatedModelControler.state=state;
      
      controlInput=controllers.UniformControlUnregulatedModelControler_FMCalibration;
      controlInput(300,300)=0;
      model=build.fullUnregModelWith2dControl(controlInput);
      [time,state]=simulate(controlInput,model);
      data.UniformControlUnegulatedModelControler.time=time;
      data.UniformControlUnegulatedModelControler.state=state;
      
      controlInput=controllers.ReducedControlAutoregulatedModelControler_FMCalibration;
      controlInput(300,300)=0;
      model=build.fullAutoModelWith2dControl(controlInput);
      [time,state]=simulate(controlInput,model);
      data.ReducedControlAutoregulatedModelControler.time=time;
      data.ReducedControlAutoregulatedModelControler.state=state;
      function [time,state]=simulate(controlInput,model)
        controlInput(300,300)=0;
        model.controlInput=controlInput;
        ssa=SolverSSA(model);
        ssa.integrator=SSAIntegratorParsed;
        ssa.model.time=linspace(0,10,10*2+1);
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
      parameters=[1.0000,1.0932,1.0000,519.0960,0.0004,0.0024,2.0309 0.0257,1.2718];
      for i=1:5
        [ode{i},error(i)]=fit(parameters);
      end
      [~,minIndex]=min(error);
      parameters=ode{minIndex}.model.parameters;
      data.UnregulatedFullModelParameters=parameters;
      data.model=ode{minIndex}.model
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
        optimizer.strategy=optimizer.strategy.setLogBounds([-0 -5 -0 -5 -5 -5 -5 -5 -5 -5 -5 -5;
          4  4  0 4  4  4  4  4  4  4  4  4]);
        optimizer.strategy.subOptimizer.maxIter=5;
        optimizer.strategy.subOptimizer.initialRate=.2;
        optimizer.strategy.subOptimizer.minRate=.01;
        build = ModelFactoryTestModels;
        
        model=build.fullModelWithExperimentalInput;
        model.parameters=parameters;
        ode=SolverODE(model);
        dataIsGood=0;
        while dataIsGood==0
          tIsGood=zeros(size(model.initialState));
          ode=SolverODE(model);
          [tempode,error]=optimizer.visit(ode);
          odedata=tempode.run();
          for j=1:size(odedata.state,1)
            if any(odedata.state(j,:)>=5)&any(odedata.state(j,:)<=200);
              tIsGood(j)=1;
            end
          end
          if all(tIsGood(4))
            dataIsGood=1;
            ode=tempode;
          end
        end
        parameters=ode.model.parameters;
        parameters(2)=parameters(1)/20;
      end
    end
    function data=ModelFit_UnregulatedReducedModel()
      parameters=[1.0401e-05 0.0203 0.001753157638061];
      for i=1:5
        [ode{i},error(i)]=fit(parameters);
      end
      [~,minIndex]=min(error);
      parameters=ode{minIndex}.model.parameters;
      close all
      data.UnregulatedReducedModelParameters=parameters;
      data.model=ode{minIndex}.model;
      function [ode,error]=fit(parameters)
        realdata=KhammashTimeSeriesData;
        realdata.state=realdata.state./max(realdata.state).*20;
        optimizer=ParameterOptimizer;
        optimizer.index=1;
        optimizer.strategy=ParameterOptimizerBeeSwarm;
        indVec=[6,7,8 9 11 13 15 16 17 18 19];
        optimizer.strategy.subOptimizer.errorFunction=@(y,x)sum(((y(indVec)-x(indVec))./y(indVec)).^2)
        optimizer.data=realdata;
        optimizer.strategy.numBees=16;
        optimizer.strategy.numSteps=1;
        optimizer.strategy=optimizer.strategy.setLogBounds([-5 log10(.0203) -5;
                                                            4  log10(.0203)        5]);
        optimizer.strategy.subOptimizer.maxIter=5;
        optimizer.strategy.subOptimizer.initialRate=.05;
        optimizer.strategy.subOptimizer.minRate=.0001;
        build = ModelFactory;
        model=build.unregulatedModelWithExperimentalInput;
        model.parameters=parameters;
        ode=SolverODE(model);
        [ode,error]=optimizer.visit(ode);
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
      X=[]
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
        load data/controlers/FullControlerAutoregulatedModelControler.mat
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
      load data/controlers/FullControlerAutoregulatedModelControler_FullModelCalibration.mat
      data.FullControlAutoregulatedModelControler_FMCalibration=controlInput;
      
      load data/controlers/UniformControlerAutoregulatedModelControler_FullModelCalibration.mat
      data.UniformControlAutoregulatedModelControler_FMCalibration=controlInput;
      
      load data/controlers/FullControlerUnregulatedModelControler_FullModelCalibration.mat
      data.FullControlUnregulatedModelControler_FMCalibration=controlInput;
      
      load data/controlers/UniformControlerUnegulatedModelControler_FullModelCalibration.mat
      data.UniformControlUnregulatedModelControler_FMCalibration=controlInput;
      
      load data/controlers/ReducedControlerAutoregulatedModelControler_FullModelCalibration.mat
      data.ReducedControlAutoregulatedModelControler_FMCalibration=controlInput;
    end
    function data=ControlInputs_ReducedModels()
      load 'data/controlers/Controllers_ReducedModels.mat'
    end
    function data=ControlInputs_ReducedModelsOld()
      load data/controlers/FullControlerAutoregulatedModelControler.mat
      data.FullControlAutoregulatedModelControler_FMCalibration=controlInput;
      
      load data/controlers/UniformControlerAutoregulatedModelControler.mat
      data.UniformControlAutoregulatedModelControler_FMCalibration=controlInput;
      
      load data/controlers/FullControlerUnregulatedModelControler.mat
      data.FullControlUnregulatedModelControler_FMCalibration=controlInput;
      
      load data/controlers/UniformControlerUnegulatedModelControler.mat
      data.UniformControlUnregulatedModelControler_FMCalibration=controlInput;
      
      load data/controlers/ReducedControlerAutoregulatedModelControler.mat
      data.ReducedControlAutoregulatedModelControler_FMCalibration=controlInput;
    end
    function data=CalibrationCurveUnregulatedFullReduced()
      build=ModelFactoryTestModels;
      fullModel=build.fullModelWithUniformLight(0);
      unregModel=build.unregulatedModelWithUniformLight(0);
      uRange=0:5:1000;
      [upAnalysisR,downAnalysisR]=performAnalysis(unregModel,3,1,uRange);
      [upAnalysisF,downAnalysisF]=performAnalysis(fullModel,9,5,uRange);
      rangeProtein=[0:.01:80];
      trajectoryAF=interp1(upAnalysisF,uRange,rangeProtein);
      trajectoryAS=interp1(upAnalysisR,uRange,rangeProtein);
      calibration=[trajectoryAS;trajectoryAF];
      calibration(:,1)=0;
      data.uRange=uRange;
      data.upAnalysisReduced=upAnalysisR;
      data.downAnalysisReduced=downAnalysisR;
      data.upAnalysisFull=upAnalysisF;
      data.downAnalysisFull=downAnalysisF;
      data.calibration=calibration;
      function [upAnalysis,downAnalysis]=performAnalysis(model,lightIndex,speciesIndex,uRange)
        modelOde=SolverODE(model);
        analyzer=HisteresisAnalysis(modelOde);
        analyzer.time=linspace(0,700,70);
        analyzer.speciesIndex=speciesIndex;
        analyzer.uRange=uRange;
        [upAnalysis,downAnalysis]=analyzer.analyze(lightIndex);
        %plot(analyzer.uRange,upAnalysis,spec1,analyzer.uRange,downAnalysis,spec2);
        range=analyzer.uRange;
      end
    end
    function data=CalibrationCurveHysteresisCalibratedModel()
      layer=DataLayer();
      loaddata=layer.get('CalibrationCurveUnregulatedFullReduced');
      build=ModelFactoryTestModels;
      calibratedModel=build.calibratedFullAutoModel(loaddata.calibration);
      uRange=0:5:1000;
      [upAnalysisC,downAnalysisC]=performAnalysis(calibratedModel,13,5,uRange);
      data.upTrajectory=upAnalysisC;
      data.downTrajectory=downAnalysisC;
      data.range=uRange;
      function [upAnalysis,downAnalysis]=performAnalysis(model,lightIndex,speciesIndex,uRange)
        modelOde=SolverODE(model);
        analyzer=HisteresisAnalysis(modelOde);
        analyzer.time=linspace(0,30,50);
        analyzer.speciesIndex=speciesIndex;
        analyzer.uRange=uRange;
        [upAnalysis,downAnalysis]=analyzer.analyze(lightIndex);
        %plot(analyzer.uRange,upAnalysis,spec1,analyzer.uRange,downAnalysis,spec2);
        range=analyzer.uRange;
      end
    end
    function data=ModelFitODEUnregulatedReducedModel_Calibration()
      build=ModelFactory;
      x=build.fullU([1 3 2]);
      y=build.u([1 3 2]);
      data.calibration(1,:)=interp1(y,x,linspace(x(1),x(end)),'spline');
      data.calibration(2,:)=linspace(x(1),x(end));
      data.TruePoints=[x;y];
    end
    function data=ModelFitODE_UnregulatedFullModel()
      build=ModelFactoryTestModels;
      model=build.fullModelWithExperimentalInput;
      ode=SolverODE(model);
      trajectory=ode.run();
      data.time=trajectory.time;
      data.state=trajectory.state;
    end
    function data=ModelFitODE_UnregulatedReducedModel()
      build=ModelFactoryTestModels;
      model=build.unregulatedModelWithExperimentalInput;
      ode=SolverODE(model);
      trajectory=ode.run();
      data.time=trajectory.time;
      data.state=trajectory.state;
    end
    function data=ModelFitSSA_UnregulatedReducedModel_Low()
      build=ModelFactoryTestModels;
      model=build.unregulatedModelWithUniformLight(0);
      model.time=0:.5:5000;
      ode=SolverSSA(model);
      trajectory=ode.run();
      trajectory.trimInitial(2000);
      data.time=trajectory.node{1}.time;
      data.state=trajectory.node{1}.state;
    end
    function data=ModelFitSSA_UnregulatedReducedModel_Med()
      build=ModelFactoryTestModels;
      model=build.unregulatedModelWithUniformLight(20);
      model.time=0:.5:5000;
      ode=SolverSSA(model);
      trajectory=ode.run();
      trajectory.trimInitial(2000);
      data.time=trajectory.node{1}.time;
      data.state=trajectory.node{1}.state;
    end
    function data=ModelFitSSA_UnregulatedReducedModel_Hig()
      build=ModelFactoryTestModels;
      model=build.unregulatedModelWithUniformLight(320);
      model.time=0:.5:5000;
      ode=SolverSSA(model);
      trajectory=ode.run();
      trajectory.trimInitial(2000);
      data.time=trajectory.node{1}.time;
      data.state=trajectory.node{1}.state;
    end
    function data=ModelFitODE_ExperimentalData()
      realData=KhammashTimeSeriesData;
      data.time=realData.time;
      data.state=realData.state;
    end
    function data=AnalysisSSAFSPPredictiveModelControl()
      quartiles=[.80];
      data=getData(quartiles);
      function data=getData(quart)
        build=ModelFactory;
        load data/controlers/FullControlerAutoregulatedModelControler.mat
        controlInput(200,200)=0;
        time=0:.5:40000;
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
        for i=1:length(historyX)
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
        data.score=score.getScore(Pxy);
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
      uRange=0:5:1000;
      modelOde=SolverODE(model);
      analyzer=HisteresisAnalysis(modelOde);
      analyzer.time=linspace(0,1500,1500);
      analyzer.speciesIndex=speciesIndex;
      analyzer.uRange=uRange;
      [upAnalysis,downAnalysis]=analyzer.analyze(lightIndex);
      data.upTrajectory=upAnalysis;
      data.downTrajectory=downAnalysis;
      data.range=uRange;
    end
  end
end