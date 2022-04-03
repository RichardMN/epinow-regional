# Create a simplified GeoJSON file showing sub-national units of a given country

library(rnaturalearth)
library(rnaturalearthhires)
library(rmapshaper)
library(dplyr)
library(geojsonio)
library(sf)

countryName <- "Canada"
search_country <- TRUE

# For some countries, search by country includes other territories
# far from the mainland (e.g. France), and searching by geounit
# will give a more compact result. See the documentation for
# ne_states

if (search_country) {
  spdf_data <- ne_states( country = countryName )
} else {
  spdf_data <- ne_states( geounit = countryName )
}

geoData <- st_as_sf(spdf_data) %>%
  select(name, name_alt, geometry)

geoData <- ms_simplify(geoData,keep=0.04)

geojson_write(geoData, file=paste0(countryName, "_regions.geojson"))
