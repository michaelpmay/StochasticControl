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
              for i=1:length(obj.nRange)
                  for j=1:length(obj.input)
                      score(j,i)=obj.analyzeSingleN(obj.nRange(i),obj.input{j},i,j);
                  end
              end
          else
              list=varargin{1};
              for i =1:length(list)
                  score(j,i)=obj.analyzeSingleN(obj.nRange(list{i}(1)),obj.input{list{i}(2)},list{i}(1),list{i}(2));
              end
          end
      end
    function score=parallelAnalyze(obj,varargin)
      menu=ParallelMenu;
      if length(varagin)=0;
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
      else
        list=varargin{1};
        for i=1:length(list)
          menu=menu.add(@obj.analyzeSingleN,{obj.nRange(list{i}(1)),obj.input{list{i}(2)},list{i}(1),list{i}(2)});
        end
        data=menu.run;
        for i=1:length(data)
          score(list{i}(2),list{i}(1))=data{i}
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
