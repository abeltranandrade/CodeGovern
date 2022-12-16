require(xml2)
require(rvest)
require(stringr)
require(htmltools)
require(tidyverse)

alert_notice <- federalalert("Electric Vehicle Population Data")

test_that("alert_displays", {
  expect_equal(alert_notice, "Alert: This is a Non-Federal dataset covered by different Terms of Use than Data.gov")
})
