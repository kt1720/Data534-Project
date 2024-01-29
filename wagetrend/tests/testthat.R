# This file is part of the standard setup for testthat.
# It is recommended that you do not modify it.
#
# Where should you do additional test configuration?
# Learn more about the roles of various files in:
# * https://r-pkgs.org/testing-design.html#sec-tests-files-overview
# * https://testthat.r-lib.org/articles/special-files.html

library(testthat)
library(wagetrend)

test_that("test the overall",  {
  # call my function
  trend("overall")
  # Check if a plot has been created
  expect_true(length(dev.list()) > 0)
})

test_that("test the specific",  {
  # call my function
  trend("specific",provs=c("BC","AB","ON"),positions=c("Data_entry_clerks","Legislators"))
  # Check if a plot has been created
  expect_true(length(dev.list()) > 0)
})

# test_check("wagetrend")

# test("testthat")
