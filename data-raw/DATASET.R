## code to prepare `DATASET` dataset goes here
library(tidyverse)
library(janitor)
Lottery2010 <- read.csv("data-raw/Lottery Powerball Winning Numbers Beginning 2010.csv") %>%
  clean_names()

usethis::use_data(Lottery2010, overwrite = TRUE)
