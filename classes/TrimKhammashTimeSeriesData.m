classdef TrimKhammashTimeSeriesData < GenericData
  properties
  end
  methods
    function obj=TrimKhammashTimeSeriesData()
      fullObj=KhammashTimeSeriesData;
      obj.time=fullObj.time(6:end);
      obj.time=obj.time-obj.time(1);
      obj.state=fullObj.state(6:end);
    end
    
  end
end