
##IST 687
## Christopher Negiz
## Homework 7
## Due Date: October 17th, 2018
## Date Submitted: October 17th, 2018

##install required packages
library(ggmap)
library(ggplot2)
library(tibble)

##Load and Merge Datasets
urlread <- "https://www2.census.gov/programs-surveys/popest/datasets/2010-2017/state/asrh/scprc-est2017-18+pop-res.csv"
dfStates <- read.csv(url(urlread),stringsAsFactors = FALSE) ##call local sheet
str(dfStates)
dfStates

arrests <- USArrests 
stateName <- rownames(arrests)
rownames(arrests) <- NULL
arrests <- cbind(arrests,stateName)
arrests

##CLEANING DATA
dfStates <- dfStates[-53,]
dfStates <- dfStates[-1,]
dfStates <- dfStates[,-1:-4]
dfStates
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
combined_df

##adding state area and state centers to data frame
statearea <- state.area
combined_df$StateArea <- statearea
statecenter <- state.center
combined_df$StateCenter <- statecenter
combined_df

##adding area and adding center of each state (alternate, trying to establish X/Y coordinates within dataframe)
stateStats <- data.frame(state.name, state.center, state.area)
combined_df

##lowercase
combined_df$stateName <-tolower(combined_df$stateName)
US <-map_data("state")

##generate a color coded map
US_data_map <- ggplot(combined_df, aes(map_id = stateName))
US_data_map <- US_data_map + geom_map(map = US, aes(fill = StateArea))
US_data_map <- US_data_map + expand_limits(x = US$long, y = US$lat)
US_data_map <- US_data_map + coord_map() + ggtitle("State Area")
US_data_map

##create a color shaded map of the US based on murder rate for each state
US_murder_map <- ggplot(combined_df, aes(map_id = stateName))
US_murder_map <- US_murder_map + geom_map(map = US, aes(fill = Murder))
US_murder_map <- US_murder_map + expand_limits(x = US$long, y = US$lat)
US_murder_map <- US_murder_map + coord_map() + ggtitle("Murder Map")
US_murder_map

##merging with main dataframe and making columns lowercase
colnames(dfStates) <- c("stateName", "xstate", "ystate", "statearea")
dfStates$stateName <- tolower(dfStates$stateName)
combined_state <- merge(combined_df, dfStates, by = "stateName")
combined_state

##creating the map as a circle per state for population
##str(combined_df)
##pop_map <- ggplot(combined_df, aes(map_id = state))
##pop_map <- pop_map + geom_map(map = US, fill = "white", color = "blue")
##pop_map <- pop_map + expand_limits(x = US$long, y = US$lat)
##pop_map <- pop_map + coord_map() + ggtitle("Population by State")
##pop_map <- pop_map + geom_point(aes(x = StateCenter, y = US$lat), color = "black", size = combined_df$population)
##^^^^^ code that i tried to use to plot circles, didn't work, took a different appraoch
dfStates <- data.frame(state.name, state.center, state.area)
dfStates
map_circles <- US_murder_map + geom_point(data = combined_state, aes(x= combined_state$xstate, y = combined_state$ystate, size = combined_state$population))
map_circles

##zoom the map
##identify NY location/ccontinuously got it wrong, don't know why. asked a friend about the coordinates
zoom_map <- map_circles + scale_x_continuous(limits = c(-85.1449, -65.1449), expand = c(0,0)) + scale_y_continuous(limits = c(33.1361, 53.1361), expand = c(0,0))
zoom_map <- zoom_map + coord_map()
zoom_map
