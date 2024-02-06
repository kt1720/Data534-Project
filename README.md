# Canwage

<!-- badges: start -->
[![Unit test run](https://github.com/kt1720/Data534-Project/actions/workflows/coverage.yml/badge.svg)](https://github.com/kt1720/Data534-Project/actions/workflows/coverage.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
<!-- badges: end -->

## Introduction

As job seekers, we often find it difficult to obtain salary information on the role we are applying to. Therefore, having access to reliable salary information on different jobs can not only help us in deciding whether to apply for a specific role, but can also be helpful in salary negotiation after receiving an offer. With this mission in mind, the **canwage** package will serve as an API wrapper and provide functionality to users to access annual wage data published by Canada Open Data through API access. 

## API

We use wage data from [Canada Open Data](https://open.canada.ca/data/en/dataset/adad580f-76b0-4502-bd05-20c125de9116) website in 2012-2016 and 2019-2023. Although the 2017 and 2018 dataset are available to download in csv format on the website, they weren't published on the data API. Hence, there is no way to access them through API call.

This dataset published by the Canadian government institutions which means they are accurate, providing an overall reflection of the general state of the Canadian job market. Crawling from the website will deliver dataset to end users in JSON format.

At first, users need to apply to their own API keys [here](https://docs.ckan.org/en/2.8/api/)

## Installing the package

```r
# install.packages("canwage")
library(canwage)
# Set API key as an enviornment variable
Sys.setenv(CKAN_API_KEY = "")
```

Or alternatively, download the development version of the package from Github.
```r
# install.packages("devtools")
remotes::install("kt1720/canwage")
library(canwage)
# Set API key as an enviornment variable
Sys.setenv(CKAN_API_KEY = "")
```

## Functions

### Accessing the wage data

**canwage** connects user to the wage data through the `get_wage` function. Since the API call will return the data in JSON format, `get_wage` will also handle the data cleaning to ensure the end user receive the data in a clean dataframe/tibble format.

`get_wage` takes two parameters, the first parameter could be a single year integer or a vector of year integers depending on the year or years of data that the users want to access. The second parameter is the API key, the default is to get the CKAN_API_KEY inside the environment variable. 

``` r 
# Returns a data frame with a single year data
wage_2023 <- get_wage(2023)

# Returns a data frame with multiple years data
wage_multi_years <- get_wage(c(2021, 2022, 2023))
```

### Wage Datasets

As previously mentioned, the Wage dataset from the Canada Open Data website only provides API access to the 2012-2016 and 2019-2023 dataset. Therefore, the year integer `get_wage` can accept would be 2012, 2013, 2014, 2015, 2016, 2019, 2020, 2021, 2022 and 2023. Any other integer passes into the function would return an error in the API call. And as data for future years becomes available, they will be added into the input parameter list.

The dataset contains three numerical columns that display the minimum, median, and maximum wage estimates for different occupations. But since the data is coming from different government organizations, some of the data are displayed in annual salary and some are displayed as hourly wage. Therefore, in order to achieve a consistent unit in these three columns, I transformed all rows with hourly wage data by using it to multiply by 40 and then by 52, assuming 40 is the hours worked in a typical work week and 52 is the number of weeks in a year.

### Occupatons

Since the data is published by the government organization, all occupations are based on the National Occupational Classification. **canwage** provides a function, `list_occupations(dataset, str)`, to display all the occupations listed in the dataset that match the user input string.

``` r 
list_occupations(wage_2023, "data")
```

### Salary range

In addition to the list of occupation, the dataset also provides minimum and maximum salary estimates for most occupations listed in the dataset. Users can access this information by calling the `salary_range(dataset, job, province)` function. If the input dataframe only contains a single year of salary data, the function will return the respective minimum and maximum salary estimates for the specific job in the specific province. If the input dataframe contains multiple year of salary data, the function will return the average minimum and maximum salary estimates for the specific job in the specific provinces across all years.

``` r
salary_range(wage_multi_years, "Secondary school teachers")
```

### Wage Map

For a more direct visualization of the median wage data for a specific occupation across Canada, **canwage** provides a `map(dataset, job)` function that shows an interactive Canadian map with the median wage information. If the dataset passed into the function only contains a single year of wage data, the plot will show a static map that displays the respective occupation's median salary across Canada. If the input dataset contains multiple years of wage data, the plot will instead show an animated map that displays the respective occupations's median salary across Canada over the years.  
``` r
# Returns an interactive static map that outline the median salary of a legislator across Canada in 2023
map(wage_2023,"Legislators")

# Returns an interactive animated map that outline the median salary of a legislator across Canada over the years.
map(wage_multi_years, "Legislators")
```

## Vignettes

*[canwage vignettes]()

## License

**canwage** was created by Eden Chen, Jade Yu and Kyle Deng.
It is licensed under the terms of the [MIT license](LICENSE).

## Reference

von Bergmann, J., Aaron Jacobs, Dmitry Shkolnik (2022). cancensus: R package to access, retrieve, and work with Canadian Census data and geography. v0.5.6.

