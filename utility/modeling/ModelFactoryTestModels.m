classdef ModelFactoryTestModels < ModelFactory
  properties
    
  end
  methods
    function model=khammashFullModelWithLightInputFreeU(obj)
      load data/parameters/khammashFullModelWithLightInputFreeU.mat
      model=obj.khammashFullModel;
      model.parameters=parameters;
      model.rxnRate=@(t,x,p)[p(1);
        (p(1)/20)*x(1);
        3*p(1);
        (p(1)/20)*x(2);
        (p(3)+obj.ExperimentalInput(t,x,[p(9:11)]))*x(1)*x(2);
        p(4)*x(3);
        p(5)*x(3);
        p(6)*x(3)*(obj.maxGenes-x(4));
        p(7)*x(4);
        p(8)*x(4);
        obj.ga*x(5)];
    end
    function model=khammashFullModelWithLightInputFixedU(obj)
      load data/parameters/khammashFullModelWithLightInputFixedU.mat
      model=obj.khammashFullModel;
      model.parameters=parameters;
      model.rxnRate=@(t,x,p)[p(1);
        (p(1)/20)*x(1);
        3*p(1);
        (p(1)/20)*x(2);
        (p(3)+obj.ExperimentalInput(t,x,[320 0 20]))*x(1)*x(2);
        p(4)*x(3);
        p(5)*x(3);
        p(6)*x(3)*(obj.maxGenes-x(4));
        p(7)*x(4);
        p(8)*x(4);
        obj.ga*x(5)];
    end
    function model=khammashFullModelPooledT7FixedU(obj)
      load data/parameters/khammashModelPooledT7FixedU.mat
      model=obj.makeModelObject();
      model.stoichMatrix=[-1 -1  1  0  0;%p(3)*x(1)*x(2); 
                           1  1 -1  0  0;%p(4)*x(3);
                           0  0 -1  0  0;%p(5)*x(3);
                           0  0 -1  1  0;
                           0  0  1 -1  0;
                           0  0  0  0  1;
                           0  0  0  0 -1]';
      model.parameters=parameters;
      model.rxnRate=@(t,x,p)[
        (p(1)*obj.ExperimentalInput(t,x,[320 0 20]))*x(1)*x(2);
        p(2)*x(3);
        p(3)*x(3);
        p(4)*x(3)*(obj.maxGenes-x(4));
        p(5)*x(4);
        p(6)*x(4);
        obj.ga*x(5)];
      model.initialState=[100;300;0;0;0]
      model.time=obj.time;
    end
    function model=khammashFullModelPooledT7FreeU(obj)
      load data/parameters/khammashModelPooledT7FreeU.mat
      model=obj.khammashFullModelPooledT7FixedU
      model.parameters=parameters;
      model.rxnRate=@(t,x,p)[
        (p(1)*obj.ExperimentalInput(t,x,p(9:11)))*x(1)*x(2);
        p(2)*x(3);
        p(3)*x(3);
        p(4)*x(3)*(obj.maxGenes-x(4));
        p(5)*x(4);
        p(6)*x(4);
        obj.ga*x(5)];
    end
  end
end