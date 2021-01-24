addpath(genpath('utility/'))
%load AutomatedFullModelParameterSearch.mat
build=ModelFactoryTestModels;
model{1}=build.fullAutoModelWithFrequencyInput(.01,.2,.2);
model{2}=build.fullAutoModelWithFrequencyInput(.1,.2,.2);
model{3}=build.fullAutoModelWithFrequencyInput(1,.2,.2);
ode{1}=SolverODE(model{1});
parfor i=1:length(optParameters)
  data{i}=dataRun(optParameters{i});
end

for i=1:size(data,1)
  for j=1:size(data,2)
    time{i,j}=data{i}{j}.time;
    state{i,j}=data{i}{j}.state;
  end
end
function data=dataRun(parameters)
build=ModelFactoryTestModels;
model{1}=build.fullAutoModelWithFrequencyInput(.1,.2,.2);
model{2}=build.fullAutoModelWithFrequencyInput(1,.2,.2);
model{3}=build.fullAutoModelWithFrequencyInput(10,.2,.2);
for j=1:length(model)
    model{j}.parameters(1:9)=parameters;
    model{j}.time=linspace(0,2000,2000*2+1);
    ode{j}=SolverODE(model{j});
    data{j}=ode{j}.run
  end
end