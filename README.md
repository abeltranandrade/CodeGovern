Lika Mikhelashvili, Adriana Beltran Andrade, Vibha Gogu

<!-- README.md is generated from README.Rmd. Please edit that file -->

# CodeGovern <img src="data-raw/hex_codegovern_US_colors-removebg-preview.png" align="right" height=140/>

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/CodeGovern)](https://CRAN.R-project.org/package=CodeGovern)
[![R-CMD-check](https://github.com/abeltranandrade/CodeGovern/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/abeltranandrade/CodeGovern/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

### Purpose

Code Govern is a package used to scrape, import, and download datasets
and metadata from the website [Data.gov](https://data.gov/). This
website is the federal government’s open data site, and has over 298,424
datasets available to download in various export types (i.e., .csv,
.xml, .json). Using **CodeGovern** functions, the data can be easily
downloaded onto your computer, or for .csv files, return the data
directly in RStudio. The user can also view the list of available
datasets and get an alert if the data is federal or non-federal. Our
functions currently support the download of CSV, JSON, and XML file
types.

### Target audience

This package is intended for users who want to work with the open
government data without having to repetitively download data and prefer
not to work with the [Data.gov](https://data.gov/) interface. This
package is also useful for those with domain knowledge who want to start
working with data but want a more seamless experience given their
limited experience.

### Installation

You can install the development version of **CodeGovern** as follows:

``` r
devtools::install_github("abeltranandrade/CodeGovern")
```

You can also clone the repository and install it through the Rstudio
build panel.

### Functions/Datasets Included

The following functions allow the user to scrape and download data,
explore available datasets on the website, and view if the data of
interest is of federal or non-federal origin.

-   `get_gov_file` downloads and imports a single dataset of type CVS,
    JSON, and XML

-   `get_many_gov_files` downloads multiple datasets of type CSV and
    returns a list of data frames

-   `explore_datasets` gives the names of the datasets available on the
    [Data.gov](https://data.gov/) website.

-   `federal_alert` alerts user if dataset is Non-Federal.

-   `Lottery2010` A popular dataset from data.com already available in
    the package.

### Usage

These are a few examples of how to use the package to scrape data from
[Data.gov](https://data.gov/).

Load `CodeGovern` R package:

``` r
library(CodeGovern)
```

1.  Download [Electric Vehicle Population
    Data](https://catalog.data.gov/dataset/electric-vehicle-population-data)
    in JSON format and [Lottery Powerball Winning Numbers Beginning
    2010](https://catalog.data.gov/dataset/lottery-powerball-winning-numbers-beginning-2010)
    in CSV format.

``` r
#download the data set locally
get_gov_file("Electric Vehicle Population Data", "json") 

#download the data set locally and import it to the environment
my_data2 <-get_gov_file("Lottery Powerball Winning Numbers Beginning 2010", "csv") 
```

2.  Download [FDIC Failed Bank
    List](https://catalog.data.gov/dataset/fdic-failed-bank-list) and
    [Demographic Statistics By Zip
    Code](https://catalog.data.gov/dataset/demographic-statistics-by-zip-code)
    datasets in CSV format simultaneously.

``` r
#Create a list of dataset names
my_names <- c("FDIC Failed Bank List", "Demographic Statistics By Zip Code")

#Download the datasets and import them in the environment
my_datasets <- get_many_gov_files(my_names, import = TRUE)
```

3.  View whether the data of interest is a federal or non-federal
    origin.


``` r
federal_alert("Electric Vehicle Population Data")
#> [1] "Alert: This is a Non-Federal dataset covered by different Terms of Use than Data.gov"
```

4.  View the available datasets to download. Use ?explore_datasets to
    learn more about the valid inputs for format and Organization Type.

``` r
#returns the 10 most popular datasets available in csv and json currently
titles <- explore_datasets(10)
titles
#>  [1] "FDIC Failed Bank List"                                     
#>  [2] "Electric Vehicle Population Data"                          
#>  [3] "National Student Loan Data System"                         
#>  [4] "Crime Data from 2020 to Present"                           
#>  [5] "Dynamic Small Business Search (DSBS)"                      
#>  [6] "Alzheimer's Disease and Healthy Aging Data"                
#>  [7] "U.S. Chronic Disease Indicators (CDI)"                     
#>  [8] "Demographic Statistics By Zip Code"                        
#>  [9] "United States COVID-19 Cases and Deaths by State over Time"
#> [10] "Lottery Powerball Winning Numbers: Beginning 2010"

#returns the 21 most popular csv datasets from the Federal Government
titles1 <- explore_datasets(21, format = "csv", OrgType = "Federal Government")
titles1
#>  [1] "FDIC Failed Bank List"                                                                             
#>  [2] "Alzheimer's Disease and Healthy Aging Data"                                                        
#>  [3] "U.S. Chronic Disease Indicators (CDI)"                                                             
#>  [4] "United States COVID-19 Cases and Deaths by State over Time"                                        
#>  [5] "Consumer Complaint Database"                                                                       
#>  [6] "Walkability Index"                                                                                 
#>  [7] "Indicators of Anxiety or Depression Based on Reported Frequency of Symptoms During Last 7 Days"    
#>  [8] "Drug overdose death rates, by drug type, sex, age, race, and Hispanic origin: United States"       
#>  [9] "NCHS - Leading Causes of Death: United States"                                                     
#> [10] "Mental Health Care in the Last 4 Weeks"                                                            
#> [11] "Clean Air Status and Trends Network (CASTNET): Ozone"                                              
#> [12] "Nutrition, Physical Activity, and Obesity - Behavioral Risk Factor Surveillance System"            
#> [13] "FHFA House Price Indexes (HPIs)"                                                                   
#> [14] "Conditions Contributing to COVID-19 Deaths, by State and Age, Provisional 2020-2022"               
#> [15] "Death rates for suicide, by sex, race, Hispanic origin, and age: United States"                    
#> [16] "Obesity among children and adolescents aged 2–19 years, by selected characteristics: United States"
#> [17] "Heart Disease Mortality Data Among US Adults (35+) by State/Territory and County"                  
#> [18] "COVID-19 Vaccination and Case Trends by Age Group, United States"                                  
#> [19] "U.S. Electric Utility Companies and Rates: Look-up by Zipcode (2015)"                              
#> [20] "Meteorite Landings"                                                                                
#> [21] "Public School Characteristics 2019-20"
```

### Contributors

-   [Lika Mikhelashvili](https://github.com/lmikhelashvili)

-   [Vibha Gogu](https://github.com/vibhagogu)

-   [Adriana Beltran Andrade](https://github.com/abeltranandrade)
