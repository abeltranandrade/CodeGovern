library(rvest)
library(stringr)
library("htmltools")
library("xml2")
library(tidyverse)
library(readr)
#install.packages("rjson")
library(rjson)
library(XML)
library(methods)

#' Download/Import CSV, JSON, XML files.
#'
#' Scrape <http://www.data.gov> website and automatically download data.  For CSV file type, the function will download the file locally and return a data frame.
#' For JSON the function will download the file locally and return the raw JSON file. For XML, the function will download the file locally.
#'
#' @param name name of the data set
#' @param type data file type (csv, json, xml)
#'
#' @return Locally download the data file and import it to the RStudio environment
#' @export
#'
#' @examples
#'
#' library(CodeGovern)
#'
#' get_gov_file("Electric Vehicle Population Data", "json")
#' get_gov_file("Lottery Powerball Winning Numbers Beginning 2010", "csv")
#' @import dplyr
#' @import xml2
#' @import rvest
#' @import stringr
#' @import htmltools
#' @import tidyverse
#' @import readr
#' @import rjson
#' @import methods
#' @import XML
get_gov_file <- function(name, type){
  prefix <- "https://catalog.data.gov/dataset"
  #Specific name needs to be lowercase and with dashes between words
  specific <- tolower(name)
  specific <- gsub(" ", "-", specific)
  # paste the prefix and name together with a slash and no spaces
  full_url <- paste0(prefix,"/", specific, sep = "")
  #Ensure that dataset requested exists
  tryCatch(
    expr = {html <- read_html(full_url)},
    error = function(e){          # Specifying error message
      message("There was an error. The dataset was not found")
    }
  )
  #get HTML of the name given
  html <- read_html(full_url)

  # creating the XML command to find the data they are looking for
  first <- ".//a[@data-format='"
  last <- "']"
  typeTogether <- paste0(first, type, last)

  #https://stackoverflow.com/questions/45256789/get-value-from-xml-with-r-by-attribute
  #find the xml that is a link with data-format attribute of the type asked
  final <- xml_find_all(html, typeTogether)
  final <- html_attr(final, 'href')

  filename <- str_c(name, ".", type)

  # CSV file
  tryCatch(
    expr = {
      if(type == "csv"){
        download.file(url = final, destfile = filename, overwrite = T)
        return(read_csv(filename))
        # JSON file
      } else if(type == "json"){
        file_downloaded <- download.file(url = final, destfile = filename, overwrite = T)
        #https://www.educative.io/answer\s/how-to-read-json-files-in-r
        myData <- fromJSON(file = filename)
        return(myData) #returns the Json file raw
      }
      # XML file: function does not return anything, just donwloads the function locally
      else if(type =="xml"){
        download.file(url = final, destfile = filename, overwrite = T)
      } else {
        print("File type not supported currently you entered the type incorrectly. Redirecting to the website...")
        browseURL(full_url)
      }
    },
    warning = function(w){  # Specifying warning message
      #message("Redirecting")
      message(paste0("Redirecting to this page: ", final))
      browseURL(final)
    }
  )
}
