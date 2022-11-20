require(xml2)
require(rvest)
require(stringr)
require(htmltools)
require(tidyverse)
require(readr)
require(rjson)
require(methods)
require(XML)
my_Data <- get_gov_file("Lottery Powerball Winning Numbers Beginning 2010", "csv")

test_that("csv_downloads", {
  expect_equal(my_Data, read_csv("LotteryPowerballWinningNumbersBeginning2010.csv"))
})
