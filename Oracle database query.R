### Load library dependencies
library(ROracle)

### Identify database driver and initialize connection to EDW
drv <- dbDriver("Oracle")
con <- dbConnect(drv,username=username,password=password,dbname = "db_name")


### View list of tables in specified database
dbListTables(con, schema = "database/schema_name", all = FALSE, full = FALSE)

### View list of columns in specified table
dbListFields(con, name = "table_name", schema = "database/schema_name", all = FALSE, full = FALSE)


### Run query and save to data frame
Q <- dbSendQuery(con,"query")

df <- fetch(Q)