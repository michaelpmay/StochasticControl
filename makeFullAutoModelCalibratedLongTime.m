clear all
addpath(genpath('utility'))
build=ModelFactoryTestModels;

load data/controlers/FullControlerAutoregulatedModelControler_FullModelCalibration.mat
controlInput(300,300)=0;
model1=build.fullAutoModelWith2dControl(controlInput);
[time,state]=simulate(controlInput,model1)
save makeFullAutoModelCalibratedLongTime_FullControler.mat

load data/controlers/UniformControlerAutoregulatedModelControler_FullModelCalibration.mat
controlInput(300,300)=0;
model1=build.fullAutoModelWith2dControl(controlInput);
[time,state]=simulate(controlInput,model1)
save makeFullAutoModelCalibratedLongTime_UniformControler.mat

load data/controlers/FullControlerUnregulatedModelControler_FullModelCalibration.mat
controlInput(300,300)=0;
model2=build.fullUnregModelWith2dControl(controlInput);
[time,state]=simulate(controlInput,model2)
save makeFullUnregModelCalibratedLongTime_FullControler.mat

load data/controlers/UniformControlerUnegulatedModelControler_FullModelCalibration.mat
controlInput(300,300)=0;
model2=build.fullUnregModelWith2dControl(controlInput);
[time,state]=simulate(controlInput,model2)
save makeFullUnregModelCalibratedLongTime_UniformControler.mat

function [time,state]=simulate(controlInput,model)
controlInput(300,300)=0;
%model=build.fullUnregModelWith2dControl(calibratedControlInput);
model.controlInput=controlInput;
ssa=SolverSSA(model);
ssa.model.time=linspace(0,20000,20000*2+1);
bucket=ParallelMenu;
ssa.integrator.verbose=true;
N=16
maxNumCompThreads(16)
for i=1:16
  bucket=bucket.add(@ssa.run,{});
end
data=bucket.run
for i=1:16
  time{i}=data{i}.node{1}.time;
  state{i}=data{i}.node{1}.state;
end
end
function output=calibration(input)
load data/file/makeAutoModelCalibration/calibration
vInput=input(:);
for i=1:length(vInput)
  output(i)=interp1(calibrationFS(1,:),calibrationFS(2,:),vInput(i));
  if vInput(i)<calibrationFS(1,1)
    output(i)=calibrationFS(2,1);
  end
  if vInput(i)>calibrationFS(1,end)
    output(i)=calibrationFS(2,end);
  end
end
output=reshape(output,size(input));
end
