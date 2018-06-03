context("test-mitm.R")

test_that("MITM works", {
  skip_on_cran()
  path <- file.path(tempfile(pattern = "git2r-"), "git2r")
  dir.create(path, recursive = TRUE)
  repo <- git2r::clone("git://github.com/ropensci/rAltmetric", path)
  z <- mitm_check(path, quiet = TRUE)
  testthat::expect_identical(class(z), c("tbl", "tbl_df", "data.frame"))
  unlink(path)
})
