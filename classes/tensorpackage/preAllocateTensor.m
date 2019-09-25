function tensor=preAllocateTensor(dims)
if length(dims)==1
  tensor=zeros(1,dims);
else
  tensor=zeros(dims);
end
end