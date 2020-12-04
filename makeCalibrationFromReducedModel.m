clear all
load data/controlers/FullControlerAutoregulatedModelControler.mat
controlInput=calibration(controlInput)
save data/controlers/FullControlerAutoregulatedModelControler_FullModelCalibration.mat

load data/controlers/FullControlerUnregulatedModelControler.mat
controlInput=calibration(controlInput)
save data/controlers/FullControlerUnregulatedModelControler_FullModelCalibration.mat

load data/controlers/UniformControlerAutoregulatedModelControler.mat
controlInput=calibration(controlInput)
save data/controlers/UniformControlerAutoregulatedModelControler_FullModelCalibration.mat

load data/controlers/UniformControlerUnegulatedModelControler.mat
controlInput=calibration(controlInput)
save data/controlers/UniformControlerUnegulatedModelControler_FullModelCalibration.mat

load data/controlers/ReducedControlerAutoregulatedModelControler.mat
controlInput=calibration(controlInput)
save data/controlers/ReducedControlerAutoregulatedModelControler_FullModelCalibration.mat

load data/controlers/UniformControlerAutoregulatedModelControler_FullModelCalibration.mat
subplot(1,5,1)
pcolorProbability(controlInput)

load data/controlers/UniformControlerUnegulatedModelControler_FullModelCalibration.mat
subplot(1,5,2)
pcolorProbability(controlInput)

load data/controlers/FullControlerUnregulatedModelControler_FullModelCalibration.mat
subplot(1,5,3)
pcolorProbability(controlInput)

load data/controlers/FullControlerAutoregulatedModelControler_FullModelCalibration.mat
subplot(1,5,4)
pcolorProbability(controlInput)

load data/controlers/ReducedControlerAutoregulatedModelControler_FullModelCalibration.mat
subplot(1,5,5)
pcolorProbability(controlInput)

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
