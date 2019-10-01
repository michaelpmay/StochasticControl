addpath classes
build=ModelFactory;
lightOnModel=build.unregulatedModelWithConstantLight(2)
lightOnModel.time=linspace(0,5000,20000);
lightOffModel=build.unregulatedModelWithConstantLight(0)
ligntOffModel.time=linspace(0,5000,20000);

onSSA=SolverSSA(lightOnModel);
onData=onSSA.run();
onData=onData.trimInitial(2000);
onData=IntensityMapSSAData(onData);

offSSA=GenericSSA(lightOffModel);
offData=offSSA.run();
offData=offData.trimInitial(2000);
offData=IntensityMapSSAData(offData);

mu=2000
sig=2000
nbins=100
figure()
hold on
plotBiExponentialIntensityHistogram(mu,sig,nbins,'r-');
plotBiExponentialIntensityHistogram(mu,sig,nbins,'b-');
hold off