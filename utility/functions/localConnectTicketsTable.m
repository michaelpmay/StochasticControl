function conn=localConnectTicketsTable()
javaaddpath('utility/functions/postgresql.jar')
databasename = 'public';
username = 'guest';
password = '1234';
driver = 'org.postgresql.Driver';
url = 'jdbc:postgresql://localhost:5432/public';
conn = database(databasename,username,password);
end

