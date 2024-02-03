library(testthat)
context("Testing process_NA function")
test_that("identify NAs successfully",{
  result <- process_NA(c(1,2,3,4,5))
  expect_equal(result, "No missing values detected")
})