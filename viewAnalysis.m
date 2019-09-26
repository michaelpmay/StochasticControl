%analysis=loadAnalysis
addpath classes
close all
for i=1:length(analysis)
endScore(i)=analysis{i}.score(end);
deltaT(i)=analysis{i}.time(2)-analysis{i}.time(1);
end

AcademicFigure
hold on
for i=1:length(analysis)
plot(analysis{i}.time,analysis{i}.targetData.node{1}.state);
end
hold off
title('target State vs time')

AcademicFigure
hold on
for i=1:length(analysis)
plot(analysis{i}.time(2:end),analysis{i}.score);
end
hold off
title('score vs time')

AcademicFigure
hold on
for i=1:length(analysis)
plot(analysis{i}.time(2:end),analysis{i}.dynamicScore);
end
hold off
title('dynamicScore vs time')

AcademicFigure
hold on
plot(analysis{1}.time(2:end),analysis{1}.score);
plot(analysis{5}.time(2:end),analysis{5}.score);
plot(analysis{50}.time(2:end),analysis{50}.score);
hold off
title('trajectory score of 1 5 and 50');



AcademicFigure
hold on
for i=1:length(analysis)
plot(analysis{i}.time(2:end),analysis{i}.u);
end
hold off
title('U vs time')

AcademicFigure
hold on
for i=1:length(analysis)
  n=floor(length(analysis{i}.score)/3);
  plot(deltaT(i),mean(analysis{i}.score(n:end)),'ro')
end
title('mean score vs dt')