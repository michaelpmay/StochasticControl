addpath(genpath('utility/'))
clear all
build=ModelFactoryTestModels
load data/controlers/ReducedControlerAutoregulatedModelControler.mat
controlInput=controlInput(1:end,:)
controlInput(1000)=0;
calibratedControlInput=calibration(controlInput)
timeChange=1000;
relaxationTime=500;
model=build.fullAutoregulatedModelNCellSwap(calibratedControlInput,3,3,timeChange,relaxationTime)
ssa=SolverSSA(model);
ssa.integrator.verbose=true;
N=16
parfor i=1:N
  data{i}=ssa.run();
end
for i=1:N
  time{i}=data{i}.node{1}.time;
  state{i}=data{i}.node{1}.state;
end
save data/file/makeFullAutoregulatedModel3CellSwap/workspace_only16.mat
load data/file/makeFullAutoregulatedModel3CellSwap/workspace_only16.mat

for k=1:5
figure 
for i=1:N
 subplot(4,4,i)
 hold on
plot(time{i},state{i}(k,:))
plot(time{i},state{i}(k+5,:))
plot(time{i},state{i}(k+10,:))
end
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