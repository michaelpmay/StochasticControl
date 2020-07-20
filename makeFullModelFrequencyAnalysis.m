addpath(genpath('utility/'))
clear all
builder=ModelFactoryTestModels;
wRange=logspace(-4,-2,4);
deltaT=2./wRange;
tStep=deltaT/80;
amp=.2;
dc=.2;%dc > amp at all times!!
minTime=4000 

numCycles=100
pBucket=ParallelMenu
func={}
for j=1:3
  for i=1:length(wRange)
    tEnd=20./wRange(i);
    time=0:tStep(i):tEnd;
    ode{i}=SolverODE
    switch j
      case 1
        model{i}=builder.fullAutoModelWithFrequencyInput(wRange(i),amp,dc)
        initialmodel{i}=builder.fullAutoModelWithFrequencyInput(wRange(i),0,dc)
      case 2
        model{i}=builder.autoregulatedModelWithFrequencyInput(wRange(i),amp,dc)
        initialmodel{i}=builder.autoregulatedModelWithFrequencyInput(wRange(i),0,dc)
      case 3
        model{i}=builder.calibratedFullAutoModelWithFrequencyInput(wRange(i),amp,dc)
        initialmodel{i}=builder.calibratedFullAutoModelWithFrequencyInput(wRange(i),0,dc)
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

data=pBucket.run()

figure
subplot(1,3,1)
hold on
ind=1;
for i=1:length(wRange)
  plot(data{i}.state(5,(end-80):end),'Linewidth',2)
  %xlim([data2{i}.time(end)-deltaT(i) data2{i}.time(end)])
  ind=ind+1;
end
legend('0.0001','.001','.01','.1')

subplot(1,3,2)
hold on
ind=1;
for i=1:length(wRange)
  plot(data{i+4}.state(1,(end-80):end),'Linewidth',2)
  %xlim([data1{i}.time(end)-deltaT(i) data1{i}.time(end)])
  ind=ind+1;
end
legend('0.0001','.001','.01','.1')

subplot(1,3,3)
hold on
ind=1;
for i=1:length(wRange)
  plot(data{i+8}.state(5,(end-80):end),'Linewidth',2)
  %xlim([data1{i}.time(end)-deltaT(i) data1{i}.time(end)])
  ind=ind+1;
end
legend('0.0001','.001','.01','.1')
