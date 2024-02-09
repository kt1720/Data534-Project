################ Test Data #####################################################
judge_on_salary_range <- tibble::tibble(minimum_salary = 360543.8, maximum_salary = 379444.2)
ds_bc_salary_range <- tibble::tibble(minimum_salary = 47153.6	, maximum_salary = 173804.8)
miss_input_salary_range <- tibble::tibble(minimum_salary = NaN, maximum_salary = NaN)
data_occupations <- c("Data entry clerks", "Data scientists", "Database analysts and data administrators")
science_occupations <- c(
  "Architecture and science managers",
  "Other professional occupations in physical sciences",
  "Natural and applied science policy researchers, consultants and program officers",
  "Other professional occupations in social science, n.e.c.",
  "Other professional occupations in social science")

################ Test Suites ###################################################
# test suite 1: Check if the API call returns a dataframe with the expected dimension or error message.
test_that("Check if the API call returns a dataframe with expected dimension",{
  expect_equal(dim(get_wage(2014)), c(6760, 7))

  expect_equal(dim(get_wage(c(2022, 2023))), c(12708, 7))

  expect_error(get_wage(2023, "Empty"), "No API key set yet. To set your API key, try running the command Sys.setenv(CKAN_API_KEY = ' '). Fill in the space between ' ' with your API key, from your user account on the CKAN site.", fixed = T)
})

# test suite 2: Check if the salary range function returns the expected data frame.
test_that("Check if salary_range returns the expected dataframe",{
  expect_equal(salary_range(get_wage(c(2022, 2023)), 'Judges', 'ON'), judge_on_salary_range)

  expect_equal(salary_range(get_wage(2023), 'Data scientists', 'BC'), ds_bc_salary_range)

  expect_equal(salary_range(get_wage(2023), 'ss', 'ss'), miss_input_salary_range)
})

# test suite 3: Check if the list occupation function returns the expected occupation list.
test_that("Check if list_occupation returns the expected vector",{
  expect_equal(list_occupations(get_wage(2023), 'data'), data_occupations)

  expect_equal(list_occupations(get_wage(c(2022, 2023)), 'science'), science_occupations)

  expect_error(list_occupations(get_wage(c(2022, 2023)), 'data science'), 'There is no occupation that matches the input provided.')
})

