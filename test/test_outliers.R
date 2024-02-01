library(testthat)
context("Testing identify_outliers function")
testthat::test_that("identify outliers successfully", {
  score_result <- identify_outliers(c(1,2,3,4,5))
  expected_score <- as.numeric(c(1,2,3,4,5))
  expect_equal(score_result, expected_score)
})




# class(identify_outliers(c(1,2,3,4,5)))
double numeric
