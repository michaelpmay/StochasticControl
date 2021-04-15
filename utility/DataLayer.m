classdef DataLayer
  properties
    forceAnalysis=false;
    dataFileName='data/file/data'
    analysislayer=AnalysisLayer
    cashe=containers.Map
  end
  methods
    function data=get(obj,fileName)
      try
        data=obj.cashe(fileName);
      catch
        handle=eval(['@AnalysisLayer.',fileName]);
        dataFile=[obj.dataFileName,fileName];
        obj.tryEvaluateAndSave(handle,fileName);
        load(dataFile);
        obj.cashe(fileName)=data;
      end
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
      save(dataFile,'data', '-v7.3');
    end
    function obj=putCashe(obj,key,value)
      obj.cashe(key)=value;
    end
    function value=getCashe(key)
      value=obj.cashe(key);
    end
    function obj=clearCashe(obj)
      obj.cashe=containers.Map;
    end
  end
end