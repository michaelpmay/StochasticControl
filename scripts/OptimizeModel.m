addpath classes
warning('off','all')
parameters=UnregulatedParameters()
parfor k=1:16
  optimizedModel{k}=optimizeMyModel(parameters)
end

function model=optimizeMyModel(parameters)
model=ModelFSP(parameters);
model.controlInput=15*ones(size(model.controlInput));
controler=ControlerOptimizer(model);
controler.gradCutoffIndex=randi([0,2000]);
rate=rand()*5;
for i=1:20
  print(num2str(i));
  controler.initialRate=rate;
  [controler,~]=controler.optimizeControler(5);
  controler.saveTo('outFiles');
  rate=rate/.1;
end
end