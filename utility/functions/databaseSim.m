function data=databaseSim()
addpath classes/
addpath utility/
conn=localConnectTicketsTable;
table=select(conn,"SELECT * FROM requests");
query=strcat("INSERT INTO response WHERE (rid,response)=(",num2str(table.rid(1)),',',num2str(table.rid(1)),")");
  response=fetch(conn,query);
try
  model=makeModel(conn);
  type=table.solvertype{1};
  switch type
    case 'ssa'
      solver=SolverSSA(model);
      data=solver.run;
      view=ViewSSA(data);
      f = figure('visible','off');
      plot(f,data.node{1}.time,data.node{1}.state);
      randString=num2str(rand)
      saveas(f,'temp/Fig','-dpng')
    case 'ode'
      solver=SolverODE(model);
      data=solver.run;
      f = figure('visible','off');
      plot(f,data.time,data.state);
            saveas(f,'temp/Fig','-dpng')
    case 'fsp'
      solver=SolverFSP(model);
      data=solver.run;
      f = figure('visible','off');
      plot(f,data.time,data.state);
            saveas(f,'temp/Fig','-dpng')
  end
  saver=SaveData;
  saver.save(strcat('temp/',num2str(table.rid(1))))
  query=strcat("DELETE FROM requests WHERE rid=",num2str(table.rid(1)));
  response=fetch(conn,query);
catch
  query=strcat("DELETE FROM requests WHERE rid=",num2str(table.rid(1)));
  response=fetch(conn,query);
end
end
function model=makeModel(conn)
  table=select(conn,"SELECT * FROM requests");
  query=table.request{1};
  fid=fopen('temp/model.m','w')
  fprintf(fid,'%s',query)
  fclose(fid)
  loader=ModelLoader
  model=loader.load('temp/model.m')
end