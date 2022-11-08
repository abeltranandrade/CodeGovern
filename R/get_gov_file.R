library(rvest)
library(stringr)
library("htmltools")
library("xml2")

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

  # creating the XML command to find the data they are looking for
  first <- ".//a[@data-format='"
  last <- "']"
  typeTogether <- paste0(first, type, last)

  #https://stackoverflow.com/questions/45256789/get-value-from-xml-with-r-by-attribute
  #find the xml that is a link with data-format attribute of the type asked
  final <- xml_find_all(html, typeTogether)
  final <- html_attr(final, 'href')

  return(final)

}

#https://stackoverflow.com/questions/9882257/how-to-reference-a-long-class-name-with-spaces-in-css
#This below is all just experimenting
name <- "Lottery Powerball Winning Numbers Beginning 2010"
print(get_gov_file(name, "json"))
#
test <- read_html("https://catalog.data.gov/dataset/lottery-powerball-winning-numbers-beginning-2010")
#
# sections <- test %>% html_elements("item prop")
#
# #. means class
# tag <- test %>% html_elements(".btn-group")
#
# link <- test %>% html_elements("a") %>% html_attr("title")
#https://stackoverflow.com/questions/45170353/how-can-i-conditionally-select-attributes-from-html-nodes-with-rvest

 link <- test %>% html_elements("#dataset-resources") %>% html_elements("a")
##this was not allowed because at the end I am searching for two classes. Class names cannot have spaces that is just one
 btnlink <- test %>% html_elements("#dataset-resources") %>% html_elements("a") %>% html_elements(".btn btn-primary")

 btnlink2 <- test %>% html_elements("#dataset-resources") %>% html_elements(".btn-primary") %>% html_elements("a")

 #https://stackoverflow.com/questions/45450981/rvest-scrape-2-classes-in-1-tag
 # use node to bring back nodes, you can also use the not to have the class include some or not the others (can have multiple classes if it has a space)
 btnlink3 <- test %>% html_nodes("#dataset-resources") %>% html_nodes(".btn-primary:not(.btn-preview)")


 class(btnlink3)
 btnlink3 %>% html_text2()
#https://www.red-gate.com/simple-talk/wp-content/uploads/imported/1269-Locators_table_1_0_2.pdf?file=4937 (from one liner guy )
 #https://stackoverflow.com/questions/45170353/how-can-i-conditionally-select-attributes-from-html-nodes-with-rvest
 # look at difference between doing .// and //
 format <- btnlink3 %>%  xml_find_all('//*[@data-format]')

 links <- xml_find_all(test,'.//a')

 attribu <- xml_find_all(links, './/*[@data-format]')



 format2 <- btnlink3 %>%  xml_find_all('//*[@data-format]') %>%
   xml_attrs()

format3 <- btnlink3 %>%  xml_find_all('//*[@data-format]')

Working <- test %>% xml_find_all('//*[@data-format]')

lol <-  xml_attr(format3, "data-format")
type <- "csv"

 match(lol, type)

is_it_type(attribute, type) {
  if(attribute == type ){
    return(TRUE)
  }
  return(FALSE)
}

 types <- btnlink3 %>%  html_attrs()


#https://stackoverflow.com/questions/45256789/get-value-from-xml-with-r-by-attribute
final <- xml_find_all(test, ".//a[@data-format='csv']") #|> xml_text()
final %>%  html_attr('href')

 xml_find_all(test, ".//a[@data-format='csv']") #|> xml_attrs('href')

# btnlink <- test %>% html_elements("#dataset-resources") %>% html_elements(".btn btn-primary")
#
# text <- link %>% html_elements(".btn btn-primary")
