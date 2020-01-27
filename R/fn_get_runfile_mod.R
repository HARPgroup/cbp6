fn_get_runfile_mod <- function(
  elementid = -1, runid = -1, scenid = 37,
  site = "http://deq2.bse.vt.edu", cached = TRUE, outaszoo=TRUE
) {
  if (elementid == -1 ) {
    return(FALSE);
  }
   if (runid == -1 ) {
    return(FALSE);
  }
  # may be obsolete
  #setInternet2(TRUE)
  
  # just get the run file
  finfo = fn_get_runfile_info(elementid, runid, scenid, site)
  if (!is.list(finfo)) {
    return(FALSE);
  }
  filename = as.character(finfo$remote_url);
  if (filename == '.zip') {
    return(FALSE)
  }
  localname = basename(as.character(finfo$output_file));
  if (cached & file.exists(localname)) {
    linfo = file.info(localname)
    if (as.Date(finfo$run_date) > as.Date(linfo$mtime)) {
      # re-download if the remote is newer than the local
      if (finfo$compressed == 1) {
        print(paste("Downloading Compressed Run File ", filename));
        download.file(filename,'tempfile',mode="wb", method = "libcurl");
        filename <-  unzip ('tempfile');
      } else {
        print(paste("Downloading Un-compressed Run File ", filename));
      }
    } else {
      # not new, so just use the local copy
      print(paste("Remote file date ", as.Date(finfo$run_date), " <= run date ", as.Date(linfo$mtime), "Using cached copy "));
      filename = localname
    }
  } else {
    # does not exist locally
    if (finfo$compressed == 1) {
      print(paste("Downloading Compressed Run File ", filename));
      download.file(filename,'tempfile',mode="wb", method = "libcurl");
      filename <-  unzip ('tempfile');
    }
  }
  dat = try(read.table( filename, header = TRUE, sep = ",")) ;
  if (class(dat)=='try-error') { 
    # what to do if file empty 
    print(paste("Error: empty file ", filename))
    return (FALSE);
  } else { 
    #dat<-read.table(filename, header = TRUE, sep = ",")   #  reads the csv-formatted data from the url	
    print(paste("Data obtained, found ", length(dat[,1]), " lines - formatting for IHA analysis"))
    datv<-as.vector(dat)  # stores the data as a vector     
    datv$timestamp <- as.POSIXct(datv$timestamp,origin="1970-01-01")
    f3 <- zoo(datv, order.by = datv$timestamp)
  }
  unlink('tempfile')
  if(outaszoo){
    return(f3)  
  }else{
    return(datv)  
  }
}
