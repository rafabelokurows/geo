library(osmdata)
library(ggmap)
#available_features()
available_tags("landuse")

porto_bb <- getbb("Porto, Portugal")

# retrieving data of hospitals in Lagos
farms_porto <- porto_bb %>%
  opq() %>%
  add_osm_feature(key = "landuse", value ="farmland") %>%
  osmdata_sf()

farms_porto <- porto_bb %>%
  opq() %>%
  add_osm_feature(key = "landuse", value ="allotments") %>%
  osmdata_sf()

library(leaflet)
leaflet() %>% setView(lng = -8.6589, lat = 41.3601, zoom = 12) %>% addTiles() %>% 
  addPolygons(data=hortas_porto$osm_polygons,label=~name,color="green") %>%
  addPolygons(data=farms_porto$osm_polygons,label=~name,color="blue") %>% 
  addProviderTiles(providers$CartoDB.Positron)
farms_porto %>% head()
