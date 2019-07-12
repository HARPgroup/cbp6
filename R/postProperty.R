#' Post Property Function 
#' @description posts information about the river segment
#' @param inputs the conveyance inputs 
#' @param base_url computer directory to give R access to username and pw 
#' @param prop property code
#' @return n/a
#' @import httr
#' @export getProperty

postProperty <- function(inputs,base_url,prop){
  
  #inputs <-prop_inputs
  #base_url <- site
  #Search for existing property matching supplied varkey, featureid, entity_type 
  dataframe <- getProperty(inputs, base_url, prop)
  if (is.data.frame(dataframe)) {
    pid <- as.character(dataframe$pid)
  } else {
    pid = NULL
  }
  if (!is.null(inputs$varkey)) {
    # this would use REST 
    # getVarDef(list(varkey = inputs$varkey), token, base_url)
    # but it is broken for vardef for now metadatawrapper fatal error
    # EntityMetadataWrapperException: Invalid data value given. Be sure it matches the required data type and format. 
    # in EntityDrupalWrapper->set() 
    # (line 736 of /var/www/html/d.dh/modules/entity/includes/entity.wrapper.inc).
    
    propdef_url<- paste(base_url,"/?q=vardefs.tsv/",inputs$varkey,sep="")
    propdef_table <- read.table(propdef_url,header = TRUE, sep = "\t")    
    varid <- propdef_table[1][which(propdef_table$varkey == inputs$varkey),]
    print(paste("varid: ",varid,sep=""))
    if (is.null(varid)) {
      # we sent a bad variable id so we should return FALSE
      return(FALSE)
    }
  }
  if (!is.null(inputs$varid)) {
    varid = inputs$varid
  }
  
  if (is.null(varid)) {
    print("Variable IS is null - returning.")
    return(FALSE)
  }
  
  pbody = list(
    bundle = 'dh_properties',
    featureid = inputs$featureid,
    varid = varid,
    entity_type = inputs$entity_type,
    proptext = inputs$proptext,
    propvalue = inputs$propvalue,
    propcode = inputs$propcode,
    startdate = inputs$startdate,
    propname = inputs$propname,
    enddate = inputs$enddate
  );
  
  if (is.null(pid)){
    print("Creating Property...")
    prop <- POST(paste(base_url,"/dh_properties/",sep=""), 
                 add_headers(HTTP_X_CSRF_TOKEN = token),
                 body = pbody,
                 encode = "json"
    );
    #content(prop)
    if (prop$status == 201){prop <- paste("Status ",prop$status,", Property Created Successfully",sep="")
    } else {prop <- paste("Status ",prop$status,", Error: Property Not Created Successfully",sep="")}
    
  } else if (length(dataframe$pid) == 1){
    print("Single Property Exists, Updating...")
    print(paste("Posting", pbody$varid )) 
    print(pbody) 
    #pbody$pid = pid
    prop <- PUT(paste(base_url,"/dh_properties/",pid,sep=""), 
                add_headers(HTTP_X_CSRF_TOKEN = token),
                body = pbody,
                encode = "json"
    );
    #content(prop)
    if (prop$status == 200){prop <- paste("Status ",prop$status,", Property Updated Successfully",sep="")
    } else {prop <- paste("Status ",prop$status,", Error: Property Not Updated Successfully",sep="")}
  } else {
    prop <- print("Multiple Properties Exist, Execution Halted")
  }
  
}