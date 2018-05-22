perform_safety_check <- function(chk_df) {
  sapply(1:nrow(chk_df), function(i) {
    ret <- NULL
    ret <- c(ret, if(grepl("cran", chk_df[i, "req_url"])) "Info:CRAN" else NULL)
    ret <- c(ret, if(grepl("^http://", chk_df[i, "req_url"])) "NoSSL" else NULL)
    ret <- c(ret, if(chk_df[i, "status_code"] != 200) sprintf("Code:%s", chk_df[i, "status_code"]) else NULL)
    ret <- c(ret, if(grepl("^R \\(|^libcurl", chk_df[i, "user_agent"])) "BadUA" else NULL)
    paste(ret, collapse=",")
  }, USE.NAMES = FALSE)
}

#' Check the HAR from the mitm_check() call
#' 
#' @md
#' @param mitm_check_har HAR file from [mitm_check()]
#' @export
check_check <- function(mitm_check_har) {
  
  do.call(
    rbind.data.frame,
    lapply(mitm_check_har$log$entries, function(.x) {
      
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
  
  xdf$issues <- perform_safety_check(xdf)
  
  class(xdf) <- c("tbl_df", "tbl", "data.frame")
  
  xdf <- xdf[,c(5,1,2,3,4)]
  
  xdf
  
} 

# R (3.5.0 x86_64-apple-darwin15.6.0 x86_64 darwin15.6.0)
# libcurl/7.54.0 r-curl/3.2 httr/1.3.1

