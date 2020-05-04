clear all
build=ModelFactory
model=build.birthDecayToyModel;
ssa=SolverSSA;
ssa.model=model
ssa.run