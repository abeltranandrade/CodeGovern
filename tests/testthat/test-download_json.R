require(xml2)
require(rvest)
require(stringr)
require(htmltools)
require(tidyverse)
require(readr)
require(rjson)
require(methods)
require(XML)
my_Data_json <- get_gov_file("Lottery Powerball Winning Numbers Beginning 2010", "json")

test_that("json_downloads", {
  expect_equal(my_Data_json, fromJSON(file = "LotteryPowerballWinningNumbersBeginning2010.json"))
})
