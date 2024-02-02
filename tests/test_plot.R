library(testthat)
context("Testing average_median_bar_plot function")
test_that("average_median_bar_plot plots sucessfully",{
  plot_result <- average_median_bar_plot()
  plot_title <- attr(plot_result, 'title')
  expected_title <- "Average median salaries of Senior government managers and officials of year 2022"
  expect_equal(plot_title, expected_title)
  })
