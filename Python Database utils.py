#### SQL query into dataframe
'Load libraries'
import pyodbc
import pandas

 
'Establish Connection'
cnxn = pyodbc.connect('Driver={SQL Server};'
                      'Server=SRVQNXTRPTLAPROD;'
                      'Database=dbname;'
                      'Trusted_Connection=yes;')

'Run query'
query = ('SELECT top 10 * from table')

'Create dataframe from query' 
df = pandas.read_sql(query,cnxn)
