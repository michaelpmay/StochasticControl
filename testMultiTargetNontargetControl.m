build=ModelFactory
lightRange=linspace(0,2,40);
scorer=ProbabilityScore([100,100]);
C=scorer.makeC([100 100]);
for i=1:length(lightRange)
Z1=0;
Z2=zeros(50,50);
Z2(1:25,:)=lightRange(i);
Z2(100,100)=0;
U=@(t,x)Z1+(Z2(x(1)+1,x(3)+1)+Z2(x(1)+1,x(4)+1)+Z2(x(2)+1,x(3)+1)+Z2(x(2)+1,x(4)+1))/4;
model=build.nCellAutoregulatedModel(4,U);
model.time=linspace(0,20000,40001);
ssa=SolverSSA(model);
data=ssa.run;
y=[data.node{1}.state(1,:),data.node{1}.state(2,:)];
x=[data.node{1}.state(3,:),data.node{1}.state(4,:)];
probability{i}=zeros(100);
for j=1:length(x)
probability{i}(y(j)+1,x(j)+1)=probability{i}(y(j)+1,x(j)+1)+1;
end
probability{i}=probability{i}/sum(sum(probability{i}));
score(i)=C'*probability{i}(:);
end
plot(score);