#' Alert user if data is Non-Federal
#'
#' @param name name of the data set
#'
#' @return A statement notifying whether the data is Federal or Non-Federal
#' @export
#'
#' @examples
#' federal_alert("Electric Vehicle Population Data")
#' federal_alert("FDIC Failed Bank List")
federal_alert <- function(name) {
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
  alert <- html%>%
    html_elements(".non-federal")

  if(length(alert)==0) {
    print("This a Federal dataset covered by Data.gov's Terms of Use")
  }else{
    print("Alert: This is a Non-Federal dataset covered by different Terms of Use than Data.gov")
  }

}
