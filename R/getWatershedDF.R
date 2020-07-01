#' Get Watershed Dataframe Function 
#' @description Converts a watershed's geometry to dataframe format
#' @param geom the geometry of interest
#' @return A dataframe of the watershed
#' @import rgeos
#' @import sp
#' @import ggplot2
#' @export getWatershedDF

getWatershedDF <- function(geom){
  
  watershed_geom <- readWKT(geom)
  watershed_geom_clip <- gIntersection(bb, watershed_geom)
  if (is.null(watershed_geom_clip)) {
    watershed_geom_clip = watershed_geom
  }
  wsdataProjected <- SpatialPolygonsDataFrame(watershed_geom_clip,data.frame("id"), match.ID = FALSE)
  wsdataProjected@data$id <- rownames(wsdataProjected@data)
  watershedPoints <- fortify(wsdataProjected, region = "id")
  watershedDF <- merge(watershedPoints, wsdataProjected@data, by = "id")
  
  return(watershedDF)
}