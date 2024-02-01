library(testthat)
library(broom)
library(outliers)
context("Testing the get_df_annual_wage function")
test_that("get annual wage dataframe", {
  test_df <- data.frame(annual_wage_flag_salaire_annuel=c(0, 1),
                        wage_salaire=c(10, 10),
                        reference_period=c(2012, 2013))
  result_test_df <- get_df_annual_wage(test_df)
  expected_df <- data.frame(wage_salaire=c(20800, 10),
                            reference_period=c(2012, 2013))
  expect_equal(result_test_df, expected_df)
})

