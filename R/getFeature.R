#' Get Feature Function 
#' @description Collects information about the river segment of interest 
#' @param inputs the conveyance inputs 
#' @param token token that allows you to access deq2
#' @param base_url computer directory to give R access to username and pw 
#' @param feature feature of interest
#' @return The features of the river segment 
#' @import httr
#' @export getFeature

getFeature <- function(inputs, token, base_url, feature){
  #inputs <-    conveyance_inputs 
  #base_url <- site
  #print(inputs)
  pbody = list(
    hydroid = inputs$hydroid,
    bundle = inputs$bundle,
    ftype = inputs$ftype,
    hydrocode = inputs$hydrocode
  );
  
  
  if (!is.null(inputs$hydroid)) {
    if (inputs$hydroid > 0) {
      # forget about other attributes, just use hydroid if provided 
      pbody = list(
        hydroid = inputs$hydroid
      )
    }
  }
  
  feature <- GET(
    paste(base_url,"/dh_feature.json",sep=""), 
    add_headers(HTTP_X_CSRF_TOKEN = token),
    query = pbody, 
    encode = "json"
  );
  feature_cont <- content(feature);
  
  if (length(feature_cont$list) != 0) {
    print(paste("Number of features found: ",length(feature_cont$list),sep=""))
    
    feat <- data.frame(hydroid = character(),
                       bundle = character(),
                       ftype = character(),
                       hydrocode = character(),
                       name = character(),
                       fstatus = character(),
                       address1 = character(),
                       address2 = character(),
                       city = character(),
                       state = character(),
                       postal_code = character(),
                       description = character(),
                       uid = character(),
                       status = character(),
                       module = character(),
                       feed_nid = character(),
                       dh_link_facility_mps = character(),
                       dh_nextdown_id = character(),
                       dh_areasqkm = character(),
                       dh_link_admin_location = character(),
                       field_dh_from_entity = character(),
                       field_dh_to_entity = character(),
                       dh_geofield = character(),
                       geom = character(),
                       stringsAsFactors=FALSE) 
    
    #i <- 1
    for (i in 1:length(feature_cont$list)) {
      
      feat_i <- data.frame("hydroid" = if (is.null(feature_cont$list[[i]]$hydroid)){""} else {feature_cont$list[[i]]$hydroid},
                           "bundle" = if (is.null(feature_cont$list[[i]]$bundle)){""} else {feature_cont$list[[i]]$bundle},
                           "ftype" = if (is.null(feature_cont$list[[i]]$ftype)){""} else {feature_cont$list[[i]]$ftype},
                           "hydrocode" = if (is.null(feature_cont$list[[i]]$hydrocode)){""} else {feature_cont$list[[i]]$hydrocode},
                           "name" = if (is.null(feature_cont$list[[i]]$name)){""} else {feature_cont$list[[i]]$name},
                           "fstatus" = if (is.null(feature_cont$list[[i]]$fstatus)){""} else {feature_cont$list[[i]]$fstatus},
                           "address1" = if (is.null(feature_cont$list[[i]]$address1)){""} else {feature_cont$list[[i]]$address1},
                           "address2" = if (is.null(feature_cont$list[[i]]$address2)){""} else {feature_cont$list[[i]]$address2},
                           "city" = if (is.null(feature_cont$list[[i]]$city)){""} else {feature_cont$list[[i]]$city},
                           "state" = if (is.null(feature_cont$list[[i]]$state)){""} else {feature_cont$list[[i]]$state},
                           "postal_code" = if (is.null(feature_cont$list[[i]]$postal_code)){""} else {feature_cont$list[[i]]$postal_code},
                           "description" = if (is.null(feature_cont$list[[i]]$description)){""} else {feature_cont$list[[i]]$description},
                           "uid" = if (is.null(feature_cont$list[[i]]$uid)){""} else {feature_cont$list[[i]]$uid},
                           "status" = if (is.null(feature_cont$list[[i]]$status)){""} else {feature_cont$list[[i]]$status},
                           "module" = if (is.null(feature_cont$list[[i]]$module)){""} else {feature_cont$list[[i]]$module},
                           "feed_nid" = if (is.null(feature_cont$list[[i]]$feed_nid)){""} else {feature_cont$list[[i]]$feed_nid},
                           "dh_link_facility_mps" = if (!length(feature_cont$list[[i]]$dh_link_facility_mps)){""} else {feature_cont$list[[i]]$dh_link_facility_mps[[1]]$id},
                           "dh_nextdown_id" = if (!length(feature_cont$list[[i]]$dh_nextdown_id)){""} else {feature_cont$list[[i]]$dh_nextdown_id[[1]]$id},
                           "dh_areasqkm" = if (is.null(feature_cont$list[[i]]$dh_areasqkm)){""} else {feature_cont$list[[i]]$dh_areasqkm},
                           "dh_link_admin_location" = if (!length(feature_cont$list[[i]]$dh_link_admin_location)){""} else {feature_cont$list[[i]]$dh_link_admin_location[[1]]$id},
                           "field_dh_from_entity" = if (!length(feature_cont$list[[i]]$field_dh_from_entity)){""} else {feature_cont$list[[i]]$field_dh_from_entity$id},
                           "field_dh_to_entity" = if (!length(feature_cont$list[[i]]$field_dh_to_entity)){""} else {feature_cont$list[[i]]$field_dh_to_entity$id},
                           "dh_geofield" = if (is.null(feature_cont$list[[i]]$dh_geofield$geom)){""} else {feature_cont$list[[i]]$dh_geofield$geom},
                           "geom" = if (is.null(feature_cont$list[[i]]$dh_geofield$geom)){""} else {feature_cont$list[[i]]$dh_geofield$geom}
      )
      
      # "dh_link_admin_location" = if (!length(feature_cont$list[[i]]$dh_link_admin_location)){""} else {feature_cont$list[[i]]$dh_link_admin_location[[1]]$id},
      
      
      feat  <- rbind(feat, feat_i)
    }
  } else {
    print("This Feature does not exist")
    return(FALSE)
  }
  feature <- feat
}