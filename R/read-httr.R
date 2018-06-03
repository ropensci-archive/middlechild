#' Read a serialized httr response object ndjson file
#' 
#' @md
#' @param path path to httr ndjson object file. Can be `.json` or `.json.gz`
#' @export
read_httr <- function(path) {

  path <- path.expand(path)

  if (!file.exists(path)) stop("File not found.", call.=FALSE)

  con <- if (grepl("\\.gz$", path)) gzfile(path) else file(path)
  
  obj <- jsonlite::stream_in(con, simplifyDataFrame=FALSE)
  
  lapply(obj, function(.x) {
    class(.x) <- c("response")
    class(.x$headers) <- c("insensitive", "list")
    .x$date <- anytime::anytime(.x$date)
    .x$content <- openssl::base64_decode(.x$content)
    .x
  }) -> obj

  obj

}