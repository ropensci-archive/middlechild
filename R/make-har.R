#' Turn a HAR entry into an `httr` request function
#' 
#' @md
#' @note WIP
#' @param entry HAR entry
#' @param quiet if `FALSE` then cat the function source to the console
#' @return the created `httr` verb function (invisibly)
#' @export
as_httr_req <- function(entry, quiet = TRUE) {

  req <- entry$request # save typing

  mthd <- toupper(req$method) # we do some things conditionally on the request method

  # extract headers into a named list
  req$headers <- purrr::map(req$headers, "value") %>%
    purrr::set_names(
      map_chr(req$headers, "name")
    )

  # remove some cruft
  req$headers$`Content-Length` <- NULL
  req$headers$`Cookie` <- NULL

  # need this so deparsed things do not get truncated
  ml <- getOption("deparse.max.lines")
  options(deparse.max.lines = 10000)
  on.exit(options(deparse.max.lines = ml), add = TRUE)

  # base template for the function
  template <- "httr::VERB(\nverb = '%s',\nurl = '%s'\n%s%s%s%s%s%s\n)"

  # init
  hdrs <- enc <- bdy <- ckies <- auth <- verbos <- cfg <- ""

  # TODO work on headers (this was ripped from curlconverter so needs work)
  if (length(req$headers) > 0) {

    ct_idx <- which(
      grepl("content-type", names(req$headers), ignore.case = TRUE
      )
    )

    if (length(ct_idx) > 0) {

      ct <- req$headers[[ct_idx]]

      req$headers[[ct_idx]] <- NULL

      if (stringi::stri_detect_regex(ct, "multipart")) {
        enc <- ", encode = 'multipart'"
      } else if (stringi::stri_detect_regex(ct, "form")) {
        enc <- ", encode = 'form'"
      } else if (stringi::stri_detect_regex(ct, "json")) {
        enc <- ", encode = 'json'"
      } else {
        enc <- ""
      }

    }

    hdrs <- paste0(
      capture.output(dput(req$headers)), collapse = ""
    )

    hdrs <- sub("^list", ", httr::add_headers", hdrs)

  }

  # extract POST data from HAR entry
  # TODO handle other mimeTypes
  if ((mthd == "POST") & (length(req$postData) > 0)) {

    if (req$postData$mimeType == "application/json") {
      bdy_bits <- paste0(
        capture.output(
          dput(
            jsonlite::fromJSON(
              req$postData$text, simplifyDataFrame = FALSE, flatten = FALSE
            )
          )
        ), collapse = "")
    }

    bdy <- sprintf(", body = %s", bdy_bits)

  }

  # TODO need to retrofit for HAR
  if (length(req$url_parts$username) > 0) {
    auth <- sprintf(
      ", httr::authenticate(user='%s', password='%s')",
      req$url_parts$username, req$url_parts$password
    )
  }

  # extract cookies
  if (length(req$cookies) > 0) {
    ckies <- purrr::map(req$cookies, "value") %>%
      purrr::set_names(
        map_chr(req$cookies, "name")
      )

    ckies <- paste0(
      capture.output(dput(ckies)),
      collapse = ""
    )
    ckies <- sub("^list", ", httr::set_cookies", ckies)
  }

  # need the request URL
  REQ_URL <- req$url

  # fill in template
  # TODO perhaps replace with glue?
  out <- sprintf(
    template, mthd, REQ_URL, auth,
    verbos, hdrs, ckies, bdy, enc
  )

  # do some basic source reformatting
  formatR::tidy_source(
    text = out, width.cutoff = 30, indent = 4, output = FALSE
  ) -> tmp

 tmp <- paste0(tmp$text.tidy, collapse = "\n")
 
  if (!quiet) cat(tmp, "\n")

  # make the function
  f <- function() {}
  formals(f) <- NULL
  environment(f) <- parent.frame()
  body(f) <- as.expression(parse(text = tmp))

  invisible(f)

}
