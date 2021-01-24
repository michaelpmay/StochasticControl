function output=fullModelCalibration(input)
load data/file/makeAutoModelCalibration/calibration.mat
for i=1:length(input)
output(i)=interp1(calibrationFS(1,:),calibrationFS(2,:),input(i));
if input(i)<calibrationFS(1,1)
  output(i)=calibrationFS(2,1);
end
if input(i)>calibrationFS(1,end)
  output(i)=calibrationFS(2,end);
end
end