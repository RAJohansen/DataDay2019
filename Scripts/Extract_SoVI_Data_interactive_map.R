#######################
###  Data Day 2019  ###
###  Power Session  ###
#######################

# Title: Interactive mapping of social vulnerability caused by climate change using R
# Authors: Richard Johansen & Mark Chalmers
# University of Cincinnati Libraries
# 4/1/2019

# Social Vulnerability Data: http://artsandsciences.sc.edu/geog/hvri
# Code: https://github.com/RAJohansen/DataDay2019


########################### PART I:Data Acquisition############################ 

### Step 1: Install & load required packages 
#install.packages(c(tigris,tmap,tidyverse,tablulizer,dplyr))
library(tigris)
library(tmap)
library(tidyverse)
library(tabulizer)
library(dplyr)

### Step 2: Extract a web PDF
# Explore file location to ensure accuracy:
website <- "http://artsandsciences.sc.edu/geog/hvri/sites/sc.edu.geog.hvri/files/attachments/SoVI_10_14_Website.pdf"
browseURL(url = website)

# Use URL location to extract pdf as a table
# When you're unfamilar with a function you can use the ?
?extract_tables
Sovi_table <- extract_tables(website)

# Lets view what exactly is extracted through this process
View(Sovi_table)

#What a mess???

### Step 3: Converting the web-based PDF into csv

# Lets use two more functions to convert the extracted table
# into a more usable and analysis friendly format
# do.call?
# rbind?
final <- do.call(rbind, Sovi_table[-length(Sovi_table)])

# Reformate table headers by dropping the first row
final <- as.data.frame(final[2:nrow(final), ])

# Lets lable the column names so they can merged with Census data
headers <- c('GEOID', 'State_FIP', 'County_FIP', 'County_Name', 'CNTY_SoVI', 
             'Percentile')

# Apply our names to the data frame
names(final) <- headers


# **NOTE** GEOID is the ID code for CENSUS data
# This is mandatory for the next section

### Step 4: Save the table as a csv 
# This is helpful for eliminating redundancy and reproducibility

write.csv(final, file='C:/temp/SoVI.csv', row.names=FALSE)


### Convert SoVI text data to spatial objects ----------------------------------
#Install Libraries needed
library(tigris)
library(tmap)

#Import Data Set
df <- read.csv('C:/R_Packages/DataDay2019/Data/SoVI.csv')

#df <- read.csv('SoVI.csv')


#Add column that will match the format of counties spatial object 
df$GEOID <- df$FIP_Code

#Add Counties Spatial Object Data
Counties <- counties()

#Merge SoVI with county.region spatial object
US_SoVI <- merge(Counties,df, by = "GEOID", all = FALSE)

#Plot Map
map<- qtm(US_SoVI, fill = "CNTY_SoVI")
map + tm_basemap(server = "OpenTopoMap")


################################################

#State FIP Code for Florida is 12
US_SoVI_florida <- US_SoVI[US_SoVI$STATEFP=="12",]

map <- tm_shape(US_SoVI_florida) +
  tm_borders(alpha = 0.9) +
  tm_fill(col = "CNTY_SoVI",
          id = "NAME",
          popup.vars = c("NAME","CNTY_SoVI"))

#State FIP Code for Florida is 39
US_SoVI_Ohio <- US_SoVI[US_SoVI$STATEFP=="39",]

map <- tm_shape(US_SoVI_Ohio) +
  tm_borders(alpha = 0.9) +
  tm_fill(col = "CNTY_SoVI",
          id = "NAME",
          popup.vars = c("NAME","CNTY_SoVI"))

tmap_leaflet(map)
