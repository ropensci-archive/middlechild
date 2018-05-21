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
