addpath classes
optimizer=ParameterOptimizer;
optimizer.realData=KhammashTimeSeriesData();
optimizer.maxIter=5000;
optimizer.initialRate=.001;
optimizer.minRate=.00001;
opt=OptimalModelLoader;
opt.folderName='outFiles/odeOptimization/';
model={};
error=[];
n=32;
m=2;
name='OptimalOde'  ;
maxNumCompThreads(8);

while 1
  for i=1:n
    model{i}=opt.loadODE(name);
  end
  parfor(i=1:32,8)
    for j=1:m
      [model{i},error(i)]=optimizeMyODE(optimizer,model{i},name);
      j
    end
  end
end

function [model,error]=optimizeMyODE(optimizer,model,name)
model.time=optimizer.realData.time;
[model,error]=model.accept(optimizer);
optimizer.model=model;
scoreString=num2str(error);
scoreString=strrep(scoreString,'.','_');
model.saveAs([name,'_',scoreString],'outFiles/odeOptimization');
end
