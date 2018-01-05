library(RODBC)

### Create a connection to City database (replace Buyspeed with desired database).  
myconn<-odbcDriverConnect(connection="Driver={SQL Server Native Client 11.0};
                          server=server_name;database=db_name;
                          trusted_connection=yes;")


## sqlQuery function allows a sql query as an argument, with connection as the first arg
df<-sqlQuery(myconn,"query")

## BE SURE TO CLOSE THE CONNECTION!  
##If you close the connection, you must reassign the connection before running another query.
close(myconn)