Lika Mikhelashvili, Adriana Beltran Andrade, Vibha Gogu

<!-- README.md is generated from README.Rmd. Please edit that file -->

# CodeGovern <img src="data-raw/hex_codegovern.png" align="right" height=140/>

### Purpose

Code Govern is a package used to scrape and imports and downloads
datasets and metadata from the website Data.gov. This website is the
federal government’s open data site, and has over 298,424 datasets
available to download in various export types (i.e. .csv, .xml, .json).
Using CodeGovern functions, the data can be easily downloaded onto your
computer, or for .csv files, return the data directly in RStudio. The
function currently supports only three file types: CSV, JSON, and XML.

## Target audience

This package is intended for users who want to work with open government
data without having to repetitively download data and work with the
Data.gov interface. This package is also useful for those with domain
knowledge who want to start working with data but want a more seamless
experience given their limited experience.

## Testing

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/CodeGovern)](https://CRAN.R-project.org/package=CodeGovern)
<!-- badges: end -->

## Purpose

## Target Audience

## Installation

You can install the development version of CodeGovern like so:

``` r
devtools::install_github("abeltranandrade/CodeGovern")
```

Install our package by using devtools::install_github() as shown below.
You may also clone the repository and install it through Rstudio build
panel.

### Dependencies/Setup

Need to load the following libraries:

``` r
library(rvest)
library(stringr)
library("htmltools")
library("xml2")
library(tidyverse)
library(readr)
library(rjson)
```

### Arguments

`name` is the name of the dataset you want to download. The name should
be a string and should be worded exactly as it appears on the data.gov
website. Example, “Lottery Powerball Winning Numbers Beginning 2010”

`type`: type of the data set. Must be a string. For example, “csv”,
“json”, “xml”, etc.

`import`: Boolean that decides if file should be imported locally. By
default it is TRUE and will import locally. Used mostly for internal
processes.

### Result

The function returns a downloaded data file that the user can assign to
an object and import into the RStudio environment. The function
currently supports only three file types: CSV, JSON, and XML.

-   CSV: the function will download the file locally and return a data
    frame.

-   JSON: the function will download the file locally and return the raw
    JSON file.

-   XML: the function will download the file locally.

If the user enters any other file types, the function will put an error
message and redirect the user to the website of the data.

## Examples

``` r
library(CodeGovern)
my_data1 <- get_gov_file("Electric Vehicle Population Data", "json")
my_data2 <-get_gov_file("Lottery Powerball Winning Numbers Beginning 2010", "csv")
```

## Phase III Package

In Phase III we will be working on the same package as in Phase II. Now,
we have `get_gov_file` that downloads the data file. In the next phase,
we would want to expand get_gov_file or create a sister function that is
able to download multiple files in one function call through a vector
argument. We will create a function that gives a catalog of the data
sets on the [data.gov](http://www.data.gov) website through our function
that will return the names. We will also work on a function that gives
detailed information on the user’s data set of choice, e.g., the date
published.
