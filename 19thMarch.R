setwd("C:/Users/Reena Shaw/Desktop/rstudio_projects/AGF-2019/scripts/income_with_AGF_garbage_location") #location of this script and further dwnldd images

library(rgdal)
#ogrInfo()

#S1: read in the shapefiles(.shp files):
lowerandsingle<- readOGR(dsn="C:/Users/Reena Shaw/Desktop/A Greener Future - 2019/datasets/External Data Sources/reena/MUNICIPAL_BOUNDARY_open_data_shapefiles", layer="MUNICIPAL_BOUNDARY_LOWER_AND_SINGLE_TIER") #683*13
upperanddistrict<- readOGR(dsn="C:/Users/Reena Shaw/Desktop/A Greener Future - 2019/datasets/External Data Sources/reena/MUNICIPAL_BOUNDARY_open_data_shapefiles", layer="MUNICIPAL_BOUNDARY_UPPER_TIER_AND_DISTRICT")#96*12

#S2: readOGR will read the .prj file if it exists
#print(proj4string(lowerandsingle)) #error

#S3: plot the map
#plot(lowerandsingle, axes=TRUE,border="gray" ) # 2mins
#points(lowerandsingle, pch=20, cex=0.8) #error: Error in as.double(y) : #cannot coerce type 'S4' to vector of type 'double'
#lines(lowerandsingle,col="blue", lwd=2.0 ) #error: same as above

#plot(upperanddistrict, axes=TRUE, border="gray") #5 mins
#IMAGES stored in: C:\Users\Reena Shaw\Desktop\rstudio_projects\AGF-2019\scripts\18thMarch


###################
#S4: 

fsa<-read.csv("C:/Users/Reena Shaw/Desktop/A Greener Future - 2019/datasets/External Data Sources/FsaCensusData.csv")
head(fsa)
View(fsa)
summary(fsa$characteristic)
# slice rows containing'$' and 'years', 'household and dwelling characteristics':
#index_income<- with(fsa, grepl("[\\$]",characteristic)) #\\= escaping the '$' escape character
index_income<- with(fsa, grepl("^\\$",characteristic)) #\\= escaping the '$' escape character
fsa2<-fsa[index_income, ]
head(fsa2$characteristic) #] Median value of dwellings ($)   ; $150,000 and over;  $35,000 to $39,999 ; etc.
# ^ 1431 levels
View(fsa2) # <- got what we wanted- regarding slicing 'income'
# regex:[]: ignores the () before the'$'
# or: use the 'starts with $' 

###################################################################################
# NOT USEFUL; YET, DIDN'T DELETE:
index_income2<- fsa[grep("^\\$", fsa$characteristic, value=TRUE), ]
head(index_income2, 10)
View(index_income2)
levels(index_income2) ##### do this!
fsa3<- fsa[index_income2, ] #takes forever to run
head(fsa3$characteristic)
####################################################################################

# drop 'censusYear' and 'topic' (same value throughout; missing_value throught)
library(dplyr)
fsa3<- select(fsa2, -c("censusYear", "topic"))
View(fsa3)

#converting long df into wide df=> use dcast()
install.packages("reshape2")
library(reshape2)
#fsa4<- dcast(fsa3, fsa~ characteristic) # 1641*27
#fsa4<- dcast(fsa3, fsa~ characteristic + count) # 1641* 15251...FROZEN

# drop 'male' and 'female'
fsa4<- select(fsa3, -c("countMale","countFemale"))
View(fsa4) # 114410*3 = fsa, chracteristic, count
#fsa5<- dcast(fsa4, fsa~, value.var="count" )

install.packages("tidyr")
library(tidyr)
packageVersion("tidyr") #0.8.3

#fsa5<- spread(fsa4,key="characteristic", value="count", fill=NA, convert=FALSE)
fsa5<- spread(fsa4,characteristic,count)

# ^Error: Each row of output must be identified by a unique combination of keys.
#......Keys are shared for 107526 rows: (114410-107526= 6884)
View(fsa5)

View(fsa5)






#################

# income heatmap
# 
# exclude the rows/ locations that AGF has not collected garbage in.
# regular exp: 'age' rows-> transpose 'age' into cols , while still keeping lat-longs. Lat-longs shpuld be ordered.
# python: pd.pivot()

# RE: income-> 



