classdef FileSystem < Directory
  % creates a basic filesystem for a project
  properties 
    root='~/FileSystems'
  end
  methods
    function FileSystem(name)
      obj.name=name;
    end
    function directory=from(obj,directoryName)
      for i=1:length(obj.directory)
        if(obj.directory(i).name==directoryName)
          directory=obj.directory(i);
        else
          error('Directory not found');
        end
      end
    end
    function obj=addDirectory(obj,directoryName)
      directory=Directory(directoryName,obj.name)
      obj.directory(end+1)=directory;
    end
  end
end