### Load library dependencies
library(ROracle)

### Identify database driver and initialize connection to EDW
drv <- dbDriver("Oracle")
con <- dbConnect(drv,username=username,password=password,dbname = "database_name")

### Run query and create dataframe
Q <- dbSendQuery(con,"query")
table <- fetch(Q)


### Export dataframe to file
write.table(table, "path_to_file_name", sep="\t",na="")