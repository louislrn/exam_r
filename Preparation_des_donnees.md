# Préparation des données

Vous trouverez ici les scripts de préparation des données utiles à l'exercice.   
Ces scripts sont présentés ici pour information, vous n'en aurez pas besoin 
pour répondre aux questions de l'exercice. 


## Données des locations Airbnb (InsideAirbnb)

Extraction des locations Airbnb dans la ville de Paris

Source : [InsideAirbnb, Paris, Septembre 2024](https://insideairbnb.com/get-the-data/)


```r
library(sf)
# import des 12e et 13e arrondissements
arrdts <- st_read("data/ADMINISTRATIF/ARRONDISSEMENT_MUNICIPAL.shp")
arrdts <- arrdts[arrdts$INSEE_ARM %in% c("75112", "75113") ,]

st_write(obj = arrdts, dsn = paste0("data/bnb.gpkg"), layer = "arrdts",
         delete_layer = TRUE, quiet = TRUE)

# Téléchargement des données Airbnb
tab <- read.csv("data/listings.csv") # removed from inputs

# Select 12 & 13e arrdts
tab_1312 <- tab[tab$neighbourhood_cleansed %in% c("Reuilly", "Gobelins") ,]

# Remove hotels
tab_1312 <- tab_1312[, c("id", "host_id", "latitude", "longitude", "room_type",
                         "accommodates", "price")]
tab_1312 <- tab_1312[tab_1312$room_type != "Hotel room" ,]

# Remove outliers in price
tab_1312$price <- as.numeric(gsub("[$]", "" , gsub("[,]", "", tab_1312$price)))
tab_1312 <- tab_1312[tab_1312$price < 1000 ,]
tab_1312 <- tab_1312[!is.na(tab_1312$price) ,]

tab_1312 <- st_as_sf(tab_1312, coords = c("longitude", "latitude"),
                     crs = 4326) |>
  st_transform(crs = 2154)

# export
st_write(obj = tab_1312, dsn = paste0("data/bnb.gpkg"), layer = "airbnb",
         delete_layer = TRUE, quiet = TRUE)
```

## Données OpenStreetMap

Extraction de certaines données OpenStreetMap dans les 12e et 13e arrondissements

Source : [© les contributeurs d’OpenStreetMap, 2021](https://www.openstreetmap.org/)

```r
# define a bounding box + 2.5% around 12 & 13 arrdts
bb_1312 <- st_bbox(tab_1312)
hyp <- sqrt(((bb_1312[3] - bb_1312[1])^2) + ((bb_1312[4] - bb_1312[2])^2))
hyp <- hyp * 0.025
bb_sup <- st_bbox(st_buffer(st_transform(arrdts, 4326), hyp))
my_opq <- opq(bbox = bb_sup)

# extract green spaces
green1 <- my_opq %>%
  add_osm_feature(key = "landuse", value = c("allotments",
                                             "farmland","cemetery",
                                             "forest", "grass", "greenfield",
                                             "meadow",
                                             "orchard", "recreation_ground",
                                             "village_green", "vineyard")) %>%
  osmdata_sf() %>% 
  unique_osmdata()

green2 <- my_opq %>%
  add_osm_feature(key = "amenity", value = c("grave_yard")) %>%
  osmdata_sf()%>% 
  unique_osmdata()

green3 <- my_opq %>%
  add_osm_feature(key = "leisure", value = c("garden", "golf_course",
                                             "nature_reserve", "park", "pitch")) %>%
  osmdata_sf()%>% 
  unique_osmdata()

green4 <- my_opq %>%
  add_osm_feature(key = "natural", value = c("wood", "scrub", "health",
                                             "grassland", "wetland")) %>%
  osmdata_sf()%>% 
  unique_osmdata()

green5 <- my_opq %>%
  add_osm_feature(key = "tourism", value = c("camp_site")) %>%
  osmdata_sf()%>% 
  unique_osmdata()

sg <- function(x){
  if(!is.null(x$osm_polygons)){
    a <- st_geometry(x$osm_polygons)
  } else {
    a <- NULL
  }
  if(!is.null(x$osm_multipolygons)){
    b <- st_geometry(x$osm_multipolygons)
  } else {
    b <- NULL
  }
  r <- c(a,b)
  r
}

gr <- c(sg(green1), sg(green2), sg(green3), sg(green4), sg(green5))
green <- st_union(st_make_valid(gr))
green <- st_transform(green, 2154)
green <- st_buffer(st_buffer(green, 5), -5)

# Extract roads & railways
q4 <- add_osm_feature(my_opq, key = 'highway', value = '', value_exact = FALSE)
res4 <- osmdata_sf(q4)$osm_lines
roads <- st_geometry(res4)
q5 <- add_osm_feature(my_opq, key = 'railway', value = '', value_exact = FALSE)
res5 <- osmdata_sf(q5)$osm_lines
rail <- st_geometry(res5)
road <- st_transform(roads, 2154)
rail <- st_transform(rail, 2154)

# export
st_write(obj = road, dsn = paste0("data/bnb.gpkg"), layer = "route",
         delete_layer = TRUE, quiet = TRUE)
st_write(obj = rail, dsn = paste0("data/bnb.gpkg"), layer = "rail",
         delete_layer = TRUE, quiet = TRUE)
st_write(obj = green, dsn = paste0("data/bnb.gpkg"), layer = "parc",
         delete_layer = TRUE, quiet = TRUE)
```
