#install.packages("gbfs")
library(gbfs)
library(tidyverse)
# get_gbfs_cities() %>% filter(`Country Code` == "CH") %>% View()
# get_which_gbfs_feeds(city = "Geneva")

#https://github.com/MobilityData/gbfs/blob/master/systems.csv

pdx_station_info <-
  get_station_information("https://stables.donkey.bike/api/public/gbfs/2/donkey_ge/de/station_information.json")
pdx_station_status <-
  get_station_status("https://stables.donkey.bike/api/public/gbfs/2/donkey_ge/de/station_status.json")
# pdx_free_bikes <-
#   get_free_bike_status("https://mds.bird.co/gbfs/v2/public/basel/gbfs.json",
#                        output = "return") %>%
#   # just select columns we're interested in visualizing
#   select(id = bike_id, lon, lat) %>%
#   # make columns analogous to station_status for row binding
#   mutate(num_bikes_available = 1,
#          num_docks_available = NA,
#          type = "free")
# pdx_station_status %>% head()
# pdx_full <- bind_rows(pdx_stations, pdx_free_bikes)

pdx_stations <- full_join(pdx_station_info,
                          pdx_station_status,
                          by = "station_id") %>%
  # just select columns we're interested in visualizing
  select(id = station_id,
         lon,
         lat,
         num_bikes_available,
         num_docks_available) %>%
  mutate(type = "docked")

pdx_plot = pdx_stations %>%
  filter(num_bikes_available > 0) %>%
  # plot the geospatial distribution of bike counts
  ggplot() +
  aes(x = lon,
      y = lat,
      size = num_bikes_available,
      col = type) +
  geom_point() +
  # make aesthetics slightly more cozy
  theme_minimal() +
  scale_color_brewer(type = "qual")

library(ggmap)
map <- get_map(location = c(mean(pdx_stations$lon), mean(pdx_stations$lat)),
               zoom = 13,maptype = "toner-lite",source="stamen")

#https://stackoverflow.com/questions/18859809/how-do-you-replace-colors-in-a-ggmap-object
attr_map <- attr(map, "bb")    # save attributes from original
# change color in raster
map %>% head()
map[map == "#D9D9D9"] <- "#8BB8EF"
# correct class, attributes
class(map) <- c("ggmap", "raster")
attr(map, "bb") <- attr_map

pdx_stations = pdx_stations %>%  mutate(has_available = if_else(num_bikes_available > 0,"yes","no"))
plot = ggmap(map) +
  geom_point(data = pdx_stations, aes(x = lon, y = lat, color = factor(has_available),size=num_bikes_available),stroke = 0, shape=19)+
  labs(color="Bikes available",size="# of Bikes",y=NULL,x=NULL,title="Bike stations in Geneva, CH",
       subtitle = paste0("Bike availability on ",Sys.time()))+
  scale_size(range = c(1.4,5))+ #https://stackoverflow.com/questions/66655938/change-size-of-geom-point-based-on-values-in-column
  # scale_size_binned_area(
  #   limits = c(0, 16),
  #   breaks = c(0, 1,5, 10, 16),
  # )+
  scale_color_manual(values = c("coral4","green4"))
setwd(Sys.getenv("HOME"))
ggsave("Geneva bikes.png",plot, dpi=300)
