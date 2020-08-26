clear all
addpath(genpath('utility'))
load data/controlers/ReducedControlerAutoregulatedModelControler.mat
controlInput=controlInput(1:end,:)
calibratedControlInput=calibration(controlInput);
calibratedControlInput(500)=0;
build=ModelFactoryTestModels;
shortTime=-10:.5:10;
model{1}=build.twoCellSwapInitialCondition(calibratedControlInput,[000 000]);
model{1}.time=shortTime;
%model{2}=build.twoCellSwapInitialCondition(calibratedControlInput,[000 250]);
% model{2}.time=shortTime;
%model{3}=build.twoCellSwapInitialCondition(calibratedControlInput,[250 000]);
% model{3}.time=shortTime;
%model{4}=build.twoCellSwapInitialCondition(calibratedControlInput,[250 250]);
% model{4}.time=shortTime;
for i=1:length(model)
ssa=SolverSSA(model{i});
ssa.integrator.verbose=true;
data{i}=ssa.run();
end

function output=calibration(input)
      load data/file/makeAutoModelCalibration/calibration
for i=1:length(input)
output(i)=interp1(calibrationFS(1,:),calibrationFS(2,:),input(i));
if input(i)<calibrationFS(1,1)
  output(i)=calibrationFS(2,1);
end
if input(i)>calibrationFS(1,end)
  output(i)=calibrationFS(2,end);
end
end
[maxVal,maxInd]=max(output);
output(1:maxInd)=maxVal;
end
