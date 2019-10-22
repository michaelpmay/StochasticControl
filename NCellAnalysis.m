classdef NCellAnalysis
  properties
    model
    input={@(t,x)0,@(t,x)0,@(t,x)0,@(t,x)0}
    nRange=[1 2 4 8 16 32 64]
    time=linspace(0,10000,10000);
    trim=500;
  end
  methods
    function score=analyze(obj)
      for i=1:length(obj.nRange)
        for j=1:length(obj.input)
          score(j,i)=obj.analyzeSingleN(obj.nRange(i),obj.input{j})
        end
      end
    end
    function score=parallelAnalyze(obj)
      menu=ParallelMenu;
      for i=1:length(obj.nRange)
        for j=1:length(obj.input)
          menu=menu.add(@obj.analyzeSingleN,{obj.nRange(i),obj.input{j}})
        end
      end
      data=menu.run;
      k=1;
      for i=1:length(obj.nRange)
        for j=1:length(obj.input)
          score(j,i)=data{k};
          k=k+1;
        end
      end
    end
    function score=analyzeSingleN(obj,N,input)
      build=ModelFactory;
      model=build.infCellAutoregulatedModel(N+1,input);
      model.time=obj.time;
      ssa=SolverSSA(model);
      data=ssa.run();
      data.trimInitial(obj.trim);
      scorer=ProbabilityScore([200 200]);
      score=scorer.getSSATrajectoryScore(data);
    end
    
  end
end