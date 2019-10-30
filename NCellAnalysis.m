classdef NCellAnalysis
  properties
    model
    input={@(t,x)0,@(t,x)0,@(t,x)0,@(t,x)0}
    nRange=[1 2 4 8 16 32 64]
    time=linspace(0,50000,50000);
    trim=500;
  end
  methods
    function score=analyze(obj,varargin)
      if length(varargin)==0
        score=obj.analyzeFromArray();
      else
        score=obj.analyzeFromList(varargin{1});
      end
    end
    function score=analyzeFromArray(obj)
      for i=1:length(obj.nRange)
        for j=1:length(obj.input)
          score(j,i)=obj.analyzeSingleN(obj.nRange(i),obj.input{j},i,j);
        end
      end
    end
    function score=analyzeFromList(obj,list)
      for i =1:length(list)
        m=list{i}(1);
        n=list{i}(2);
        score(m,n)=obj.analyzeSingleN(obj.nRange(m),obj.input{n},m,n);
      end
    end
    function score=parallelAnalyzeWithFileName(obj,filename)
      score=obj.parallelAnalyzeFromArray();
      save(filename,'score');
    end
    function score=parallelAnalyze(obj,varargin)
      menu=ParallelMenu;
      if length(varargin)==0;
        score=obj.parallelAnalyzeFromArray;
      else
        score=obj.parallelAnalyzeFromList(varargin{1});
      end
    end
    function score=parallelAnalyzeFromArray(obj)
      menu=ParallelMenu;
      for i=1:length(obj.nRange)
        for j=1:length(obj.input)
          menu=menu.add(@obj.analyzeSingleN,{obj.nRange(i),obj.input{j},i,j});
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
    function score=parallelAnalyzeFromList(obj,list)
      menu=ParallelMenu;
      for i=1:length(list)
        n=list{i}(1);
        m=list{i}(2);
        menu=menu.add(@obj.analyzeSingleN,{obj.nRange(n),obj.input{m},n,m});
      end
      data=menu.run;
      for i=1:length(data)
        n=list{i}(1);
        m=list{i}(2);
        score(m,n)=data{i};
      end
    end
    function score=analyzeSingleN(obj,N,input,i,j)
      build=ModelFactory;
      model=build.infCellAutoregulatedModel(N+1,input);
      model.time=obj.time;
      ssa=SolverSSA(model);
      data=ssa.run();
      data.trimInitial(obj.trim);
      scorer=ProbabilityScore([200 200]);
      score=scorer.getSSATrajectoryScore(data);
      save(['score/score_',num2str(i),num2str(j)],'score')
      fprintf('Completed %i \n',N);
    end
  end
end
