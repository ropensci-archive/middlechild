#' Read a serialed httr ndjson object file
#' 
#' @md
#' @param path path to httr ndjson object file
#' @export
read_httr <- function(path) {

  path <- path.expand(path)

  if (!file.exists(path)) stop("File not found.", call.=FALSE)

  obj <- jsonlite::stream_in(file(path), simplifyDataFrame=FALSE)
  
  lapply(obj, function(.x) {
    class(.x) <- c("response")
    class(.x$headers) <- c("insensitive", "list")
    .x$date <- anytime::anytime(.x$date)
    .x$content <- openssl::base64_decode(.x$content)
    .x
  }) -> obj

  obj

}