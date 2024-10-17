# Title:    Grand Coulee upstream gauges map with dams
#
# Purpose:  This program generates a hydrological map of a section of the Columbia River Basin, 
#           including the Grand Coulee Dam, Banks Lake, and USGS gauging stations. State labels
#           are also included. Citation information is located in the README.
#
# Author:   Becker Gibson
#
# Updated:  10/17/2024
#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#X#


library(sf)
library(ggplot2)
library(dplyr)

# create a bounding box
bbox = st_bbox(c(xmin = -115.0, xmax = -120.0, 
                 ymin = 47.0, ymax = 49.5),
               crs = 4326)

# load dataset of USGS gauge locations, subset to bounding box
USGS.gauges <- st_read("/net/home/cv/rg1425/USGSgageLoc/GageLoc.shp") %>% 
  st_transform(st_crs(bbox)) %>%
  st_crop(bbox)

# read North American rivers
na.rivers <- st_read("/net/home/cv/rg1425/HYDROshed/rivers_north_central_america/HydroRIVERS_v10_na_shp/HydroRIVERS_v10_na.shp") 
# read North American American basins shapefile
na.basins <- st_read("/net/home/cv/rg1425/HYDROshed/basins_north_america/hybas_na_lev03_v1c.shp")
# read lakes shapefile
lakes <- st_read("/net/home/cv/rg1425/HYDROshed/hydroshed_lakes/HydroLAKES_polys_v10_shp/HydroLAKES_polys_v10.shp")

# subset to just Banks Lake
rel.lake.names <- c("Banks Lake")
rel.lakes <- lakes[lakes$Lake_name %in% rel.lake.names,] 

# get ID for Columbia River Basin
ID <- c(7030014930)
# subset shapefile to Columbia River Basin
Columbia.Basin <- na.basins[na.basins$HYBAS_ID %in% ID,] 
# get rivers in the Columbia River Basin
Columbia.basin.rivers <- na.rivers %>% st_intersection(st_make_valid(Columbia.Basin)) %>% 
  st_transform(st_crs(bbox)) %>%
  st_crop(bbox)

# get state boundaries and subset
states <- read_sf("/net/nfs/squam/raid/userdata/dgrogan/data/map_data/cb_2015_us_state_500k/cb_2015_us_state_500k.shp")
state.names <- c("Washington", "Idaho", "Montana", "Oregon")
CB.states <- st_as_sf(st_transform(st_cast(states[states$NAME %in% state.names,], "POLYGON"), crs = 4326)) %>% 
  st_crop(bbox)

# get relevant dams
dams <- tibble(
  Name = c("Grand Coulee", "North Dam", "Dry Falls Dam", "Little Falls Dam", "Libby Dam", "Chief Joseph Dam", "Albeni Falls Dam", "Keenleyside Dam", "Noxon Rapids Dam"), 
  Lat = c(47.939706, 47.940842, 47.62, 47.831389, 48.41, 47.9961, 48.18000, 49.339444, 47.959722), 
  Long = c(-119.001597, -119.017406, -119.3075, -117.916667, -115.314, -119.632, -116.99972, -117.771944, -115.733889)) %>%
  st_as_sf(coords = c("Long", "Lat")) %>% 
  rename(geo_col = geometry) %>%
  as_tibble() %>% 
  st_as_sf(sf_column_name = "geo_col", crs = 4326)

# plot
ggplot() +
  geom_sf(
    data = CB.states,
    color = "#222222",
    lwd = 0.5,
    linetype = "dotted"
  ) +
  geom_sf(
    data = Columbia.basin.rivers,
    color = "#000080",
    lwd = log1p(Columbia.basin.rivers$DIS_AV_CMS) - .85*log1p(Columbia.basin.rivers$DIS_AV_CMS),
    fill = NA
  ) +
  geom_sf(
    data = rel.lakes,
    color = "#000080",
    fill = "#000080"
  ) +
  geom_sf(
    data = USGS.gauges,
    color = "#FF007F",
    size = 0.8
  ) +
  geom_sf(
    data = dams, 
    color = "#893101",
    shape = 17,
    size = 4,
    alpha = 0.8
  ) +
  geom_sf_label(
    data = dams[3:9,],
    aes(label = Name),
    size = 1.5,
    nudge_y = 0.08,
    alpha = 0.8
  ) + 
  geom_sf_label(
    data = dams[1,],
    aes(label = Name),
    size = 1.5,
    nudge_y = 0.08,
    nudge_x = 0.08,
    alpha = 0.8
  ) +
  geom_sf_label(
    data = dams[2,],
    aes(label = Name),
    size = 1.5,
    nudge_x = -0.1,
    alpha = 0.8
  ) +
  geom_sf_label(
    data = CB.states,
    aes(label = NAME),
    size = 3,
    alpha = 0.5,
    fill = "black",
    color = "white"
  ) +
  geom_sf_label(
    data = rel.lakes,
    aes(label = Lake_name),
    size = 1.5,
    nudge_x = 0.09,
    fill = "#2f2f2f",
    color = "white",
    alpha = 0.7
  ) +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "lightgrey"),
    axis.title = element_blank()
  ) +
  labs(
    title = "Grand Coulee Dam and Surrounding Area",
    subtitle = "Dams and USGS Stations"
  )
