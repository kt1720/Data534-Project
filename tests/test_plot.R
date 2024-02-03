library(testthat)
context("Testing average_median_bar_plot function")
test_that("average_median_bar_plot plots sucessfully",{
  simulate_input <- c("2023", "1")
  original_readline <- base::readline()
  base::readline <- function(prompt=""){
    next_input <- simulate_input[1]
    simulate_input <<- simulate_input[-1]
    return(next_input)
  }
  plot_result <- average_median_bar_plot()
  plot_title <- attr(plot_result, 'title')
  base::readline <- original_readline
  expected_title <- "Average median salaries of Legislators of year 2023"
  expect_equal(plot_title, expected_title)
  })


#2023, 1, 