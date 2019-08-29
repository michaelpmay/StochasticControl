classdef GenericCME
  methods 
    function data=run(obj)
      data=obj.runTrajectory();
      data=obj.formatTrajectory(data);      
      data=obj.appendMetaData(data);
    end
  end
end