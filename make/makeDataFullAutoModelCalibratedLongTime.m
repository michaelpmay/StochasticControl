clear all
addpath(genpath('utility'))
build=ModelFactoryTestModels;

load data/controlers/FullControlerAutoregulatedModelControler_FullModelCalibration.mat
controlInput(300,300)=0;
model=build.fullAutoModelWith2dControl(controlInput);
[time,state]=simulate(controlInput,model)
save makeFullAutoModelCalibratedLongTime_FullControler.mat

load data/controlers/UniformControlerAutoregulatedModelControler_FullModelCalibration.mat
controlInput(300,300)=0;
model=build.fullAutoModelWith2dControl(controlInput);
[time,state]=simulate(controlInput,model)
save makeFullAutoModelCalibratedLongTime_UniformControler.mat

load data/controlers/FullControlerUnregulatedModelControler_FullModelCalibration.mat
controlInput(300,300)=0;
model=build.fullUnregModelWith2dControl(controlInput);
[time,state]=simulate(controlInput,model)
save makeFullUnregModelCalibratedLongTime_FullControler.mat

load data/controlers/UniformControlerUnegulatedModelControler_FullModelCalibration.mat
controlInput(300,300)=0;
model=build.fullUnregModelWith2dControl(controlInput);
[time,state]=simulate(controlInput,model)
save makeFullUnregModelCalibratedLongTime_UniformControler.mat

load data/controlers/ReducedControlerAutoregulatedModelControler_FullModelCalibration.mat
controlInput(300,300)=0;
model=build.fullAutoModelWith2dControl(controlInput);
[time,state]=simulate(controlInput,model)
save makeFullAutoModelCalibratedLongTime_ReducedControler.mat


function [time,state]=simulate(controlInput,model)
controlInput(300,300)=0;
%model=build.fullUnregModelWith2dControl(calibratedControlInput);
model.controlInput=controlInput;
ssa=SolverSSA(model);
ssa.integrator=SSAIntegratorParsed
ssa.model.time=linspace(0,10000,10000*2+1);
bucket=ParallelMenu;
ssa.integrator.verbose=true;
N=24
maxNumCompThreads(N)
for i=1:N
  bucket=bucket.add(@ssa.run,{});
end
data=bucket.run
for i=1:N
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
