### Load library dependencies
library(ROracle)
library(readxl)


### Load login credentials for tapping into database
source("U:/Login credentials.R")

### Read spreadsheet
VPT_factor <- read_excel("path_to_excel_file",1)


### Identify database driver and initialize connection to database
drv <- dbDriver("Oracle")
con <- dbConnect(drv,username=username,password=password,dbname = "database_name")

### Convert to database table
dbWriteTable(con,name = 'new_table_name',VPT_factor,overwrite=TRUE)