# Check the HAR from the mitm_check() call
check_check <- function(mitm_check_df) {
  
  do.call(
    rbind.data.frame,
    lapply(x$log$entries, function(.x) {
      
      req_url <- .x$request$url 
      status_code <- .x$response$status
      
      hdrs <- sapply(.x$request$headers, `[[`, "value")
      hdrs <- stats::setNames(hdrs, tolower(sapply(.x$request$headers, `[[`, "name")))
      
      data.frame(
        req_url = .x$request$url,
        method = .x$request$method,
        status_code = .x$response$status,
        user_agent = hdrs[["user-agent"]],
        stringsAsFactors=FALSE
      )
      
    })
  ) -> xdf
  
  class(xdf) <- c("tbl_df", "tbl", "data.frame")
  
  xdf
  
} 
# R (3.5.0 x86_64-apple-darwin15.6.0 x86_64 darwin15.6.0)
# libcurl/7.54.0 r-curl/3.2 httr/1.3.1

