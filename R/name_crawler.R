
library(rvest)

library(purrr)

#future parameters could be filter conditions so they can filter by certain area or by type of file
name_crawler <- function(entries){
  # Bring in the  starting point html
  returnNames <- c()
  #Boolean to know if it has already used the base case
  baseCase <- TRUE
  #This is the URL offset counter, satarts at 2 because we start using it on the second page we scrape
  OffsetCounter <- 2
  #scraping the root url
  startingPoint <- "https://catalog.data.gov/dataset"
  html <- read_html(startingPoint)

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
titles <- name_crawler(35)
titles

# Function takes off all punctuation from a string in the format we need (periods call for spaces)
removeSymbol <- function(symbol,stringToChange){
  # Want to do space between periods because we have to make them dashes when turning them to URL
  if(symbol == "\\."){stringToChange <-  gsub(symbol, " ", stringToChange)
  }
  else{ stringToChange <- gsub(symbol,"",stringToChange)}

  return(stringToChange)
}

#tests for this function
j <- removeSymbol("\\.", "U.S. Chronic Disease Indicators (CDI)")
j

j <- removeSymbol("\\(", "U.S. Chronic Disease Indicators (CDI)")
j

#removes all the symbols we want from a vector
removingSymbols <- function(vectorToChange) {
  symbols <- c("!","@","#", "$", "%", "^", "&", "*", "(",")","-","+","=", "{", "}", "|", ".", ",", "?","<",">")
  symbolsSimplified <- c("&", "*", "\\(","\\)", "\\.", ",", "'", ":")
  newTitleVector <- c()

  for(word in vectorToChange ){
    # make the variable you will return the OG word before you start fixing it
    newtitle <- word
    for(character in symbolsSimplified ){
      #each time you remove an item save it in the same variable name to keep the changes
      newtitle <- removeSymbol(character, newtitle)
    }
    #save the new title without the symbols on the variable we will return
    newTitleVector <- append(newTitleVector, newtitle)
  }
  return(newTitleVector)
}

new <- removingSymbols(titles)
length(new)

#Test our function!
for(index in 1:length(new) ){
  cat("The Index is ", index, " the URL is ", new[index], "\n")
  hello <- get_gov_file(new[index],'csv')
  cat("\n",hello,"\n")
}

#"*  *" Hopefully this can be the regular expression to be able to have anything in both sides but two spaces, then we replace that with just one "

#would be better but doesnt work bc sub only replaces the first symbol it finds not all the symbols
removeSymbolVector <- function(symbol,vectorChange){
  if(symbol == "."){
    vectorChange <-  sub(symboltrans, " ", vectorChange)
  }else{ vectorChange <- sub(symbol,"",stringToChange)}
  return(vectorChange)
}

k <- removeSymbolVector(".", titles)
k

change2 <- sub("\\.", " ", titles)
change2[8]

#Getting all the links(dont think its necessary)
urls <- html_attr(aTag,'href')
