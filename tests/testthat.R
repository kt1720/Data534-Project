# This file is part of the standard setup for testthat.
# It is recommended that you do not modify it.
#
# Where should you do additional test configuration?
# Learn more about the roles of various files in:
# * https://r-pkgs.org/testing-design.html#sec-tests-files-overview
# * https://testthat.r-lib.org/articles/special-files.html
source("D:/MDS/block4/Data534/project/get_wage/Data534-Project/R/get_wage.R")
source("D:/MDS/block4/Data534/project/get_wage/Data534-Project/R/helpers.R")
source("D:/MDS/block4/Data534/project/get_wage/Data534-Project/R/wage_trend.R")

if (!requireNamespace("testthat", quietly = TRUE)) {
  install.packages("testthat")
}
if (!requireNamespace("magick", quietly = TRUE)) {
  install.packages("magick")
}
if (!requireNamespace("imager", quietly = TRUE)) {
  install.packages("imager")
}

library(testthat)
library(magick)
library(imager)

records=get_wage(c("2012","2013","2016","2019","2020","2021","2022","2023"))
records
test_that("test the overall",  {
  # dev.new()
  # call my function
  trend(records,"overall")
  # Load the image using magick
  # generated_img <- magick::image_read("D:/MDS/block4/Data534/project/get_wage/Data534-Project/R/overall_wage_trend.png")
  # # comparing image
  # reference_img <- imager::load.image("D:/MDS/block4/Data534/project/get_wage/Data534-Project/R/overall.png")
  # # Compare the images
  # diff <- imager::imdiff(generated_img, reference_img)
  # # Check if the difference is below a certain threshold
  # expect_true(diff < 0.1)

  # Check some properties of the image
  # expect_true(magick::image_info(generated_img)$width == 2400)
  # expect_true(magick::image_info(generated_img)$height== 1800)
  # Check if a plot has been created
  expect_true(length(dev.list()) > 0)

})

test_that("test the specific",  {
  # call my function
  trend(records,"specific",provs=c("Quebec","British Columbia","Ontario"),positions=c("Legislators","Senior Managers - Trade"))
  # Check if a plot has been created
  # generated_img <- magick::image_read("D:/MDS/block4/Data534/project/get_wage/Data534-Project/R/special_wage_trend.png")
  # Check some properties of the image
  # expect_true(magick::image_info(generated_img)$width == 2400)
  # expect_true(magick::image_info(generated_img)$height== 1800)
  expect_true(length(dev.list()) > 0)
})


