
library(ggmap)
library(ggplot2)

##Load and Merge Datasets
urlread <- "https://www2.census.gov/programs-surveys/popest/datasets/2010-2017/state/asrh/scprc-est2017-18+pop-res.csv"
dfStates <- read.csv(url(urlread),stringsAsFactors = FALSE) ##call local sheet
str(dfStates)
dfStates

arrests <- USArrests 
stateName <- rownames(arrests)
rownames(arrests) <- NULL
arrests <- cbind(arrests,stateName)
View(arrests)

##CLEANING DATA
dfStates <- dfStates[-53,]
dfStates <- dfStates[-1,]
dfStates <- dfStates[,-1:-4]
View(dfStates)
##Making sure there are exactly 51 rows
nrow(dfStates)
filter_df <- dfStates
##Making 4 colums with stateName, population, popOver18, and percentOver18
cnames <- colnames(dfStates)
cnames[1] <- "stateName"
cnames[2] <- "population"
cnames[3] <- "popOver18"
cnames[4] <- "percentOver18"
colnames(dfStates) <- cnames
colnames(dfStates)

##arrests <- arrests %>% rownames_to_column("stateName")
common_col_names <- intersect(names(arrests), names(dfStates))
combined_df <- merge.data.frame(arrests, dfStates, by = common_col_names, all.x = TRUE)
View(combined_df)

##adding state area and state centers to data frame
statearea <- state.area
combined_df$StateArea <- statearea
statecenter <- state.center
combined_df$StateCenter <- statecenter
View(combined_df)

##adding area and adding center of each state (alternate, trying to establish X/Y coordinates within dataframe)
stateStats <- data.frame(state.name, state.center, state.area)
View(combined_df)

##lowercase
combined_df$stateName <-tolower(combined_df$stateName)
US <-map_data("state")

