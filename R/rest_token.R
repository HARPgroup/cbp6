#' Rest Token Function 
#' @description Obtains token to access deq2 
#' @param base_url computer directory to give R access to username and pw 
#' @param token token that allows you to access deq2
#' @param rest_uname username to gain access to token
#' @param rest_pw password to gain access to token 
#' @return the rest token used to generate the gis image 
#' @import httr
#' @export rest_token

rest_token <- function(base_url, token, rest_uname = FALSE, rest_pw = FALSE) {
  
  #Cross-site Request Forgery Protection (Token required for POST and PUT operations)
  csrf_url <- paste(base_url,"restws/session/token/",sep="/");
  
  #IF THE OBJECTS 'rest_uname' or 'rest_pw' DONT EXIST, USER INPUT REQUIRED
  if (!is.character(rest_uname) | !(is.character(rest_pw))){
    
    rest_uname <- c() #initialize username object
    rest_pw <- c()    #initialize password object
    
    #currently set up to allow infinite login attempts, but this can easily be restricted to a set # of attempts
    token <- c("rest_uname","rest_pw") #used in while loop below, "length of 2"
    login_attempts <- 1
    if (!is.character(rest_uname)) {
      print(paste("REST AUTH INFO MUST BE SUPPLIED",sep=""))
      while(length(token) == 2  && login_attempts <= 5){
        print(paste("login attempt #",login_attempts,sep=""))
        
        rest_uname <- readline(prompt="Enter REST user name: ")
        rest_pw <- readline(prompt="Password: ")
        csrf <- GET(url=csrf_url,authenticate(rest_uname,rest_pw));
        token <- content(csrf);
        #print(token)
        
        if (length(token)==2){
          print("Sorry, unrecognized username or password")
        }
        login_attempts <- login_attempts + 1
      }
      if (login_attempts > 5){print(paste("ALLOWABLE NUMBER OF LOGIN ATTEMPTS EXCEEDED"))}
    }
    
  } else {
    print(paste("REST AUTH INFO HAS BEEN SUPPLIED",sep=""))
    print(paste("RETRIEVING REST TOKEN",sep=""))
    csrf <- GET(url=csrf_url,authenticate(rest_uname,rest_pw));
    token <- content(csrf);
  }
  
  if (length(token)==1){
    print("Login attempt successful")
    print(paste("token = ",token,sep=""))
  } else {
    print("Login attempt unsuccessful")
  }
  token <- token
} #close function