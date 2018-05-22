#' Spawn a mitmdump background process with custom args and return the process id
#' 
#' Returns process id. Use [tools::pskill()] to kill.
#' 
#' @md
#' @param args see [sys::exec_background()]
#' @family mitm_helpers
#' @export
call_mitm <- function(args) {
  
  mitm_bin <- find_mitm()
  
  pid <- sys::exec_background(cmd = mitm_bin, args = args)
  
  pid

}

#' Spawn a mitmdump background process in "HAR capture" mode and return the process id
#' 
#' Returns `mitm_pid` object which can be used with [stop_mitm()] to kill 
#' the mitmproxy process and retrieve the generated HAR file or [mitm_status()] 
#' to check on the status of the background process.
#' 
#' @md
#' @param etra_args see `args` in [sys::exec_background()]
#' @return `mitm_pid` object
#' @family mitm_helpers
#' @export
start_mitm <- function(extra_args=NULL) {
  
  mitm_bin <- find_mitm()
  
  har_script <- system.file("mitm", "har_dump.py", package = "middlechild")
  
  dump_file <- tempfile(fileext = ".har")
  
  args <- c("-s", har_script, "--set", sprintf("hardump=%s", dump_file), 
            extra_args)
  
  pid <- call_mitm(args = args) # mitmdump -s ./har_dump.py --set hardump=./dump.har ...
  
  out <- list(pid=pid, dump_file = dump_file)
  
  class(out) <- c("mitm_pid")
  
  out

}

#' Stop the mitmproxy background process and retrieve the generated HAR file
#' 
#' @md
#' @param pid_obj `mitm_pid` object created with `start_mitm`
#' @return `HARtools` object or `NULL`
#' @export
stop_mitm <- function(pid_obj) {
  
  tools::pskill(pid_obj$pid)
  
  Sys.sleep(3) # pause
  
  on.exit(unlink(pid_obj$dump_file), add=TRUE)
  
  HARtools::readHAR(pid_obj$dump_file)
  
}

#' Check on the status of an mitmproxy process created with `mitm_start()`
#' 
#' @md
#' @param #' @param pid_obj `mitm_pid` object created with `start_mitm`
#' @return logical. `TRUE` if the background process is still running
#' @export
mitm_status <- function(pid_obj) {

  is.na(sys::exec_status(pid_obj$pid, wait=FALSE))
    
}

#' Show the mitmdump help screen 
#' 
#' @family mitm_helpers
#' @export
mitm_help <- function() {
  mitm_bin <- find_mitm()
  system2(mitm_bin, "--help", stdout = "")
}