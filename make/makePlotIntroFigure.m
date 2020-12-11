clear all
addpath(genpath('utility'))
build=ModelFactoryTestModels
fum=build.fullModelWithExperimentalInput;
rum=build.unregulatedModelWithExperimentalInput;
realData=KhammashTimeSeriesData;
models={rum,fum}
ind=1
for i=1:length(models)
  ode=SolverODE(models{i})
  data{i}=ode.run;
end

AcademicFigure
hold on
plot(data{1}.time,data{1}.state,'Linewidth',3)
plot(data{2}.time,data{2}.state(5,:),'r-.','Linewidth',3)
plot(realData.time,realData.state/max(realData.state)*20,'k.','MarkerSize',24)
ylim([0 21])
xlabel('time (minutes)')
ylabel('Species Count')

%% DO SSA ANALYSIS
fum1=build.fullModelWithLightInput(320);
fum2=build.fullModelWithLightInput(20);
fum3=build.fullModelWithLightInput(0);
rum1=build.unregulatedModelWithUniformLight(320);
rum2=build.unregulatedModelWithUniformLight(20);
rum3=build.unregulatedModelWithUniformLight(0);
models={rum1,rum2,rum3,fum1,fum2,fum3};
parfor i=1:length(models)
  models{i}.time=linspace(0,1000);
  ssa{i}=SolverSSA(models{i});
  data{i}=ssa{i}.run;
end


AcademicFigure
subplot(1,2,1)
hold on
plot(data{1}.node{1}.time,data{1}.node{1}.state)
