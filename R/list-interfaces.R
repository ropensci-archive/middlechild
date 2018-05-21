.ls_int_macos <- function() {
  
  ns <- find_networksetup()
  
  # find all the hw ports on the system
  res <- system2(ns, args = c("-listallhardwareports"), stdout = TRUE, stderr = FALSE)
  
  # parse output
  res <- res[grepl(":", res)]
  con <- textConnection(res)
  on.exit(close(con))
  res <- read.dcf(con, all = TRUE)
  
  data.frame(
    hw_port = unlist(res[,1], use.names = FALSE),
    dev = unlist(res[,2], use.names = FALSE),
    mac = unlist(res[,3], use.names = FALSE),
    stringsAsFactors = FALSE
  ) -> res
  
  class(res) <- c("tbl_df", "tbl", "data.frame")
  
  res  

}

#' List network interfaces on the system
#' 
#' @md
#' @export
#' @keywords internal
list_interfaces <- function() {
  
  if (is_windows()) {
    
  } else if (is_linux()) {
    
  } else { # assume macos
    .ls_int_macos()
  }
  
}
