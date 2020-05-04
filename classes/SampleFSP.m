classdef SampleFSP
  properties
    dims=[50 50]
    uRange=linspace(0,1,100)
    feedbackControl
  end
  properties(Hidden)
    generatorSet={}
    steadyStateProbability
  end
  methods
    function obj=SampleFSP(controler)
      obj.feedbackControl=controler;
    end
    function run(obj)
      obj=obj.updateGeneratorSet(obj.uRange);
      obj=obj.updateSteadyStateProbability();
      [xIterFsp,yIterFsp]=makeXYIterFSP(obj);
      error=getError(xIterFSP.getLast,yIterFSP.getLast);
      for i=1:length(time)
        u=obj.getInput(error);
        xIterFsp.step(obj.generatorSet{i},time);
        yIterFsp.step(obj.generatorSet{i},time);
        error=getError(xIterFSP.getLast,yIterFSP.getLast);
      end
    end
    function obj=updateSteadyStateProbability(obj)
      modelFsp=TwoCellFSP(obj.getModel(0),obj.dims);
      load inFiles/autoregulatedReducedControler_110gmres.mat
      modelFsp.model.controlInput=repmat(controlInput,[50 1]);
      obj.steadyStateProbability=modelFsp.getSteadyStateReshape;
    end
    function [xIterFsp,yIterFsp]=makeXYIterFSP(obj)
      modelFsp=TwoCellFSP(obj.getModel(0),obj.dims);
      load inFiles/autoregulatedReducedControler_110gmres.mat
      modelFsp.model.controlInput=repmat(controlInput,[50 1]);
      probability=modelFsp.getSteadyStateReshape;
      Px=sum(probability,1);
      Py=sum(probability,2);
      xIterFsp=IterableFsp;
      xIterFsp.state=Px;
      yIterFsp=IterableFsp;
      yIterFsp.state=Py;
    end
    function obj=updateGeneratorSet(obj,uRange)
      generator=FSPGenerator1D;
      generator.dims=[50];
      for i=1:length(uRange)
        model=obj.getModel(uRange(i));
        obj.generatorSet{i}=generator.getInfGenerator(model,obj.dims(1));
      end
    end
    function model=getModel(obj,input)
      build=ModelFactory;
      model=build.autoregulatedModelWithUniformInput(input);
    end
  end
end