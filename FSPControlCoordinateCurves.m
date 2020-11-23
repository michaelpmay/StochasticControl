build=ModelFactory;
model=build.birthDecayToyModel;
model.rxnRate=@(t,x,p)[1;1]
fsp=SolverFSP(model,[3])
fsp.model.initialState=[1 0 0]';
fsp.model.time=linspace(0,100,1000)
A=fsp.getInfGenerator
B=[-1 0 0;
  1 -1 0;
  0 1 0]
u=[0,0,0];
uRange=linspace(0,50,100)
du=.05
numSteps=5000
hold on
plot3([1 0 0 1],[0 1 0 0 ],[0 0 1 0])
for i=1:5
  u=[0 i 0]
  L=A+B.*u;
  P=null(L);
  P=P./sum(P);
  for j=1:numSteps
    L=A+B.*u;
    grad=-pinv(L)*(B.*P(:,end)')
    P(:,end+1)=P(:,end)+grad(:,1)*du;
    u(1)=u(1)+du;
    plot3(P(1,:),P(2,:),P(3,:))
  end
end