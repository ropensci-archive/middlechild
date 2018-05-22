#' Spawn a mitmdump background process and return the process id
#' 
#' @md
#' @param args see [sys::exec_background()]
#' @export
call_mitm <- function(args) {
  
  mitm_bin <- find_mitm()
  
  pid <- sys::exec_background(cmd = mitm_bin, args = args)
  
  pid

}