clear all
addpath(genpath('utility'))
load data/controlers/ReducedControlerAutoregulatedModelControler.mat
controlInput=controlInput(1:end,:)
controlInput2=controlInput;
[maxValue,maxIndex]=max(max(controlInput2));
controlInput2(1:maxIndex)=maxValue;
calibratedControlInput=calibration(controlInput);
calibratedControlInput(500)=0;
calibratedControlInput2=calibration(controlInput2);
calibratedControlInput2(500)=0;
build=ModelFactoryTestModels;
shortTime=-10:.5:10;
initialInput={[000 000],[000 250],[250 000],[250 250]};
controlInputs={controlInput,controlInput2}

ind=1
for k=1:2
  for i=1:2   
    for j=1:4
      model{ind}=build.twoCellSwapInitialCondition(controlInputs{k} ,initialInput{j});
      ind=ind+1;
    end
  end
end

parfor i=1:length(model)
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
