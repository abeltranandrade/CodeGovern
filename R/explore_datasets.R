library(rvest)
library(tidyverse)
library(stringr)
library(purrr)

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
  if(format != "/?res_format=CSV&res_format=JSON"){
    format <- toupper(format) # transformation Needed to be upper case in url
    if(FirstParameter){full_url <- paste(startingPoint,"/", FPPrefix,filter_str[1], format, sep =""); FirstParameter <- FALSE}
  }
  else if(format != "all"){
    if(FirstParameter){full_url <- paste(startingPoint, format, sep =""); FirstParameter <- FALSE}
  }

  if(!(is.na(OrgType))){
    OrgType <- gsub(" ", "+",OrgType) # transformation Needed + between words
    if(FirstParameter){full_url <- paste(startingPoint, FPPrefix, filter_str[2], OrgType, sep =""); FirstParameter <- FALSE}
    else{full_url <- paste(full_url, NFPPrefix, filter_str[2], OrgType, sep ="")}
  }
  cat("inside the nested function: ", full_url, "\n")
  #might have to change this when I do the defaults
  if(full_url == ""){full_url <- startingPoint}
  url_info <- list(full_url, FirstParameter)
  return(url_info)
}


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
explore_datasets <- function(entries, format = "/?res_format=CSV&res_format=JSON", OrgType = NA){
  # Bring in the  starting point html
  returnNames <- c()
  #Boolean to know if it has already used the base case
  baseCase <- TRUE
  #This is the URL offset counter, satarts at 2 because we start using it on the second page we scrape
  OffsetCounter <- 2

  #ensuring correct entries parameters
  if(entries < 1){
    errorCondition("Entries wanted need to be at least 1")
  }

  # ensuring correct format parameter
  if(format != "json" || format != "JSON" || format != "csv" || format != "CSV" ||
     format != "/?res_format=CSV&res_format=JSON" || format != "all" ){
    errorCondition("Invalid format parameter, please use ?explore_datasets for valid entries")
  }

  # ensuring correct format parameter
  if(OrgType != "Federal Government" || OrgType != "City Government" || OrgType != "State Government"
     || OrgType != "County Government" || OrgType != "University"){
    errorCondition("Invalid Organization Type parameter, please use ?explore_datasets for valid entries")
  }

  #Creating the URL and giving Information
  startingPoint <- "https://catalog.data.gov/dataset"
  url_info <- creatingFilteredURL(startingPoint ,format =  format, OrgType = OrgType)
  full_url <- url_info[1]
  FirstParameter <- url_info[2]

  #Scaping the URL created
  full_url <- as.character(full_url)
  html <- read_html(full_url)

#
#   tryCatch(expr = html <- read_html(full_url),
#            error = function(e){
#              stop <- "Error on input related to non-required parameters. Compare parameters using ?explore_dataset command"
#            } )
  # keep scraping titles if our list to return has less entries than what they asked for
  while(length(returnNames) < entries){
    #base case if this is the first page they scrape
    if(baseCase){
      # for the current page, get all the link tags and take their text to get the names (maybe include soomethig to take off special characters)
      aTag <-html  %>% html_nodes('.dataset-heading') %>% html_nodes('a')
      names <- aTag %>% html_text()
      returnNames <- append(returnNames, names)
      baseCase <- FALSE
      #if there is no entries on the first page of the URL, there are no matches for the input Dont continnue function
      if(length(returnNames) == 0){
        return(warning("This search brought no results. Please try different parameters"))
      }
    }
    else{
      # Different prefix if parameters are present
      if(FirstParameter == TRUE){pre <- "/?page="}else{pre <- "&page="}

      # creating the offset page URL and scraping the HTML
      newURL <- paste0(full_url,pre, as.character(OffsetCounter))
      cat("the new URL is ", newURL, "\n")
      html <- read_html(newURL)

      #finding the link tags with the titles
      aTag <-html  %>% html_nodes('.dataset-heading') %>% html_nodes('a')
      if(length(aTag) == 0){
        return(returnNames)
      }
      # here we could divide if its used for the users or for internal testing
      names <- aTag %>% html_text()
      returnNames <- append(returnNames, names)
      cat(" || and the amount of names are ", length(returnNames), "\n")
      OffsetCounter <- OffsetCounter + 1
    }
  }
  return(returnNames[0:entries])
}

Hehe <- explore_datasets(35)

# 2 Parameters, 2 pages
titles1 <- explore_datasets(35, format = "csv", OrgType = "Federal Government")
titles1
length(titles1)

# no paramets, less than 20
titles2 <- explore_datasets(10)
titles2
length(titles2)

# no parameters, more than 20
titles3 <- explore_datasets(30)
titles3
length(titles3)

# 1 parameter, 1 page
titles4 <- explore_datasets(10, format = "json")
titles4
length(titles4)

# 1 parameter l 2 pagese
titles4 <- explore_datasets(30, OrgType = "University")
titles4
length(titles4)



