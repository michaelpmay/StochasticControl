classdef ModelFactoryTestModels < ModelFactory
  properties
    fullModelParameters=[1.1164,1.1164/20,1.0000,579.5275,0.0004,0.0024,2.0309,0.0257,1.2718]
  end
  methods
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
      model=obj.khammashFullModel;
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
      model=obj.khammashFullModel;
      model.parameters=obj.fullModelParameters;
      model.rxnRate=@(t,x,p)[p(1);
        (p(2))*x(1);
        3*p(1);
        (p(2))*x(2);
        (p(3)*obj.ExperimentalInput(t,x,[320 0 20]))*x(1)*x(2);
        p(4)*x(3);
        (p(5))*x(3);
        p(6)*x(3)*(obj.maxGenes-x(4));
        (p(7))*x(4);
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
    function model=semiFullModel(obj)
      model=obj.makeModelObject;
      model.parameters=[1.0000 1/20 0.0500 1/20 1.0000 4.2060 0.0014 0.3154 25.8416 0.0048 obj.ga];
      model.time=linspace(1,170);
      model.stoichMatrix=[1 0 0;
        -1 0 0;
        -1 1 0;
        1 -1 0;
        0 0 1;
        0 0 -1;]';
      model.rxnRate=@rateEq;
      model.initialState=[0 0 0];
      function rate=rateEq(t,x,p)
        %x1 x2 x3 x4 x5 = X1 X2 x1 x2 x3
        a=p(4)*p(5);
        b=(-p(1)*p(5)+p(2)*p(4)-p(3)*p(5));
        c=(-p(2)*p(3)-p(6)*p(2)*x(1));
        X(2)=max([(-b-sqrt(b^2-4*a*c))/(2*a), (-b+sqrt(b^2-4*a*c))/(2*a)]);
        X(1)=(p(1) + p(6)*x(1))/(p(2)+p(5)*X(2))
        rate(1)=p(5)*X(1)*X(2);
        rate(2)=(p(6)+p(7))*x(1) ;
        rate(3)=p(8)*x(1)*(obj.maxGenes - x(1));
        rate(4)=p(9)*x(2);
        rate(5)=p(10)*x(2);
        rate(6)=p(11)*x(3);
        rate=rate';
      end
    end
    function model=calibratedFullAutoModel(obj,calibration)
      model=obj.fullModelWithExperimentalInput;
      model.parameters(end+1)=0;
      model.rxnRate=@(t,x,p)[
        p(1);
        (p(2))*x(1);
        3*p(1);
        (p(2))*x(2);
        (p(3)*interp1(calibration(1,:),calibration(2,:),p(13)))*x(1)*x(2);
        p(4)*x(3);
        (p(5))*x(3);
        p(6)*x(3)*(obj.maxGenes-x(4));
        (p(7))*x(4);
        p(8)*x(4)+hill(x(5),p(9),p(10),p(11),p(12));
        obj.ga*x(5)];
    end
    function model=fullAutoModel(obj)
      model=obj.fullModelWithExperimentalInput;
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
    function model=fullAutoModelWithInput(obj)
      model=obj.fullAutoModel;
      model.parameters(13)=[1];
      model.rxnRate=@(t,x,p)[
        p(1);
        (p(2))*x(1);
        3*p(1);
        (p(2))*x(2);
        (p(3)*p(13))*x(1)*x(2);
        p(4)*x(3);
        (p(5))*x(3);
        p(6)*x(3)*(obj.maxGenes-x(4));
        (p(7))*x(4);
        p(8)*x(4)+hill(x(5),p(9),p(10),p(11),p(12));
        obj.ga*x(5)];
    end
    function model=calibratedFullAutoModelWithFrequencyInput(obj,freq,amp,dc)
      
      load('data/file/makeAutoModelCalibration/calibration')
      model=obj.fullAutoModel;
      calibrationFS=calibrationFS;
      input=@(t)amp*sin(2*pi*freq*t)+dc;
      cInput=@(t)interp1(calibrationFS(1,:),calibrationFS(2,:),input(t))
      model.rxnRate=@(t,x,p)[
        p(1);
        (p(2))*x(1);
        3*p(1);
        (p(2))*x(2);
        (p(3)*cinput(t))*x(1)*x(2);
        p(4)*x(3);
        (p(5))*x(3);
        p(6)*x(3)*(obj.maxGenes-x(4));
        (p(7))*x(4);
        p(8)*x(4)+hill(x(5),p(9),p(10),p(11),p(12));
        obj.ga*x(5)];
      function output=cinput(t)
        input=@(t)amp*sin(2*pi*freq*t)+dc;
        output=interp1(calibrationFS(1,:),calibrationFS(2,:),input(t));
        if isnan(output)
          output=calibrationFS(2,end);
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
      model=obj.fullAutoModelWithInput();
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
  end
end