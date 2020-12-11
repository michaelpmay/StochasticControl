addpath(genpath('utility/'))
pwd
clear all
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
    data=initialOde{i}.run;
    initialState=data.state(:,end);
    ode{i}.model=model{i};
    ode{i}.model.time=time;
    ode{i}.model.initialState=initialState;
    func{end+1}=@()ode{i}.run;
    pBucket=pBucket.add(func{end},{});
  end
end
data=pBucket.run();
save data/mat/FullModelFrequencyAnalysis.mat;