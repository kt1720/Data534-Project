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
remotes::install_github("kt1720/canwage")
library(canwage)
# Set API key as an enviornment variable
Sys.setenv(CKAN_API_KEY = "")
```

## Functions

### Accessing the wage data

**canwage** connects user to the wage data through the `get_wage` function. Since the API call will return the data in JSON format, `get_wage` will also handle the data cleaning to ensure the end user receive the data in a clean dataframe/tibble format.

`get_wage` takes two parameters, the first parameter could be a single year integer or a vector of year integers depending on the year or years of data that the users want to access. The second parameter is the API key, the default is to get the CKAN_API_KEY inside the environment variable. 

```r
# Returns a data frame with a single year data
wage_2023 <- get_wage(2023)

# Returns a data frame with multiple years data
wage_multi_years <- get_wage(c(2021, 2022, 2023))
```

### Wage Datasets

As previously mentioned, the Wage dataset from the Canada Open Data website only provides API access to the 2012-2016 and 2019-2023 dataset. Therefore, the year integer `get_wage` can accept would be 2012, 2013, 2014, 2015, 2016, 2019, 2020, 2021, 2022 and 2023. Any other integer passes into the function would return an error in the API call. And as data for future years becomes available, they will be added into the input parameter list.

The dataset contains three numerical columns that display the minimum, median, and maximum wage estimates for different occupations. But since the data is coming from different government organizations, some of the data are displayed in annual salary and some are displayed as hourly wage. Therefore, in order to achieve a consistent unit in these three columns, I transformed all rows with hourly wage data by using it to multiply by 40 and then by 52, assuming 40 is the hours worked in a typical work week and 52 is the number of weeks in a year.

### Occupations

Since the data is published by the government organization, all occupations are based on the National Occupational Classification. **canwage** provides a function, `list_occupations(dataset, str)`, to display all the occupations listed in the dataset that match the user input string.

```r
list_occupations(wage_2023, "data")
```

### Salary range

In addition to the list of occupation, the dataset also provides minimum and maximum salary estimates for most occupations listed in the dataset. Users can access this information by calling the `salary_range(dataset, job, province)` function. If the input dataframe only contains a single year of salary data, the function will return the respective minimum and maximum salary estimates for the specific job in the specific province. If the input dataframe contains multiple year of salary data, the function will return the average minimum and maximum salary estimates for the specific job in the specific provinces across all years.

```r
salary_range(wage_multi_years, "Secondary school teachers")
```

### Missing values

In this part, we addressed the dataset's missing values to give package users an insight into the raw datasets from the Canadian government. We have already have the data set of multiple years' wage situations across Canada. The only parameter of this `process_NA()` function is the data set we get from calling the `get_wage()` above and it returns a data set without all of the missing values.

```r
new_dataset <- process_NA(wage_multi_years)
```

Two plots about missing values will be generated. In the first plot, the color red represents missing values, x axis is the column names, namely variables and y axis represents the proportion of missing values. We can infer from the plot that all missing values are in the wage related columns, their respective proportions are all around 40%.

In the second plot, the color red still represents missing values and the color grey represents data value. The darker the grey, the higher the value. This gives us a sense about where these missing values are located. It is safe to conclude from the plot that there is not much of a pattern of missing values in this data set. This might suggest that missing values are MCAR or MAR.

### Outliers

**canwage** provides a `process_outlier()` function. The only parameter here needed is the new data set we get from above without missing values. 

```r
process_outlier(new_dataset)
```

To identify outliers, data is grouped by the occupation and we used the IQR method to identify any potential outliers and the occupation group they belong to. In a certain occupation category, wage related values are given an outlier score. The score 0 indicates the values are in the IQR range, and any value that is non-zero suggests an outlier.I listed alphabetically the occupations that have outliers in them among wage related variables. Note that almost all occupations have outlier wage values. To investigate into the outliers, package users are given the chance to choose which occupation they want to look into. Once the occupation is chosen, there will be two plots drawn.

The first plot shows the percentage of outliers in each wage category and the second plot gives a rough grid representation of outliers' situation.

### Wage bar plot

**canwage** provides a function `average_median_bar_plot()`. The only parameter needed in the `average_bar_plot()` function is the new data set mentioned above. In this function, package users will be prompted twice. First, they will be prompted to enter the year of interest. In each year, the data set will have a list occupations whose wage salaries are accessible. Package users will be asked to choose one job that they are particularly attentive to. A bar plot will be shown about the average median salary in different provinces out of the data available. 

```r
average_median_bar_plot(new_dataset)
```

### Wage Map

For a more direct visualization of the median wage data for a specific occupation across Canada, **canwage** provides a `map(dataset, job)` function that shows an interactive Canadian map with the median wage information. If the dataset passed into the function only contains a single year of wage data, the plot will show a static map that displays the respective occupation's median salary across Canada. If the input dataset contains multiple years of wage data, the plot will instead show an animated map that displays the respective occupations's median salary across Canada over the years.  

```r
# Returns an interactive static map that outline the median salary of a legislator across Canada in 2023
map(wage_2023,"Legislators")

# Returns an interactive animated map that outline the median salary of a legislator across Canada over the years.
map(wage_multi_years, "Legislators")
```

### Display the trend of wage based on provinces and occupations

#### Overall View

In the first example, just need to put mandatory parameters(dataset, type=\` overall \`), the other having used default parameters to draw.

As the plot shows, there are two sub-plot used to interpret the overall trend. One is boxplot, apart from knowing the distribution of the wage,which you can also compare the number of samples in different provinces based on the size of the box; The other one is line plot which you can intuitively recognize the thread of different province.

```{r}
trend(wage_multi_years,"overall")
```

#### Specific View

In the second example, just need to put mandatory parameters(dataset, `type=specific`), the other having used default parameters to draw.

As the plot shows, there are two facets describing the wage trend based on `provs=c("Ontario","British Columbia")` and `positions=c("Legislators")`. You can see the interval of wage of Legislators in Ontario is better than British Columbia. While British Columbia is more stable.

```{r}
trend(wage_multi_years,"specific")
```

The following examples are used to show the parameters you can change.

If you choose the `type=overall`, the only parameter you can change is `filte` which means you can decide the outliers you based on your knowledge. By the way, the default value is 100000000.

When we set `filte=200000`, it is easier to see the scenario of common people.

```{r}
trend(wage_multi_years,"overall",filte=200000)
```

If you choose the `type=specific`, you can also change the parameter `filte` based on your knowledge. In addition, you can also change the parameters province using `provs`and occupation using `positions`. Note both of these two parameters need to vector types.

As the plot shows, **Computer and information systems managers** is highest paid occupation, **Data entry clerks** gains lowest paid among four jobs within the range from 30000 to 60000. Data Scientists are just started occupation.

```{r}
trend(wage_multi_years,"specific",provs=c("Alberta","British Columbia","Ontario","Quebec"),positions=c("Data entry clerks","Database analysts and data administrators","Data scientists","Computer and information systems managers"))
```

## Vignettes

*[canwage vignettes]("vignettes/vignettes.Rmd")

## License

**canwage** was created by Eden Chen, Jade Yu and Kyle Deng.
It is licensed under the terms of the [MIT license](LICENSE).

## Reference

von Bergmann, J., Aaron Jacobs, Dmitry Shkolnik (2022). cancensus: R package to access, retrieve, and work with Canadian Census data and geography. v0.5.6.
