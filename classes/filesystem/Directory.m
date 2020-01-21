classdef Directory
  properties
    name
    directory
  end
  methods 
    function get(obj,entryName)
      
    end
    function save(obj,item)
      entry=Entry(item)
    end
    function directory=as(obj,directoryName)
      for i=1:length(obj.directory)
        name=obj.directory(i).name
        if name==directoryName
          directory=obj.directory(i);
          return 
        end
      end
    end
    function addDirectory(obj,directoryName,parent)
      directory=Directory(directoryName,obj.name)
      obj.directory{end+1}=directory
    end
    function save(obj,item,author)
      file=
    end
    function getPath(obj)
      
    end
  end
end