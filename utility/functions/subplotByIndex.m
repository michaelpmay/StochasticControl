function subplotByIndex(x,y,position)
  ind=position(2)*(position(1)-1)+position(2)
  subplot(x,y,ind)
end