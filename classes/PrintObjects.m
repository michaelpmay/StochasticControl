classdef PrintObjects
  methods
    function saveTo(obj,directory)
      obj.createSaveLocation(directory);
      save([directory,'/',obj.generateFileName],'obj')
    end
    function saveAs(obj,fileName,directory)
      obj.createSaveLocation(directory);
      save([directory,'/',fileName],'obj')
    end
    function createSaveLocation(obj,directory)
      if ~(exist(directory,'dir'))
        mkdir(directory)
      end
    end
    function decoration=generateFileDecoration(obj)
      timeStamp=datestr(now);
      timeStamp=replace(timeStamp,'-','');
      timeStamp=replace(timeStamp,':','');
      timeStamp=replace(timeStamp,' ','_');
      randomIntegerString=['_',strrep((num2str(randi(9,1,8))),' ','')];
      decoration=[timeStamp,randomIntegerString];
    end
    function fileName=generateFileName(obj)
      fileName=[class(obj),obj.generateFileDecoration]
    end
    function printTo(obj,directory)
    end
  end
end