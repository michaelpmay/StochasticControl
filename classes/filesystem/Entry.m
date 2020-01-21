classdef Entry
  properties
    content
    author
    time
  end
  function Entry(item,author)
    obj.content=item;
    obj.time=datestr(now());
    obj.author=author;
  end
  
end