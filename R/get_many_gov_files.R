library(rvest)
library(stringr)
library("htmltools")
library("xml2")
library(tidyverse)
library(readr, include.only = 'read_csv', 'locale')
#install.packages("rjson")
library(rjson)
library(XML)
library(methods)


#' Download and Import Multiple CSV Data Sets at the Same Time
#'
#'Scrape <http://www.data.gov> website and automatically download CSV type data. The function takes a vector of data set names, downloads each data set, and imports
#'it into the RStudio environment as a list of dataframes.
#'
#' @param name_vector The vector of the names of the datasets to be downloaded.
#' @param import Decides if we locally download the file. By default import is TRUE.
#'
#' @return Locally download the data files and import them to the RStudio environment as a list of dataframes.
#' @export
#'
#' @examples
#'
#' library(CodeGovern)
#'
#' #if you want file to locally import, delete import parameter, by default import = TRUE
#' my_names <- c("FDIC Failed Bank List", "Demographic Statistics By Zip Code")
#' get_many_gov_files(my_names, import = FALSE)
#' @import dplyr
#' @import xml2
#' @import rvest
#' @import stringr
#' @import htmltools
#' @import tidyverse
#' @import rjson
#' @import methods
#' @import XML
#' @importFrom utils "browseURL" "download.file"
#' @importFrom readr "read_csv" "locale"


get_many_gov_files <- function(name_vector, import = TRUE){
  prefix <- "https://catalog.data.gov/dataset"

  output_list <- NULL #create an empty list

  #Specific name needs to be lowercase and with dashes between words
  for(name in name_vector){
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
    typeTogether <- paste0(first, "csv", last)
    #print(typeTogether)

    #https://stackoverflow.com/questions/45256789/get-value-from-xml-with-r-by-attribute
    #find the xml that is a link with data-format attribute of the type asked
    final <- xml_find_all(html, typeTogether)
    final <- html_attr(final, 'href')
    #print(final)

    name <- gsub(" ", "", name)
    filename <- str_c(name, ".", "csv")

    if(import){
      # CSV file
      tryCatch(
        expr = {
          download.file(url = final, destfile = filename, overwrite = T)
          output_list[[name]] <- read_csv(filename, locale=locale(encoding="latin1")) #add the data to the empty list
        },
        warning = function(w){  # Specifying warning message
          #message("Redirecting")
          message(paste0("Redirecting to this page: ", final))
          browseURL(final)
        }
      )
    }

  }
  return(output_list )
}
