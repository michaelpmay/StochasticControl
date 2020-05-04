classdef OptimalModelLoader
  properties
    folderName='outFiles/optimized/'
  end
  methods
    function obj=loadODE(obj,modelName,default)
      try
      folderItems=dir(obj.folderName);
      index=obj.getMinScoreIndex(folderItems,modelName);
      load([obj.folderName,folderItems(index).name]);
      catch
        'Failed to Load'
        obj=ModelODE(default);
      end
    end
        function obj=loadFSP(obj,modelName,default)
      try
      folderItems=dir(obj.folderName);
      index=obj.getMinScoreIndex(folderItems,modelName);
      load([obj.folderName,folderItems(index).name]);
      catch
        'Failed to Load'
        obj=ModelFSP(default);
      end
    end
    function minIndex=getMinScoreIndex(obj,folderItems,modelName)
      score=preAllocateVector(length(folderItems));
      for i=1:length(folderItems)
        score(i)=obj.parseScore(folderItems(i).name,modelName);
      end
      [~,minIndex]=min(score);
    end
    function score=parseScore(obj,scoreString,name)
      splitString=strsplit(scoreString,'_');
      if length(splitString)~=3
        score = nan;
        return
      end
      splitString(3)=obj.trimMat(splitString{3});
      if (convertCharsToStrings(splitString{1})==convertCharsToStrings(name))
        score=str2num([splitString{2},'.',splitString{3}]);
      else
        score=nan;
      end
    end
    function string=trimMat(obj,scoreString)
      splitString=strsplit(scoreString,'.');
      string=splitString(1);
    end
  end
end