addpath('classes');
model=ModelSSA(AutoregulatedParameters);
U=50*rand(1,200);
model.parameters.inputSignal=@(x,t)U(x+1);
model.time=[0,20];
data=model.runTrajectory;
figure();
subplot(1,2,1)
data.plotState;
subplot(1,2,2)
data.plotInputSignal;
%%
model.controlInput=@(x,t)U(round(mean(x+1)))
data=model.runJointSSA(5);
figure();
subplot(1,2,1);
subplot(1,2,2)
data.plotInputSignal;
