# for macOS — find where the networksetup utility is
find_networksetup <- function() {
  out <- unname(Sys.which("networksetup"))
  if (out == "") stop("Cannot find 'networksetup'. Are you running macOS?")
  out
}

os_type <- function() {
  .Platform$OS.type
}

is_windows <- function() {
  .Platform$OS.type == "windows"
}

is_linux <- function() {
  identical(tolower(Sys.info()[["sysname"]]), "linux")
}

find_mitm <- function() {
  mitm_bin <- Sys.which("mitmdump")
  if (mitm_bin == "") {
    stop("mitmdump not found. Please run middlechild::install_mitm().")
  }
  unname(mitm_bin)
}


# hp_orig <- Sys.getenv("http_proxy")
# hps_orig <- Sys.getenv("https_proxy")
# 
# Sys.setenv(http_proxy="http://localhost:8080")
# Sys.setenv(https_proxy="http://localhost:8080")
# 
# on.exit(Sys.setenv(http_proxy=hp_orig), add=TRUE)
# on.exit(Sys.setenv(https_proxy=hps_orig), add=TRUE)
