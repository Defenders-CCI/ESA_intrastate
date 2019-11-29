setwd("/home/jacobmalcom/open/ESA_intrastate")

library(digest)
library(rvest)

print(Sys.Date())

cur <- readRDS("state_occ.rds")
pg <- read_html("https://ecos.fws.gov/ecp/pullreports/catalog/species/report/species/export?format=htmltable&distinct=true&columns=%2Fspecies%40cn%2Csn%2Cstatus%2Cdesc%2Clisting_date%3B%2Fspecies%2Frange_state%40name%3B%2Fspecies%2Ffws_region%40desc%3B%2Fspecies%2Ftaxonomy%40group%3B%2Fspecies%2Frange_state%40abbrev&sort=%2Fspecies%40sn%20asc&filter=%2Fspecies%40status%20in%20('Endangered'%2C'Threatened')&filter=%2Fspecies%40country%20!%3D%20'Foreign'")
new <- html_table(pg)[[1]]

if(nrow(new) > 2000) {
  if(digest(cur) != digest(new)) {
    file.rename("state_occ.rds", paste0("state_occ_", Sys.Date(), ".rds"))
    saveRDS(new, "state_occ.rds")
    print("Updated data saved.")
  } else {
    print("No data changes.")
  }
} else {
  print("Something is amiss.")
}
