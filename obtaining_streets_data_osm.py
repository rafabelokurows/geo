import osmnx as ox
import geopandas as gpd
import folium

# Get place boundary related to the place name as a geodataframe
place = 'Porto, Portugal'

graph = ox.graph_from_place(place, network_type='drive')
nodes, streets = ox.graph_to_gdfs(graph)

ox.folium.plot_graph_folium(graph)
