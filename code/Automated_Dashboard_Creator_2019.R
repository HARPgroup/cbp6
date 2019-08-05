# mod.phase1 <- 'p6/p6_gb604' #or "p532c-sova" (phase 5)
# mod.scenario1 <- 'CFBASE30Y20180615' #or "p532cal_062211" (phase 5)
# mod.phase2 <- 'p6/p6_gb604' #or "p532c-sova" (phase 5)
# mod.scenario2 <- 'CBASE1808L55CY55R45P50R45P50Y' #or "p532cal_062211" (phase 5)
# start.date <- '1984-01-01'
# end.date <- '2000-12-31'
# github_link <- "C:\\Users\\danie\\Documents\\HARP\\Github"
# site_url <- "http://deq2.bse.vt.edu/d.dh"
# site.or.server <- 'site'

automated_dashboard <- function(mod.phase1, mod.scenario1, mod.phase2, mod.scenario2, start.date, end.date, github_link, site_url, site.or.server) {
  
  cbp6_link = paste0(github_link, "/cbp6/code");
  
  setwd(cbp6_link)
  dir.create(paste0('/opt/model/p6/p6_gb604/out/dashboards/', mod.scenario1, '.vs.', mod.scenario2))
  dash.output.dir <- paste0('/opt/model/p6/p6_gb604/out/dashboards/', mod.scenario1, '.vs.', mod.scenario2)
  metr.output.dir <- paste0('/opt/model/p6/p6_gb604/out/metrics')
  
  # Sourcing functions
  source(paste0(cbp6_link,"/cbp6_functions.R"))
  
  #retrieve rest token
  source(paste0(github_link, "/auth.private"));
  
  #load rest username and password, contained in auth.private file
  
  token <- rest_token(site_url, token, rest_uname, rest_pw);
  options(timeout=120); # set timeout to twice default level to avoid abort due to high traffic
  
  info <- read.csv(paste0(cbp6_link, "/data.csv"))
  base.table <- data.frame()
  climatechange.table <- data.frame()
  
  counter <- 1
  
  while (counter <= length(info$riv.seg)) { #change to number of rows on full csv
    print(paste('Generating dashboard for segment', counter, 'of', length(info$riv.seg), sep = ' '))
    riv.seg <- as.character(info[counter,1]) #input for model data import
    site_number <- paste0("0",info[counter,2]) #input for model data import
    rmarkdown::render(paste0("Working_Dashboard_2019.Rmd"), "pdf_document", output_dir = dash.output.dir, output_file = paste0(riv.seg, ".pdf"), 
                      params = list(token = token, riv.seg = riv.seg))
    # LOADING DATA ------------------------------------------------------------
    
    # if (site.or.server == 'site') {
    #   data1 <- model_import_data_cfs(riv.seg, mod.phase1, mod.scenario1, start.date, end.date)
    #   data2 <- model_import_data_cfs(riv.seg, mod.phase2, mod.scenario2, start.date, end.date)
    # } else if (site.or.server == 'server') {
    #   data1 <- model_server_import_data_cfs(riv.seg, mod.phase1, mod.scenario1, start.date, end.date)
    #   data2 <- model_server_import_data_cfs(riv.seg, mod.phase2, mod.scenario2, start.date, end.date)
    # }
    # 
    # data1 <- water_year_trim(data1)
    # data2 <- water_year_trim(data2)
    
    # metrics1 <- metrics_calc_all(data1) #calculate metrics into a matrix
    rownames(metrics1) <- (riv.seg)
    # metrics2 <- metrics_calc_all(data2)
    rownames(metrics2) <- (riv.seg)
    all_metrics <- metrics_compare(metrics1, metrics2, riv.seg)
    # table.metrics1 <- data.frame(riv.seg,metrics1[1,1],metrics1[1,67],metrics1[1,61],metrics1[1,59]) #create row to add to overall dataframe
    # table.metrics2 <- data.frame(riv.seg,metrics2[1,1],metrics2[1,67],metrics2[1,61],metrics2[1,59]) #create row to add to overall dataframe
    # colnames(table.metrics1) <- c('River Segment', 'Overall Mean Flow', 'Mean Baseflow', 'September 10%', '7Q10') 
    # colnames(table.metrics2) <- c('River Segment', 'Overall Mean Flow', 'Mean Baseflow', 'September 10%', '7Q10') 
    base.table <- rbind(base.table, metrics1, stringsAsFactors = FALSE)
    climatechange.table <- rbind(climatechange.table, metrics2, stringsAsFactors = FALSE)
    counter <- counter + 1
  }
  write.csv(base.table, file = paste0(metr.output.dir, paste0('//',mod.scenario1,'-metrics.csv')))
  write.csv(climatechange.table, file = paste0(metr.output.dir, paste0('//',mod.scenario2,'-metrics.csv')))
}
