for i=1:7
  for j=1:7
    try
      load(['score/score_',num2str(i),num2str(j)]);
    catch
      score=0;
    end
    scoreMat(i,j)=score;
  end
end
