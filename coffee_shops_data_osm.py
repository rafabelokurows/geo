import osmnx as ox
import geopandas as gpd
import folium

# Get place boundary related to the place name as a geodataframe
limit_num = 200
place = 'Porto, Portugal'
tags = {'amenity': 'cafe'}
cafe = ox.geometries_from_place(place, tags=tags)
cafe.head()
cafe_points = cafe[cafe.geom_type == 'Point'][:limit_num]

m = folium.Map(ox.geocode(place), zoom_start=10)
locs = zip(cafe_points.geometry.y, cafe_points.geometry.x)
for location in locs:
    folium.CircleMarker(location=location).add_to(m)
    m.save('cafes.html')
