build=ModelFactoryTestModels
model=build.fullModelWithExperimentalInput;
%model.parameters(1)=model.parameters(1)/12366*20;
%model.parameters(3:end)=model.parameters(3:end)/12366*20;
model.time=0:1:5000
figure 
hold on
u=[0 20 320]
for i=1:length(u)
model.parameters(end-2:end)=u(i)
ssa=SolverSSA(model)
data=ssa.run(10)
view=ViewSSA(data,subplot(2,2,i))
view.plotSnapshotHistogram(1,1000:5000,0:60)
end
