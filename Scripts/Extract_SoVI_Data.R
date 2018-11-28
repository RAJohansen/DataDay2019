library(tidyverse)
#install.packages("tabulizer")
library(tabulizer)
library(dplyr)

# Location of WARN notice pdf file
location <- 'http://artsandsciences.sc.edu/geog/hvri/sites/sc.edu.geog.hvri/files/attachments/SoVI_10_14_Website.pdf'

# Extract the table
out <- extract_tables(location)

final <- do.call(rbind, out[-length(out)])

# table headers get extracted as rows with bad formatting. Dump them.
final <- as.data.frame(final[2:nrow(final), ])

# Column names
headers <- c('FIP_Code', 'State_FIP', 'County_FIP', 'County_Name', 'CNTY_SoVI', 
             'Percentile')

# Apply custom column names
names(final) <- headers

# Write final table to disk
write.csv(final, file='C:/temp/SoVI.csv', row.names=FALSE)
