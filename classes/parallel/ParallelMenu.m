classdef ParallelMenu
  %parallel menue works with parallel ticket items to make formation of
  %parfor loops easier.
properties
  ticketItems={};
end
methods  
  function output=run(obj)
    n=obj.length;
    output=cell(n,1);
    parfor i=1:n
      output{i}=obj.ticketItems{i}.run;
    end
  end
  function output=nonParallelRun(obj)
    n=obj.length;
    output=cell(n,1);
    for i=1:n
      output{i}=obj.ticketItems{i}.run;
    end
  end
  function len=length(obj)
    len=length(obj.ticketItems);
  end
  function obj=attachTicketItem(obj,runnable,input)
    obj.ticketItems{obj.length()+1}=ParallelTicket(runnable,input);
  end
  function obj=add(obj,runnable,input)
    obj=obj.attachTicketItem(runnable,input)
  end
  function obj=clearAll(obj)
    obj.ticketItems={};
  end
end
end