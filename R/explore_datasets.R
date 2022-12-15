library(rvest)
library(tidyverse)
library(stringr)
library(purrr)


#' Explore Datasets
#'
#' Will give the users their desired amount of dataset names they could download and they can filter the datasets by topic, format, Organization type or Organization
#'publishing. For the available inputs check parameters.
#'
#' @param entries the amount of data set names to return as an integer
#' @param format What data format you want to download. Default you look for both csv and json, as that is what get_gov_file currently supports. You can use csv (only csv files)  or json (only json files). You can use parameter "all" to see all
#' datasets no matter what format it is.
#' @param OrgType What organization type published the data. Options are  "City Government", "State Government","Federal Government" , "County Government", "University"
#'
#' @return
#' @export
#'
#' @examples
explore_datasets <- function(entries, format = "res_format=CSV&res_format=JSON", OrgType = NA){
  # Bring in the  starting point html
  returnNames <- c()
  #Boolean to know if it has already used the base case
  baseCase <- TRUE
  #This is the URL offset counter, satarts at 2 because we start using it on the second page we scrape
  OffsetCounter <- 2
  startingPoint <- "https://catalog.data.gov/dataset"
  full_url <- creatingFilteredURL(startingPoint ,format =  format)

  cat(full_url)
  #scraping the root url

  tryCatch(expr = html <- read_html(full_url),
           error = function(e){
             stop <- "Error on input related to non-required parameters. Compare parameters using ?explore_dataset command"
           } )

  # keep scraping titles if our list to return has less entries than what they asked for
  while(length(returnNames) < entries){
    #base case if this is the first page they scrape
    if(baseCase){
      # for the current page, get all the link tags and take their text to get the names (maybe include soomethig to take off special characters)
      aTag <-html  %>% html_nodes('.dataset-heading') %>% html_nodes('a')
      names <- aTag %>% html_text()
      returnNames <- append(returnNames, names)
      baseCase <- FALSE
    }
    else{
      # creating the offset page URL and scraping the HTML
      pre <- "/?page="
      print(as.character(OffsetCounter))
      newURL <- paste0(startingPoint,pre, as.character(OffsetCounter))
      html <- read_html(newURL)
      #finding the link tags with the titles
      aTag <-html  %>% html_nodes('.dataset-heading') %>% html_nodes('a')
      # here we could divide if its used for the users or for internal testing
      names <- aTag %>% html_text()
      returnNames <- append(returnNames, names)
      OffsetCounter <- OffsetCounter +1
    }
  }
  return(returnNames[0:entries])
}
titles2 <- explore_datasets(35, format = "hairstyle")
titles


#should be over the other for running purposes but do not want it there
# function to write the URLs
creatingFilteredURL <- function(startingPoint, topic = NA, format = NA, OrgType = NA){
  #Boolean to let us know if to use ? or & to join the parameters
  FirstParameter <- TRUE
  FPPrefix <- "?"
  NFPPrefix <- "&"
  filter_str <- c("res_format=","organization_type=")

  full_url <-""
  #formatting the URL with correct filters and connetors
  if(!(is.na(format))){
    format <- toupper(format) # transformation Needed to be upper case in url
    if(FirstParameter){full_url <- paste(startingPoint, FPPrefix, filter_str[1], format, sep =""); FirstParameter <- FALSE}
    else{full_url <- paste(full_url, NFPPrefix, filter_str[1], format, sep ="")}
  }
  if(!(is.na(OrgType))){
    if(FirstParameter){full_url <- paste(startingPoint, FPPrefix, filter_str[2], OrgType, sep =""); FirstParameter <- FALSE}
    else{full_url <- paste(full_url, NFPPrefix, filter_str[2], OrgType, sep ="")}
  }
  return(full_url)
}
