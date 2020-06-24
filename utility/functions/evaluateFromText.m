function evaluateFromText(filename)
fileID = fopen(filename,'r');
while true
  text=fgetl(fileID);
  if text==-1
    break
  end
  eval(text);
end
end