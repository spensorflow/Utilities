## Download file from unsecured website
url <- "url_text_here"

dest_path <- file.path("path","file_name")

download.file(url,dest_path)


## Download file from secured website
# https URL to the wine RData file.
url_rdata <- "https://s3.amazonaws.com/assets.datacamp.com/production/course_1478/datasets/wine.RData"

# Download the wine file to your working directory
download.file(url_rdata,"wine_local.RData")

# Load the wine data into your workspace using load()
load("wine_local.RData")

# Print out the summary of the wine data
summary(wine)


###############################################
# Look at website response to determine how to parse it manually
## Load the httr package
library(httr)

# Get the url, save response to resp
url <- "http://www.example.com/"
resp <- GET(url)

# Print resp
resp

# Get the raw content of resp: raw_content
raw_content <- content(resp,as = "raw")

# Print the head of raw_content
raw_content

# Print content of resp as text
content_text <- content(resp,as = "text")

# Let R determine how to read contents
content(resp)
