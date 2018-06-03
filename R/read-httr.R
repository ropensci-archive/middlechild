#' Read a serialized httr response object ndjson file
#' 
#' @md
#' @param path path to httr ndjson object file. Can be `.json` or `.json.gz`
#' @return a `list` of minimal `httr` response objects
#' @export
read_httr <- function(path) {

  path <- path.expand(path)

  if (!file.exists(path)) stop("File not found.", call.=FALSE)

  con <- if (grepl("\\.gz$", path)) gzfile(path) else file(path)
  
  obj <- jsonlite::stream_in(con, simplifyDataFrame=FALSE)
  
  lapply(obj, function(.x) {
    class(.x) <- c("response") # let httr know it's a response object
    class(.x$headers) <- c("insensitive", "list") # this makes it easier for httr to find headers
    .x$date <- anytime::anytime(.x$date) # anytime is a luxury; we can swap it out
    .x$content <- openssl::base64_decode(.x$content) # this is how httr expects to see content
    .x
  }) -> obj

  obj

}