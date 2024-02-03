library(testthat)
context("Testing process_outliers function")
testthat::test_that("identify outliers successfully", {
  score_result <- identify_outliers(c(1,2,3,4,5))
  expected_score <- as.numeric(c(-0.5,0.0,0.0,0.0,0.5))
  expect_equal(score_result, expected_score)
})

