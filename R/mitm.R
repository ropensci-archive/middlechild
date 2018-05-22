#' R CMD check a package (source tree), capturing network calls.
#'
#' @param package_path  Path to a local copy of a R package
#' @param timeout Wait time after launching MITM server to run R code
#' @param quiet passed on to [devtools::check()]; Default `FALSE`.
#' @return data frame (tibble) of safety check results or `NULL` if package check errors
#' @export
#' @examples
#' \dontrun{
#' mitm_check(package_path = "/local/path")
#' }
mitm_check <- function(package_path,
                       timeout = 3,
                       quiet = FALSE) {
  
  
  if (is.null(package_path)) {
    stop("Need a local path to a package to run checks", call. = FALSE)
  }
  
  har_script <-
    system.file("mitm", "har_dump.py", package = "middlechild")
  
  dump_file <- tempfile(fileext = ".har")
  
  on.exit(unlink(dump_file), add = TRUE) # remove tmp file when done w/f()
  
  args <-
    c("-s", har_script, "--set", sprintf("hardump=%s", dump_file))
  
  pid <-
    call_mitm(args = args) # mitmdump -s ./har_dump.py --set hardump=./dump.har
  
  on.exit(tools::pskill(pid), add = TRUE) # kill mitmproxy when done w/f() if errors
  
  Sys.sleep(timeout) # give mitm a chance to run
  
  devtools::check(
    # do the thing
    pkg = package_path,
    quiet = quiet,
    env_vars = c(http_proxy = "http://localhost:8080",
                 https_proxy = "http://localhost:8080")
  ) -> res
  
  if (length(res$errors) > 0) {
    warning(
      "Package check failed with errors. Please run manually and fix errors before running mitm_check()."
    )
    return(NULL)
  }
  
  tools::pskill(pid) # kill mitmproxy so we can get the HAR file
  
  Sys.sleep(timeout) # give mitm a chance to quit
  
  out <- HARtools::readHAR(dump_file)
  
  check_check(out)

}
