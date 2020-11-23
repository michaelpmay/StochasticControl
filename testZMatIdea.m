clear all
build=ModelFactory
lightRange=linspace(0,2,40);
numCells=[2,4,6,8]
scorer=ProbabilityScore([100,100]);
C=scorer.makeC([100 100]);
figure
for k=1:length(numCells)
for i=1:length(lightRange)
Z2=zeros(50,50);
Z2(1:25,:)=lightRange(i);
Z2(100,100)=0;  
Z1=0;
switch k
    case 1
      U=@(t,x)Z1+(Z2(x(1)+1,x(2)+1));
    case 2
      U=@(t,x)Z1+(Z2(x(1)+1,x(3)+1)+Z2(x(1)+1,x(4)+1)+Z2(x(2)+1,x(3)+1)+Z2(x(2)+1,x(4)+1))/4;
    case 3
      U=@(t,x)Z1+(Z2(x(1)+1,x(4)+1)+Z2(x(1)+1,x(5)+1)+Z2(x(1)+1,x(6)+1)+Z2(x(2)+1,x(4)+1)+Z2(x(2)+1,x(5)+1)+Z2(x(2)+1,x(6)+1)+Z2(x(3)+1,x(4)+1)+Z2(x(3)+1,x(5)+1)+Z2(x(3)+1,x(6)+1))/9;
    case 4
      U=@(t,x)Z1+(Z2(x(1)+1,x(5)+1)+Z2(x(1)+1,x(6)+1)+Z2(x(1)+1,x(7)+1)+Z2(x(1)+1,x(8)+1)+Z2(x(2)+1,x(5)+1)+Z2(x(2)+1,x(6)+1)+Z2(x(2)+1,x(7)+1)+Z2(x(2)+1,x(8)+1)+Z2(x(3)+1,x(5)+1)+Z2(x(3)+1,x(6)+1)+Z2(x(3)+1,x(7)+1)+Z2(x(3)+1,x(8)+1)+Z2(x(4)+1,x(5)+1)+Z2(x(4)+1,x(6)+1)+Z2(x(4)+1,x(7)+1)+Z2(x(4)+1,x(8)+1))/16;
  end
model=build.nCellAutoregulatedModel(numCells(k),U);
model.time=linspace(0,30000,60001);
ssa=SolverSSA(model);
data=ssa.run;
switch k
  case 1
        y=[data.node{1}.state(1,:)];
    x=[data.node{1}.state(2,:)];
  case 2
    y=[data.node{1}.state(1,1000:50:end),data.node{1}.state(2,1000:50:end)];
    x=[data.node{1}.state(3,1000:50:end),data.node{1}.state(4,1000:50:end)];
  case 3
    y=[data.node{1}.state(1,1000:50:end),data.node{1}.state(2,1000:50:end),data.node{1}.state(3,1000:50:end)];
    x=[data.node{1}.state(4,1000:50:end),data.node{1}.state(5,1000:50:end),data.node{1}.state(6,1000:50:end)];
  case 4
    y=[data.node{1}.state(1,1000:50:end),data.node{1}.state(2,1000:50:end),data.node{1}.state(3,1000:50:end),data.node{1}.state(4,1000:50:end)];
    x=[data.node{1}.state(5,1000:50:end),data.node{1}.state(6,1000:50:end),data.node{1}.state(7,1000:50:end),data.node{1}.state(8,1000:50:end)];
end
probability{i,k}=zeros(100);
for j=1:length(x)
probability{i,k}(y(j)+1,x(j)+1)=probability{i,k}(y(j)+1,x(j)+1)+1;
end
probability{i,k}=probability{i,k}/sum(sum(probability{i,k}));
score(i,k)=C'*probability{i,k}(:);
end
hold on
plot(score);
end

[minVal,minInd]=min(score)
figure
ind=1;
for i=1:4
    subplot(2,2,ind);
  pcolorProbability(probability{minInd(j),i});
  ind=ind+1
end