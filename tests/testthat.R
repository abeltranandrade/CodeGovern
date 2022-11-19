# This file is part of the standard setup for testthat.
# It is recommended that you do not modify it.
#
# Where should you do additional test configuration?
# Learn more about the roles of various files in:
# * https://r-pkgs.org/tests.html
# * https://testthat.r-lib.org/reference/test_package.html#special-files

library(testthat)
library(CodeGovern)

test_check("CodeGovern")

my_Data <- get_gov_file("Lottery Powerball Winning Numbers Beginning 2010", "csv")
expect_equal(my_Data, read_csv("Lottery Powerball Winning Numbers Beginning 2010.csv"))

my_Data_json <- get_gov_file("Lottery Powerball Winning Numbers Beginning 2010", "json")
expect_equal(my_Data_json, fromJSON('Lottery Powerball Winning Numbers Beginning 2010.json'))

#expect_error(get_gov_file("123xyz"), 'There was an error. The dataset was not found Error in open.connection(x, "rb") : HTTP error 404.', fixed=TRUE)



