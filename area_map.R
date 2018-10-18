
combined_df$stateName <-tolower(combined_df$stateName)
US <-map_data("state")
US_data_map <- ggplot(combined_df, aes(map_id = stateName))
US_data_map <- US_data_map + geom_map(map = US, aes(fill = StateArea))
US_data_map <- US_data_map + expand_limits(x = US$long, y = US$lat)
US_data_map <- US_data_map + coord_map() + ggtitle("State Area")
US_data_map
