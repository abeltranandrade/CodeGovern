library(rvest)
library(stringr)

#' Title
#'
#' @return
#' @export
#'
#' @examples
#'
get_gov_file <- function(name, type){
  prefix <- "https://catalog.data.gov/dataset"
  #Specific name needs to be lowercase and with dashes between words
  specific <- tolower(name)
  specific <- gsub(" ", "-", specific)
  # paste the prefix and name together with a slash and no spaces
  full_url <- paste0(prefix,"/", specific, sep = "")
  #get HTML of the name given
  html <- read_html(full_url)

  return(html)

}
#This below is all just experimenting
# name <- "Lottery Powerball Winning Numbers Beginning 2010"
# print(get_gov_file(name))
#
# test <- read_html("https://catalog.data.gov/dataset/lottery-powerball-winning-numbers-beginning-2010")
#
# sections <- test %>% html_elements("item prop")
#
# #. means class
# tag <- test %>% html_elements(".btn-group")
#
# link <- test %>% html_elements("a") %>% html_attr("title")
#
# link <- test %>% html_elements("#dataset-resources") %>% html_elements("a")
#
# btnlink <- test %>% html_elements("#dataset-resources") %>% html_elements("a") %>% html_elements(".btn btn-primary")
#
# btnlink <- test %>% html_elements("#dataset-resources") %>% html_elements(".btn btn-primary")
#
# text <- link %>% html_elements(".btn btn-primary")
