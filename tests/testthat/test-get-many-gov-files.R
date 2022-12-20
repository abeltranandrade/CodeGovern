library(testthat)

test_that("Invalid-Name", {
  expect_error(get_many_gov_files("Fake Name", "FDIC Failed Bank List"))
})
