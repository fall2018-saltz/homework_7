
library (dplyr)
library (ggplot2)
library(tibble)
dfStates <- pop_df
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

##Step B: explore data, understanding distributions
##arrests <- arrests %>% rownames_to_column("stateName")
common_col_names <- intersect(names(arrests), names(dfStates))
combined_df <- merge.data.frame(arrests, dfStates, by = common_col_names, all.x = TRUE)
combined_df

