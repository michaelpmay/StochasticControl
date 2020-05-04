clc;clear all;
addpath('classes');
model=ReducedModelFSP;
controler=ControlerOptimizer(model);
controler.initialRate=3;
controler.gradCutoffIndex=1500;
optimizedControler=controler.optimizeControler(20);
optimizedControler.saveTo('outFiles')