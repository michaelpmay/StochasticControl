load data/controlers/FullControlerAutoregulatedModelControler.mat
controlInput=controlInput*320/20/.0203
save('data/controlers/FullControlerAutoregulatedModelControler','controlInput')

load data/controlers/UniformControlerAutoregulatedModelControler.mat
controlInput=controlInput*320/20/.0203
save('data/controlers/UniformControlerAutoregulatedModelControler','controlInput')

load data/controlers/FullControlerUnregulatedModelControler.mat
controlInput=controlInput*320/20/.0203
save('data/controlers/FullControlerUnregulatedModelControler','controlInput')

load data/controlers/UniformControlerUnegulatedModelControler.mat
controlInput=controlInput*320/20/.0203
save('data/controlers/UniformControlerUnegulatedModelControler','controlInput')

load data/controlers/ReducedControlerAutoregulatedModelControler
controlInput=controlInput*320/20/.0203
save('data/controlers/ReducedControlerAutoregulatedModelControler','controlInput')

%%

load data/controlers/FullControlerAutoregulatedModelControler_FullModelCalibration.mat
controlInput=controlInput*320/20/.0203
save('data/controlers/FullControlerAutoregulatedModelControler_FullModelCalibration','controlInput')

load data/controlers/UniformControlerAutoregulatedModelControler_FullModelCalibration.mat
controlInput=controlInput*320/20/.0203
save('data/controlers/UniformControlerAutoregulatedModelControler_FullModelCalibration','controlInput')

load data/controlers/FullControlerUnregulatedModelControler_FullModelCalibration.mat
controlInput=controlInput*320/20/.0203
save('data/controlers/FullControlerUnregulatedModelControler_FullModelCalibration','controlInput')

load data/controlers/UniformControlerUnegulatedModelControler_FullModelCalibration.mat
controlInput=controlInput*320/20/.0203
save('data/controlers/UniformControlerUnegulatedModelControler_FullModelCalibration','controlInput')

load data/controlers/ReducedControlerAutoregulatedModelControler_FullModelCalibration
controlInput=controlInput*320/20/.0203
save('data/controlers/ReducedControlerAutoregulatedModelControler_FullModelCalibration','controlInput')
