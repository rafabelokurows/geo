import osmnx as ox
import geopandas as gpd
import folium

limit_num = 1000
place = 'Porto, Portugal'
tags = {'building':True}
building = ox.geometries_from_place(place, tags)
cols = ['amenity','building', 'name', 'tourism']
building[cols].head()
buildings = building[building.geom_type == 'Polygon'][:limit_num]
m = folium.Map(ox.geocode(place), zoom_start=10, tiles='CartoDb dark_matter')
folium.GeoJson(buildings[:limit_num]).add_to(m)
m.save('buildings.html')
