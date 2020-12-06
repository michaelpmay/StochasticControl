classdef DataLayer
  properties
    forceAnalysis=false;
    dataFileName='data/file/data'
    analysislayer=AnalysisLayer
  end
  methods
    function data=get(obj,fileName)
      handle=eval(['@AnalysisLayer.',fileName]);
      dataFile=[obj.dataFileName,fileName];
      obj.tryEvaluateAndSave(handle,fileName);
      load(dataFile);
    end
    function tryEvaluateAndSave(obj,handle,fileName)
      dataFile=[obj.dataFileName,fileName];
      if obj.forceAnalysis==true
        data=handle();
        save(dataFile,'data');
        return
      end
      try
        load(dataFile);
      catch
        data=handle();
        save(dataFile,'data');
        return
      end
    end
    function update(obj,fileName)
      handle=eval(['@AnalysisLayer.',fileName]);
      dataFile=[obj.dataFileName,fileName];
      data=handle();
      save(dataFile,'data');
    end
  end
end