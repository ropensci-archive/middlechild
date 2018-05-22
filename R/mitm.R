
#' MITM check
#'
#' @param timeout Wait time after launching MITM server to run R code
#' @param package_path  Path to a local copy of a R package
#'
#' @return list
#' @export
#'
#' @examples
#' \dontrun{
#' mitm_check(package_path = "/local/path")
#' }
mitm_check <- function(package_path, timeout = 4) {
  
  if(is.null(package_path))
      stop("Need a local path to a package to run checks", call. = FALSE)
  http_proxy="http://localhost:8080"
  file <- system.file("mitm", "har_dump.py", package = "middlechild")
  # temp_dir <- tempdir()
  dump_file <- tempfile(fileext = ".har")
  # mitmdump -s ./har_dump.py --set hardump=./dump.har
  args <- c("-s", file,  "--set", paste0("hardump=dump.har"))
  pid <- sys::exec_background(cmd = "/usr/local/bin/mitmdump", args = args)
  on.exit(tools::pskill(pid))
  Sys.sleep(timeout)
  devtools::check(package_path, quiet = TRUE)
  
  HARtools::readHAR('dump.har')

}