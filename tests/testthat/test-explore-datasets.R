library(testthat)

#Given popularity of the datasets changing rapidly, hard coded check fails after hours of updating it. Need to find a new way to test it although unsure.

# PopCSVJSONFed <- c("FDIC Failed Bank List","Alzheimer's Disease and Healthy Aging Data","U.S. Chronic Disease Indicators (CDI)",
#                    "United States COVID-19 Cases and Deaths by State over Time","Consumer Complaint Database","Walkability Index",
#                    "Indicators of Anxiety or Depression Based on Reported Frequency of Symptoms During Last 7 Days","Drug overdose death rates, by drug type, sex, age, race, and Hispanic origin: United States",
#                    "Clean Air Status and Trends Network (CASTNET): Ozone","Mental Health Care in the Last 4 Weeks","Nutrition, Physical Activity, and Obesity - Behavioral Risk Factor Surveillance System",
#                    "NCHS - Leading Causes of Death: United States", "Death rates for suicide, by sex, race, Hispanic origin, and age: United States",
#                    "Conditions Contributing to COVID-19 Deaths, by State and Age, Provisional 2020-2022", "FHFA House Price Indexes (HPIs)","Heart Disease Mortality Data Among US Adults (35+) by State/Territory and County",
#                    "Obesity among children and adolescents aged 2–19 years, by selected characteristics: United States", "Meteorite Landings", "COVID-19 Vaccination and Case Trends by Age Group, United States",
#                    "U.S. Electric Utility Companies and Rates: Look-up by Zipcode (2015)", "Public School Characteristics 2019-20","Center for Medicare & Medicaid Services (CMS) , Medicare Claims data","Feed Grains Database", "COVID-19 Case Surveillance Public Use Data", "Specific Chronic Conditions")
#
# test_that("two-pages-default-format-OrgType", {
#   expect_equal(PopCSVJSONFed, explore_datasets(25, format = "csv", OrgType = "Federal Government"))
# })

test_that("invalid-format", {
  expect_error(explore_datasets(30, format = "hairstyle") )
})

test_that("invalid-OrgType", {
  expect_error(explore_datasets(30, OrgType  = "House") )
})

test_that("invalid-entries", {
  expect_error(explore_datasets(0, OrgType  = "House") )
})
