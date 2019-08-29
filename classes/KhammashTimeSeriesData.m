classdef KhammashTimeSeriesData < GenericData
  %KHAMMASHDATA Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
   
  end
  
  methods
    function obj=KhammashTimeSeriesData()
      obj.state(1,:)=[27	2674 5721 8160 10890 12366 8165 4291 2290 1325 843 552 402 334 601 1390 2168 2566 2947];
      obj.time=[0	60	120	180	240	270	300	330	360	390	420	450	480	525 570	600	660	720	780]	;
    end
    function plotTrajectory(obj)
      plot(obj.time,obj.state);
    end
  end
end

