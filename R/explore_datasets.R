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

  # if all formats then don't specify a specific one
  if(format == "all"){format <- NA}

  #formatting the URL with correct filters and connetors
  if(!is.na(format)){ #if its not for all results
    if(format != "/?res_format=CSV&res_format=JSON"){ # if its not default
      format <- toupper(format) # transformation Needed to be upper case in url
      full_url <- paste(startingPoint,"/", FPPrefix,filter_str[1], format, sep ="")
      FirstParameter <- FALSE
    }
  }

  if(!(is.na(OrgType))){
    OrgType <- gsub(" ", "+",OrgType) # transformation Needed + between words
    if(FirstParameter){full_url <- paste(startingPoint, FPPrefix, filter_str[2], OrgType, sep =""); FirstParameter <- FALSE}
    else{full_url <- paste(full_url, NFPPrefix, filter_str[2], OrgType, sep ="")}
  }

  #if we have not created the full URL then its the base case (starting point)
  if(full_url == ""){full_url <- startingPoint}
  url_info <- list(full_url, FirstParameter)
  return(url_info)
}


#' Explore Datasets
#'
#' Returns to  users a desired amount of dataset names they could download. They can filter the datasets by format or Organization type. Meant to be used with get_gov_file function.
#'
#' @param entries the amount of data set names to return as an integer
#' @param format What data format you want to download. Default you look for both csv and json, as that is what get_gov_file currently supports. You can use csv (only csv files)  or json (only json files). You can use parameter "all" to see all
#' datasets no matter what format it is.
#' @param OrgType What organization type published the data. Options are  "City Government", "State Government","Federal Government" , "County Government", "University"
#'
#' @return a character vector with the names of datasets
#' @export
#'
#' @examples
#' library(CodeGovern)
#' # 2 Parameters, 2 pages
#' titles1 <- explore_datasets(25, format = "csv", OrgType = "Federal Government")
#' # no parameters, 1 page scraped
#' titles2 <- explore_datasets(10)
explore_datasets <- function(entries, format = "/?res_format=CSV&res_format=JSON", OrgType = NA){
  # Bring in the  starting point html
  returnNames <- c()
  #Boolean to know if it has already used the base case
  baseCase <- TRUE
  #This is the URL offset counter, starts at 2 because we start using it on the second page we scrape
  OffsetCounter <- 2

  #ensuring correct entries parameters
  if(entries < 1){
    stop("Entries wanted need to be at least 1")
  }

  # ensuring correct format parameter
  validFormats <- c("json", "JSON", "csv", "CSV","/?res_format=CSV&res_format=JSON", "all")
  if(!(format %in% validFormats)){
    stop("Invalid format parameter, please use ?explore_datasets for valid entries")
  }


  # ensuring correct format parameter
  validOrgType <- c("Federal Government","City Government" , "State Government", "County Government", "University" )
  if(!is.na(OrgType)){
    if(!(OrgType %in% validOrgType)){
      stop("Invalid Organization Type parameter, please use ?explore_datasets for valid entries")
    }}

  #Creating the URL and giving Information
  startingPoint <- "https://catalog.data.gov/dataset"
  url_info <- creatingFilteredURL(startingPoint ,format =  format, OrgType = OrgType)
  full_url <- url_info[1]
  FirstParameter <- url_info[2]

  #Scaping the URL created
  full_url <- as.character(full_url)
  html <- read_html(full_url)

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
      html <- read_html(newURL)

      #finding the link tags with the titles
      aTag <-html  %>% html_nodes('.dataset-heading') %>% html_nodes('a')
      #If this new page does not have any entries, there are no more dataset names
      if(length(aTag) == 0){
        return(returnNames)
      }
      #add dataset names on new page to the return list
      names <- aTag %>% html_text()
      returnNames <- append(returnNames, names)
      OffsetCounter <- OffsetCounter + 1

    }
  }
  return(returnNames[0:entries])
}


