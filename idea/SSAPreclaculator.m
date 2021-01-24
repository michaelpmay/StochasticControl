
rate=@(t,x)x^2-3
tic 
for j=1:1000000
  index=floor(100*rand)+1;
   stateRate=rate(0,index) ;
end
toc


tic
x=0:100;
ratePrecalc=zeros(100,1);
for i=1:100
  ratePrecalc(i)=rate(0,x(i)) ;
end
for j=1:1000000
  index=floor(100*rand)+1;
   stateRate=ratePrecalc(index);
end
toc


%%
rate=@(t,x)[x(1)^1+x(2)^2,x(3)^3,x(4)^4,x(5)^5]
tic 
for j=1:100000
  index=floor(100*rand(5,1))+1;
   stateRate=rate(0,index) ;
end
toc

ratePrecalc=zeros(4,100,100)
ratePrecalc=zeros(4,100)
ratePrecalc=zeros(4,100)

for j=1:100000
  index=floor(100*rand(5,1))+1;
   stateRate=ratePrecalc{index};
end
toc